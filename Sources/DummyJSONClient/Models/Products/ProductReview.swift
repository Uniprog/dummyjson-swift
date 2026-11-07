public struct ProductReview: Decodable, Equatable, Sendable {
    public let rating: Int
    public let comment: String
    public let date: String
    public let reviewerName: String
    public let reviewerEmail: String

    public init(
        rating: Int,
        comment: String,
        date: String,
        reviewerName: String,
        reviewerEmail: String
    ) {
        self.rating = rating
        self.comment = comment
        self.date = date
        self.reviewerName = reviewerName
        self.reviewerEmail = reviewerEmail
    }
}
