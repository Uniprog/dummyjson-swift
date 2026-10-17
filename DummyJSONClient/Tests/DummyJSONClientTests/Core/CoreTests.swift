import Foundation
import Testing
@testable import DummyJSONClient

@Suite("Core request execution")
struct CoreTests {
    @Test("Configuration, JSON headers, and unauthenticated request defaults")
    func constructsRequest() async throws {
        let transport = ControlledTransport(body: Data("[]".utf8))
        let configuration = DummyJSONConfiguration(baseURL: "https://example.com/api/", timeout: 12)
        let client = DummyJSONAPI(configuration: configuration, transport: transport)
        _ = try await client.productCategoryNames()
        #expect(client.configuration == configuration)
        let request = try #require(await transport.recordedRequests().first)
        #expect(request.url?.absoluteString == "https://example.com/api/products/category-list")
        #expect(request.timeoutInterval == 12)
        #expect(request.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(request.value(forHTTPHeaderField: "Content-Type") == nil)
        #expect(request.value(forHTTPHeaderField: "Authorization") == nil)
        #expect(!request.httpShouldHandleCookies)
    }

    @Test("Rejects invalid base URLs before calling transport", arguments: [
        "", "/relative", "file:///tmp/api", "ftp://example.com", "https://example.com?x=1",
        "https://example.com#fragment", "https://user:password@example.com", "https:///",
    ])
    func invalidBaseURL(baseURL: String) async throws {
        let transport = ControlledTransport(body: Data())
        let client = DummyJSONAPI(configuration: .init(baseURL: baseURL), transport: transport)
        await #expect(throws: DummyJSONError.self) { try await client.products() }
        #expect(await transport.recordedRequests().isEmpty)
    }

    @Test("Rejects invalid timeouts", arguments: [0.0, -1.0, Double.infinity, Double.nan])
    func invalidTimeout(timeout: Double) async throws {
        let transport = ControlledTransport(body: Data())
        let client = DummyJSONAPI(configuration: .init(timeout: timeout), transport: transport)
        await #expect(throws: DummyJSONError.self) { try await client.products() }
        #expect(await transport.recordedRequests().isEmpty)
    }

    @Test("Rejects invalid product query options before transport", arguments: [
        ProductQuery(limit: -1), ProductQuery(skip: -1), ProductQuery(delay: -1), ProductQuery(delay: 5001),
        ProductQuery(modifiedAfter: Date(timeIntervalSince1970: 2), modifiedBefore: Date(timeIntervalSince1970: 1)),
        ProductQuery(modifiedAfter: Date(timeIntervalSince1970: .infinity)),
    ])
    func invalidQuery(query: ProductQuery) async throws {
        let transport = ControlledTransport(body: Data())
        await #expect(throws: DummyJSONError.self) { try await DummyJSONAPI(transport: transport).products(query: query) }
        #expect(await transport.recordedRequests().isEmpty)
    }

    @Test("Rejects path traversal segments", arguments: ["", ".", ".."])
    func invalidPath(category: String) async throws {
        let transport = ControlledTransport(body: Data())
        await #expect(throws: DummyJSONError.self) { try await DummyJSONAPI(transport: transport).products(inCategory: category) }
        #expect(await transport.recordedRequests().isEmpty)
    }

