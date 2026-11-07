extension DummyJSONAPI {
    public func carts(query: ResourceQuery = .init()) async throws -> CartListResponse {
        try await execute(Endpoint(method: .get, path: ["carts"], query: query.queryItems()))
    }
    public func cart(id: Int) async throws -> Cart { try await execute(Endpoint(method: .get, path: ["carts", String(id)])) }
    public func carts(userId: Int, query: ResourceQuery = .init()) async throws -> CartListResponse {
        try await execute(Endpoint(method: .get, path: ["carts", "user", String(userId)], query: query.queryItems()))
    }
    public func addCart(_ request: CreateCartRequest) async throws -> Cart {
        try await execute(Endpoint(method: .post, path: ["carts", "add"], body: Endpoint.encode(request)))
    }
    public func replaceCart(id: Int, with request: ReplaceCartRequest) async throws -> Cart {
        try await execute(Endpoint(method: .put, path: ["carts", String(id)], body: Endpoint.encode(request)))
    }
    public func updateCart(id: Int, with request: UpdateCartRequest) async throws -> Cart {
        try await execute(Endpoint(method: .patch, path: ["carts", String(id)], body: Endpoint.encode(request)))
    }
    public func deleteCart(id: Int) async throws -> DeleteCartResponse {
        try await execute(Endpoint(method: .delete, path: ["carts", String(id)]))
    }
}
