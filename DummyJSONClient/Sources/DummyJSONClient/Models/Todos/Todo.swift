public struct Todo: Codable, Equatable, Sendable {
    public let id: Int
    public let todo: String
    public let completed: Bool
    public let userId: Int

    public init(id: Int, todo: String, completed: Bool, userId: Int) {
        self.id = id
        self.todo = todo
        self.completed = completed
        self.userId = userId
    }
}

public typealias TodoListResponse = ResourcePage<Todo>

public struct TodoMutationRequest: Encodable, Equatable, Sendable {
    public let todo: String?
    public let completed: Bool?
    public let userId: Int?

    public init(todo: String? = nil, completed: Bool? = nil, userId: Int? = nil) {
        self.todo = todo
        self.completed = completed
        self.userId = userId
    }
}

public typealias CreateTodoRequest = TodoMutationRequest
public typealias ReplaceTodoRequest = TodoMutationRequest
public typealias UpdateTodoRequest = TodoMutationRequest

public struct DeleteTodoResponse: Decodable, Sendable {
    public let todo: Todo
    public let isDeleted: Bool
    public let deletedOn: String

    public init(from decoder: any Decoder) throws {
        todo = try Todo(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isDeleted = try container.decode(Bool.self, forKey: .isDeleted)
        deletedOn = try container.decode(String.self, forKey: .deletedOn)
    }

    private enum CodingKeys: CodingKey { case isDeleted, deletedOn }
}
