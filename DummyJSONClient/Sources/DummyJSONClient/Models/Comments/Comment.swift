public struct CommentUser: Codable, Equatable, Sendable {
    public let id: Int
    public let username: String
    public let fullName: String
}

public struct Comment: Codable, Equatable, Sendable {
    public let id: Int
    public let body: String
    public let postId: Int
    public let likes: Int
    public let user: CommentUser
}

public typealias CommentListResponse = ResourcePage<Comment>

public struct CommentMutationRequest: Encodable, Equatable, Sendable {
    public let body: String?
    public let postId: Int?
    public let userId: Int?

    public init(body: String? = nil, postId: Int? = nil, userId: Int? = nil) {
        self.body = body
        self.postId = postId
        self.userId = userId
    }
}

public typealias CreateCommentRequest = CommentMutationRequest
public typealias ReplaceCommentRequest = CommentMutationRequest
public typealias UpdateCommentRequest = CommentMutationRequest

public struct DeleteCommentResponse: Decodable, Sendable {
    public let comment: Comment
    public let isDeleted: Bool
    public let deletedOn: String

    public init(from decoder: any Decoder) throws {
        comment = try Comment(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isDeleted = try container.decode(Bool.self, forKey: .isDeleted)
        deletedOn = try container.decode(String.self, forKey: .deletedOn)
    }

    private enum CodingKeys: CodingKey { case isDeleted, deletedOn }
}
