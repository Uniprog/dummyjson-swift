public struct PostReactions: Codable, Equatable, Sendable {
    public let likes: Int
    public let dislikes: Int
}

public struct Post: Codable, Equatable, Sendable {
    public let id: Int
    public let title: String
    public let body: String
    public let tags: [String]
    public let reactions: PostReactions
    public let views: Int
    public let userId: Int
}

public struct PostTag: Codable, Equatable, Sendable {
    public let slug: String
    public let name: String
    public let url: String
}

public typealias PostListResponse = ResourcePage<Post>

public struct PostMutationRequest: Encodable, Equatable, Sendable {
    public let title: String?
    public let body: String?
    public let userId: Int?
    public let tags: [String]?
    public let reactions: PostReactions?

    public init(title: String? = nil, body: String? = nil, userId: Int? = nil, tags: [String]? = nil, reactions: PostReactions? = nil) {
        self.title = title
        self.body = body
        self.userId = userId
        self.tags = tags
        self.reactions = reactions
    }
}

public typealias CreatePostRequest = PostMutationRequest
public typealias ReplacePostRequest = PostMutationRequest
public typealias UpdatePostRequest = PostMutationRequest

public struct DeletePostResponse: Decodable, Sendable {
    public let post: Post
    public let isDeleted: Bool
    public let deletedOn: String

    public init(from decoder: any Decoder) throws {
        post = try Post(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isDeleted = try container.decode(Bool.self, forKey: .isDeleted)
        deletedOn = try container.decode(String.self, forKey: .deletedOn)
    }

    private enum CodingKeys: CodingKey { case isDeleted, deletedOn }
}
