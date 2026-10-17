extension DummyJSONAPI {
    public func todos(query: ResourceQuery = .init()) async throws -> TodoListResponse {
        try await execute(Endpoint(method: .get, path: ["todos"], query: query.queryItems()))
    }

    public func todo(id: Int) async throws -> Todo {
        try await execute(Endpoint(method: .get, path: ["todos", String(id)]))
    }

    public func todos(userId: Int, query: ResourceQuery = .init()) async throws -> TodoListResponse {
        try await execute(Endpoint(method: .get, path: ["todos", "user", String(userId)], query: query.queryItems()))
    }

    public func randomTodo() async throws -> Todo {
        try await execute(Endpoint(method: .get, path: ["todos", "random"]))
    }

    public func randomTodos(count: Int) async throws -> [Todo] {
        guard count > 0 else { throw DummyJSONError.invalidRequest("Random todo count must be positive.") }
        return try await execute(Endpoint(method: .get, path: ["todos", "random", String(count)]))
    }

    public func addTodo(_ request: CreateTodoRequest) async throws -> Todo {
        try await execute(Endpoint(method: .post, path: ["todos", "add"], body: Endpoint.encode(request)))
    }

    public func replaceTodo(id: Int, with request: ReplaceTodoRequest) async throws -> Todo {
        try await execute(Endpoint(method: .put, path: ["todos", String(id)], body: Endpoint.encode(request)))
    }

    public func updateTodo(id: Int, with request: UpdateTodoRequest) async throws -> Todo {
        try await execute(Endpoint(method: .patch, path: ["todos", String(id)], body: Endpoint.encode(request)))
    }

    public func deleteTodo(id: Int) async throws -> DeleteTodoResponse {
        try await execute(Endpoint(method: .delete, path: ["todos", String(id)]))
    }
}
