import Foundation
import Testing
@testable import DummyJSONClient

@Suite("Authentication failures")
struct AuthenticationFailureTests {
    @Test("A rejected refresh clears the stored session")
    func rejectedRefreshClearsSession() async throws {
        let transport = FailingAuthenticationTransport(rejectRefresh: true)
        let store = InMemoryTokenStore(tokens: .init(accessToken: "expired", refreshToken: "invalid"))
        let api = DummyJSONAPI(transport: transport, tokenStore: store)

        await #expect(throws: DummyJSONError.self) {
            try await api.authenticatedUser()
        }

        #expect(await transport.refreshCount == 1)
        #expect(await store.tokens() == nil)
    }

    @Test("An authenticated request retries no more than once")
    func retriesOnlyOnce() async throws {
        let transport = FailingAuthenticationTransport(rejectRefresh: false)
        let store = InMemoryTokenStore(tokens: .init(accessToken: "expired", refreshToken: "valid"))
        let api = DummyJSONAPI(transport: transport, tokenStore: store)

        await #expect(throws: DummyJSONError.self) {
            try await api.authenticatedUser()
        }

        #expect(await transport.refreshCount == 1)
        #expect(await transport.protectedRequestCount == 2)
        #expect(await store.tokens() == .init(accessToken: "renewed", refreshToken: "renewed-refresh"))
    }

    @Test("Missing credentials fail without calling transport")
    func missingCredentials() async throws {
        let transport = FailingAuthenticationTransport(rejectRefresh: false)
        let api = DummyJSONAPI(transport: transport)

        await #expect(throws: DummyJSONError.self) {
            try await api.authenticatedUser()
        }

        #expect(await transport.protectedRequestCount == 0)
        #expect(await transport.refreshCount == 0)
    }
}

private actor FailingAuthenticationTransport: HTTPTransport {
    private let rejectRefresh: Bool
    private(set) var refreshCount = 0
    private(set) var protectedRequestCount = 0

    init(rejectRefresh: Bool) {
        self.rejectRefresh = rejectRefresh
    }

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        let url = try #require(request.url)
        if url.path.hasSuffix("/auth/refresh") {
            refreshCount += 1
            if rejectRefresh {
                return response(url: url, status: 401, body: #"{"message":"Invalid refresh token"}"#)
            }
            return response(
                url: url,
                status: 200,
                body: #"{"accessToken":"renewed","refreshToken":"renewed-refresh"}"#
            )
        }
        protectedRequestCount += 1
        return response(url: url, status: 401, body: #"{"message":"Unauthorized"}"#)
    }

    private func response(url: URL, status: Int, body: String) -> (Data, URLResponse) {
        let response = HTTPURLResponse(
            url: url,
            statusCode: status,
            httpVersion: "HTTP/1.1",
            headerFields: ["Content-Type": "application/json"]
        )!
        return (Data(body.utf8), response)
    }
}
