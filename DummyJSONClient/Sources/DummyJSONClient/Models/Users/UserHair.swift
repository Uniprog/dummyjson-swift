public struct UserHair: Decodable, Equatable, Sendable {
    public let color: String
    public let type: String

    public init(color: String, type: String) {
        self.color = color
        self.type = type
    }
}
