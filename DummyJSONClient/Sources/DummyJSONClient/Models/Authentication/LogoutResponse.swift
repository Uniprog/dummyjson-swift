public struct LogoutResponse: Decodable, Equatable, Sendable {
    public let message: String

    public init(message: String) {
        self.message = message
    }
}
