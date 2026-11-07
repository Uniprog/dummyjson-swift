import Foundation
import Testing
@testable import DummyJSONClient

@Suite("Authentication API")
struct AuthenticationAPITests {
    @Test("Authenticated requests refresh once and retry with the new bearer token")
    func refreshesAndRetries() async throws {
        let transport = try AuthenticationTransport()
        let store = InMemoryTokenStore(tokens: .init(accessToken: "expired", refreshToken: "refresh-1"))
        let api = DummyJSONAPI(transport: transport, tokenStore: store)

        let user = try await api.authenticatedUser()

        #expect(user.id > 0)
        #expect(await transport.refreshCount == 1)
        #expect(await transport.meCount == 2)
        #expect(await store.tokens() == .init(accessToken: "renewed", refreshToken: "refresh-2"))
    }

    @Test("Concurrent unauthorized requests share one refresh")
    func deduplicatesConcurrentRefresh() async throws {
        let transport = try AuthenticationTransport()
        let api = DummyJSONAPI(
            transport: transport,
            tokenStore: InMemoryTokenStore(tokens: .init(accessToken: "expired", refreshToken: "refresh-1"))
        )

        try await withThrowingTaskGroup(of: User.self) { group in
            for _ in 0..<8 {
                group.addTask { try await api.authenticatedUser() }
            }
            for try await user in group {
                #expect(user.id > 0)
            }
        }

        #expect(await transport.refreshCount == 1)
    }

    @Test("Logout clears local credentials")
    func logoutClearsTokens() async throws {
        let transport = try AuthenticationTransport()
        let store = InMemoryTokenStore(tokens: .init(accessToken: "renewed", refreshToken: "refresh-2"))
        let api = DummyJSONAPI(transport: transport, tokenStore: store)

        _ = try await api.logout()

        #expect(await store.tokens() == nil)
        await #expect(throws: DummyJSONError.self) {
            try await api.authenticatedUser()
        }
    }
}

private actor AuthenticationTransport: HTTPTransport {
    private let userData: Data
    private(set) var refreshCount = 0
    private(set) var meCount = 0

    init() throws {
        let url = try #require(Bundle.module.url(forResource: "users", withExtension: "json"))
        let users = try #require(JSONSerialization.jsonObject(with: Data(contentsOf: url)) as? [[String: Any]])
        userData = try JSONSerialization.data(withJSONObject: try #require(users.first))
    }

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        let url = try #require(request.url)
        let path = url.path
        if path.hasSuffix("/auth/refresh") {
            refreshCount += 1
            try await Task.sleep(for: .milliseconds(30))
            return response(for: url, status: 200, body: #"{"accessToken":"renewed","refreshToken":"refresh-2"}"#)
        }
        if path.hasSuffix("/auth/logout") {
            return response(for: url, status: 200, body: #"{"message":"Logged out"}"#)
        }
        if path.hasSuffix("/auth/me") {
            meCount += 1
            if request.value(forHTTPHeaderField: "Authorization") == "Bearer renewed" {
                return (userData, httpResponse(url: url, status: 200))
            }
            return response(for: url, status: 401, body: #"{"message":"Invalid token"}"#)
        }
        throw DummyJSONError.invalidRequest("Unexpected authentication test request.")
    }

    private func response(for url: URL, status: Int, body: String) -> (Data, URLResponse) {
        (Data(body.utf8), httpResponse(url: url, status: status))
    }

    private func httpResponse(url: URL, status: Int) -> HTTPURLResponse {
        HTTPURLResponse(url: url, statusCode: status, httpVersion: "HTTP/1.1", headerFields: nil)!
    }
}