    @Test("Preserves HTTP status, optional server message, and raw body without retrying", arguments: [400, 401, 404, 429, 500])
    func serverError(status: Int) async throws {
        let body = Data(#"{"message":"Product with id '999' not found","details":{"field":"id"}}"#.utf8)
        let transport = ControlledTransport(body: body, statusCode: status)
        do {
            _ = try await DummyJSONAPI(transport: transport).product(id: 999)
            Issue.record("Expected an HTTP error")
        } catch DummyJSONError.http(let statusCode, let message, let receivedBody) {
            #expect(statusCode == status)
            #expect(message == "Product with id '999' not found")
            #expect(receivedBody == body)
        }
        #expect(await transport.recordedRequests().count == 1)
    }

    @Test("Preserves non-JSON HTTP errors instead of reporting decoding failures")
    func nonJSONError() async throws {
        let body = Data("<html>Unavailable</html>".utf8)
        let transport = ControlledTransport(body: body, statusCode: 503)
        do {
            _ = try await DummyJSONAPI(transport: transport).products()
            Issue.record("Expected an HTTP error")
        } catch DummyJSONError.http(let status, let message, let receivedBody) {
            #expect(status == 503)
            #expect(message == nil)
            #expect(receivedBody == body)
        }
    }

    @Test("Malformed JSON and mismatched response shapes report underlying decoding errors", arguments: ["{", "{}", ""])
    func decodingError(body: String) async throws {
        let transport = ControlledTransport(body: Data(body.utf8))
        do {
            _ = try await DummyJSONAPI(transport: transport).products()
            Issue.record("Expected a decoding error")
        } catch DummyJSONError.decoding(let underlying) {
            #expect(underlying is DecodingError)
        }
    }

    @Test("Non-HTTP responses are rejected")
    func nonHTTPResponse() async throws {
        let transport = ControlledTransport { request in
            let url = try #require(request.url)
            return (Data("[]".utf8), URLResponse(url: url, mimeType: "application/json", expectedContentLength: 2, textEncodingName: nil))
        }
        do {
            _ = try await DummyJSONAPI(transport: transport).productCategoryNames()
            Issue.record("Expected an invalid-response error")
        } catch DummyJSONError.invalidResponse {}
    }

    @Test("Transport failures retain their original error")
    func transportError() async throws {
        let transport = ControlledTransport { _ in throw URLError(.notConnectedToInternet) }
        do {
            _ = try await DummyJSONAPI(transport: transport).products()
            Issue.record("Expected a transport error")
        } catch DummyJSONError.transport(let underlying) {
            #expect((underlying as? URLError)?.code == .notConnectedToInternet)
        }
        #expect(await transport.recordedRequests().count == 1)
    }

    @Test("Body encoding failures retain their original error")
    func encodingError() throws {
        do {
            _ = try Endpoint.encode(ProductMutationRequest(price: .infinity))
            Issue.record("Expected an encoding error")
        } catch DummyJSONError.encoding(let underlying) {
            #expect(underlying is EncodingError)
        }
    }

    @Test("Cancellation before execution never calls transport")
    func cancellationBeforeExecution() async throws {
        let transport = ControlledTransport(body: Data("[]".utf8))
        let task = Task {
            withUnsafeCurrentTask { $0?.cancel() }
            return try await DummyJSONAPI(transport: transport).productCategoryNames()
        }
        await #expect(throws: CancellationError.self) { try await task.value }
        #expect(await transport.recordedRequests().isEmpty)
    }

    @Test("In-flight task cancellation reaches transport and does not retry")
    func cancellationDuringExecution() async throws {
        let started = AsyncStream<Void>.makeStream()
        let transport = ControlledTransport { _ in
            started.continuation.yield(())
            try await Task.sleep(nanoseconds: 60_000_000_000)
            throw URLError(.timedOut)
        }
        let task = Task { try await DummyJSONAPI(transport: transport).products() }
        for await _ in started.stream { break }
        task.cancel()
        await #expect(throws: CancellationError.self) { try await task.value }
        #expect(await transport.recordedRequests().count == 1)
        started.continuation.finish()
    }

    @Test("URLSession-style cancellation stays a CancellationError")
    func transportCancellation() async throws {
        let transport = ControlledTransport { _ in throw URLError(.cancelled) }
        await #expect(throws: CancellationError.self) { try await DummyJSONAPI(transport: transport).products() }
    }

    @Test("Cancellation after transport returns is checked before decoding")
    func cancellationAfterTransport() async throws {
        let transport = ControlledTransport { request in
            withUnsafeCurrentTask { $0?.cancel() }
            let url = try #require(request.url)
            let response = try #require(HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil))
            return (Data("[]".utf8), response)
        }
        let task = Task { try await DummyJSONAPI(transport: transport).productCategoryNames() }
        await #expect(throws: CancellationError.self) { try await task.value }
    }

    @Test("One client can execute independent concurrent requests")
    func concurrentRequests() async throws {
        let transport = ControlledTransport(body: Data(#"["beauty"]"#.utf8))
        let client = DummyJSONAPI(transport: transport)
        try await withThrowingTaskGroup(of: [String].self) { group in
            for _ in 0..<20 {
                group.addTask { try await client.productCategoryNames() }
            }
            for try await names in group {
                #expect(names == ["beauty"])
            }
        }
        #expect(await transport.recordedRequests().count == 20)
    }
}
