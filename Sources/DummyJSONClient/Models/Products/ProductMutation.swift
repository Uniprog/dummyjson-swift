public struct ProductMutationRequest: Encodable, Equatable, Sendable {
    public let title: String?
    public let price: Double?
    public let discountPercentage: Double?
    public let stock: Int?
    public let rating: Double?
    public let images: [String]?
    public let thumbnail: String?
    public let description: String?
    public let brand: String?
    public let category: String?

    public init(
        title: String? = nil,
        price: Double? = nil,
        discountPercentage: Double? = nil,
        stock: Int? = nil,
        rating: Double? = nil,
        images: [String]? = nil,
        thumbnail: String? = nil,
        description: String? = nil,
        brand: String? = nil,
        category: String? = nil
    ) {
        self.title = title
        self.price = price
        self.discountPercentage = discountPercentage
        self.stock = stock
        self.rating = rating
        self.images = images
        self.thumbnail = thumbnail
        self.description = description
        self.brand = brand
        self.category = category
    }
}

public struct ProductMutationResponse: Decodable, Equatable, Sendable {
    public let id: Int
    public let title: String?
    public let price: Double?
    public let discountPercentage: Double?
    public let stock: Int?
    public let rating: Double?
    public let images: [String]?
    public let thumbnail: String?
    public let description: String?
    public let brand: String?
    public let category: String?

    public init(
        id: Int,
        title: String?,
        price: Double?,
        discountPercentage: Double?,
        stock: Int?,
        rating: Double?,
        images: [String]?,
        thumbnail: String?,
        description: String?,
        brand: String?,
        category: String?
    ) {
        self.id = id
        self.title = title
        self.price = price
        self.discountPercentage = discountPercentage
        self.stock = stock
        self.rating = rating
        self.images = images
        self.thumbnail = thumbnail
        self.description = description
        self.brand = brand
        self.category = category
    }
}
