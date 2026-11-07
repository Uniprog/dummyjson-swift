import Foundation

extension DummyJSONAPI {
    public func posts(query: ResourceQuery = .init()) async throws -> PostListResponse {
        try await execute(Endpoint(method: .get, path: ["posts"], query: query.queryItems()))
    }
    public func searchPosts(_ search: String, query: ResourceQuery = .init()) async throws -> PostListResponse {
        try await execute(Endpoint(method: .get, path: ["posts", "search"], query: query.queryItems() + [URLQueryItem(name: "q", value: search)]))
    }
    public func post(id: Int) async throws -> Post { try await execute(Endpoint(method: .get, path: ["posts", String(id)])) }
    public func postTagNames() async throws -> [String] { try await execute(Endpoint(method: .get, path: ["posts", "tag-list"])) }
    public func postTags() async throws -> [PostTag] { try await execute(Endpoint(method: .get, path: ["posts", "tags"])) }
    public func posts(tag: String, query: ResourceQuery = .init()) async throws -> PostListResponse {
        try await execute(Endpoint(method: .get, path: ["posts", "tag", tag], query: query.queryItems()))
    }
    public func posts(userId: Int, query: ResourceQuery = .init()) async throws -> PostListResponse {
        try await execute(Endpoint(method: .get, path: ["posts", "user", String(userId)], query: query.queryItems()))
    }
    public func commentsForPost(id: Int, query: ResourceQuery = .init()) async throws -> CommentListResponse {
        try await execute(Endpoint(method: .get, path: ["posts", String(id), "comments"], query: query.queryItems()))
    }
    public func addPost(_ request: CreatePostRequest) async throws -> PostMutationResponse { try await execute(Endpoint(method: .post, path: ["posts", "add"], body: Endpoint.encode(request))) }
    public func replacePost(id: Int, with request: ReplacePostRequest) async throws -> PostMutationResponse { try await execute(Endpoint(method: .put, path: ["posts", String(id)], body: Endpoint.encode(request))) }
    public func updatePost(id: Int, with request: UpdatePostRequest) async throws -> PostMutationResponse { try await execute(Endpoint(method: .patch, path: ["posts", String(id)], body: Endpoint.encode(request))) }
    public func deletePost(id: Int) async throws -> DeletePostResponse { try await execute(Endpoint(method: .delete, path: ["posts", String(id)])) }
}
