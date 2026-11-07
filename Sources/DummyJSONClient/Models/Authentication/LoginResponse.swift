public struct LoginResponse: Decodable, Equatable, Sendable {
    public let id: Int
    public let username: String
    public let email: String
    public let firstName: String
    public let lastName: String
    public let gender: String
    public let image: String
    public let accessToken: String
    public let refreshToken: String

    public init(
        id: Int,
        username: String,
        email: String,
        firstName: String,
        lastName: String,
        gender: String,
        image: String,
        accessToken: String,
        refreshToken: String
    ) {
        self.id = id
        self.username = username
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.gender = gender
        self.image = image
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
