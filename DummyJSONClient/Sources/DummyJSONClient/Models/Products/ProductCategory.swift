public struct ProductCategory: Decodable, Equatable, Sendable {
    public let slug: String
    public let name: String
    public let url: String

    public init(slug: String, name: String, url: String) {
        self.slug = slug
        self.name = name
        self.url = url
    }
}
