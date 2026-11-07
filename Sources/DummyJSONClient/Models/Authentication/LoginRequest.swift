public struct LoginRequest: Encodable, Equatable, Sendable {
    public let username: String
    public let password: String
    public let expiresInMins: Int?

    public init(username: String, password: String, expiresInMins: Int? = nil) {
        self.username = username
        self.password = password
        self.expiresInMins = expiresInMins
    }
}
