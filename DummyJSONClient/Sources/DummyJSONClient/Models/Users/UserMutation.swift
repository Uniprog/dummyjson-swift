public typealias UserListResponse = ResourcePage<User>

public struct UserMutationRequest: Encodable, Equatable, Sendable {
    public let firstName: String?
    public let lastName: String?
    public let age: Int?
    public let email: String?
    public let phone: String?
    public let username: String?
    public let password: String?
    public let gender: String?
    public let image: String?

    public init(firstName: String? = nil, lastName: String? = nil, age: Int? = nil, email: String? = nil, phone: String? = nil, username: String? = nil, password: String? = nil, gender: String? = nil, image: String? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.email = email
        self.phone = phone
        self.username = username
        self.password = password
        self.gender = gender
        self.image = image
    }
}

public typealias CreateUserRequest = UserMutationRequest
public typealias ReplaceUserRequest = UserMutationRequest
public typealias UpdateUserRequest = UserMutationRequest

public struct UserMutationResponse: Decodable, Equatable, Sendable {
    public let id: Int
    public let firstName: String?
    public let lastName: String?
    public let age: Int?
    public let email: String?
    public let phone: String?
    public let username: String?
    public let gender: String?
    public let image: String?
}

public struct DeleteUserResponse: Decodable, Sendable {
    public let user: User
    public let isDeleted: Bool
    public let deletedOn: String

    public init(from decoder: any Decoder) throws {
        user = try User(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isDeleted = try container.decode(Bool.self, forKey: .isDeleted)
        deletedOn = try container.decode(String.self, forKey: .deletedOn)
    }

    private enum CodingKeys: CodingKey { case isDeleted, deletedOn }
}
