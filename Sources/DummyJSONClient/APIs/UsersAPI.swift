import Foundation

extension DummyJSONAPI {
    public func users(query: ResourceQuery = .init()) async throws -> UserListResponse {
        try await execute(Endpoint(method: .get, path: ["users"], query: query.queryItems()))
    }
    public func searchUsers(_ search: String, query: ResourceQuery = .init()) async throws -> UserListResponse {
        try await execute(Endpoint(method: .get, path: ["users", "search"], query: query.queryItems() + [URLQueryItem(name: "q", value: search)]))
    }
    public func filterUsers(key: String, value: String, query: ResourceQuery = .init()) async throws -> UserListResponse {
        try await execute(Endpoint(method: .get, path: ["users", "filter"], query: query.queryItems() + [URLQueryItem(name: "key", value: key), URLQueryItem(name: "value", value: value)]))
    }
    public func user(id: Int) async throws -> User { try await execute(Endpoint(method: .get, path: ["users", String(id)])) }
    public func cartsForUser(id: Int, query: ResourceQuery = .init()) async throws -> CartListResponse {
        try await execute(Endpoint(method: .get, path: ["users", String(id), "carts"], query: query.queryItems()))
    }
    public func postsForUser(id: Int, query: ResourceQuery = .init()) async throws -> PostListResponse {
        try await execute(Endpoint(method: .get, path: ["users", String(id), "posts"], query: query.queryItems()))
    }
    public func todosForUser(id: Int, query: ResourceQuery = .init()) async throws -> TodoListResponse {
        try await execute(Endpoint(method: .get, path: ["users", String(id), "todos"], query: query.queryItems()))
    }
    public func addUser(_ request: CreateUserRequest) async throws -> UserMutationResponse { try await execute(Endpoint(method: .post, path: ["users", "add"], body: Endpoint.encode(request))) }
    public func replaceUser(id: Int, with request: ReplaceUserRequest) async throws -> UserMutationResponse { try await execute(Endpoint(method: .put, path: ["users", String(id)], body: Endpoint.encode(request))) }
    public func updateUser(id: Int, with request: UpdateUserRequest) async throws -> UserMutationResponse { try await execute(Endpoint(method: .patch, path: ["users", String(id)], body: Endpoint.encode(request))) }
    public func deleteUser(id: Int) async throws -> DeleteUserResponse { try await execute(Endpoint(method: .delete, path: ["users", String(id)])) }
}
