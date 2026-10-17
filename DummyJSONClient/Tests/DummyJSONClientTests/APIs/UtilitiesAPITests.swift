import Foundation
import Testing
@testable import DummyJSONClient

@Suite("Utilities API")
struct UtilitiesAPITests {
    @Test("Uses caller-selected methods for utility routes")
    func selectedMethods() async throws {
        let transport = ControlledTransport { request in
            let url = try #require(request.url)
            let body: String
            if url.path.hasSuffix("/test") {
                body = #"{"status":"ok","method":"PATCH"}"#
            } else if url.path.contains("/http/201/") {
                body = #"{"status":201,"message":"Created here"}"#
            } else {
                body = #"{"received":true,"requestId":"request-1"}"#
            }
            let response = try #require(HTTPURLResponse(
                url: url, statusCode: 200, httpVersion: "HTTP/1.1",
                headerFields: ["Content-Type": "application/json"]
            ))
            return (Data(body.utf8), response)
        }
        let api = DummyJSONAPI(transport: transport)

        #expect(try await api.healthCheck(method: .patch).method == "PATCH")
        #expect(try await api.httpStatus(code: 201, message: "Created here").status == 201)
        #expect(try await api.captureWebhook(
            identifier: "hook",
            method: .put,
            body: .object(["value": .number(1)])
        ).received)

        let requests = await transport.recordedRequests()
        #expect(requests.map(\.httpMethod) == ["PATCH", "GET", "PUT"])
        #expect(requests[1].url?.path.hasSuffix("/http/201/Created here") == true)
        #expect(requests[2].httpBody != nil)
    }

    @Test("Returns binary image data without JSON decoding")
    func binaryData() async throws {
        let expected = Data([0x89, 0x50, 0x4E, 0x47])
        let transport = ControlledTransport(body: expected)
        let api = DummyJSONAPI(transport: transport)

        #expect(try await api.placeholderImage(size: "100x100") == expected)
        #expect(await transport.recordedRequests().first?.url?.path.hasSuffix("/image/100x100") == true)
    }

    @Test("Decodes TOTP response shape from the pinned controller")
    func totp() async throws {
        let transport = ControlledTransport(body: Data(#"{"totp":"123456","expiresIn":12,"period":30}"#.utf8))
        let response = try await DummyJSONAPI(transport: transport).totp(key: "JBSWY3DP")
        #expect(response.totp == "123456")
        #expect(response.period == 30)
        #expect(await transport.recordedRequests().first?.url?.query == "key=JBSWY3DP")
    }
}
