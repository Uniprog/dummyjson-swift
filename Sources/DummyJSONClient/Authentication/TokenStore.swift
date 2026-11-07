public struct AuthenticationTokens: Equatable, Sendable {
    public let accessToken: String
    public let refreshToken: String

    public init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}

public protocol TokenStore: Sendable {
    func tokens() async -> AuthenticationTokens?
    func save(_ tokens: AuthenticationTokens) async
    func clear() async
}

public actor InMemoryTokenStore: TokenStore {
    private var value: AuthenticationTokens?

    public init(tokens: AuthenticationTokens? = nil) {
        value = tokens
    }

    public func tokens() -> AuthenticationTokens? { value }
    public func save(_ tokens: AuthenticationTokens) { value = tokens }
    public func clear() { value = nil }
}
