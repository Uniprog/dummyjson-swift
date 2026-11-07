public struct RefreshTokenRequest: Encodable, Equatable, Sendable {
    public let refreshToken: String
    public let expiresInMins: Int?

    public init(refreshToken: String, expiresInMins: Int? = nil) {
        self.refreshToken = refreshToken
        self.expiresInMins = expiresInMins
    }
}
