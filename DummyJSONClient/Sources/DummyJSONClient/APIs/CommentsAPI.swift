extension DummyJSONAPI {
    public func comments(query: ResourceQuery = .init()) async throws -> CommentListResponse {
        try await execute(Endpoint(method: .get, path: ["comments"], query: query.queryItems()))
    }
    public func comment(id: Int) async throws -> Comment { try await execute(Endpoint(method: .get, path: ["comments", String(id)])) }
    public func comments(postId: Int, query: ResourceQuery = .init()) async throws -> CommentListResponse {
        try await execute(Endpoint(method: .get, path: ["comments", "post", String(postId)], query: query.queryItems()))
    }
    public func addComment(_ request: CreateCommentRequest) async throws -> Comment {
        try await execute(Endpoint(method: .post, path: ["comments", "add"], body: Endpoint.encode(request)))
    }
    public func replaceComment(id: Int, with request: ReplaceCommentRequest) async throws -> Comment {
        try await execute(Endpoint(method: .put, path: ["comments", String(id)], body: Endpoint.encode(request)))
    }
    public func updateComment(id: Int, with request: UpdateCommentRequest) async throws -> Comment {
        try await execute(Endpoint(method: .patch, path: ["comments", String(id)], body: Endpoint.encode(request)))
    }
    public func deleteComment(id: Int) async throws -> DeleteCommentResponse {
        try await execute(Endpoint(method: .delete, path: ["comments", String(id)]))
    }
}
