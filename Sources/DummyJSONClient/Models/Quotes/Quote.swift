public struct Quote: Codable, Equatable, Sendable {
    public let id: Int
    public let quote: String
    public let author: String

    public init(id: Int, quote: String, author: String) {
        self.id = id
        self.quote = quote
        self.author = author
    }
}

public typealias QuoteListResponse = ResourcePage<Quote>
