public struct Product: Decodable, Equatable, Sendable {
    public let id: Int
    public let title: String
    public let description: String
    public let category: String
    public let price: Double
    public let discountPercentage: Double
    public let rating: Double
    public let stock: Int
    public let tags: [String]
    public let brand: String?
    public let sku: String
    public let weight: Int
    public let dimensions: ProductDimensions
    public let warrantyInformation: String
    public let shippingInformation: String
    public let availabilityStatus: String
    public let reviews: [ProductReview]
    public let returnPolicy: String
    public let minimumOrderQuantity: Int
    public let meta: ProductMetadata
    public let images: [String]
    public let thumbnail: String

    public init(
        id: Int,
        title: String,
        description: String,
        category: String,
        price: Double,
        discountPercentage: Double,
        rating: Double,
        stock: Int,
        tags: [String],
        brand: String?,
        sku: String,
        weight: Int,
        dimensions: ProductDimensions,
        warrantyInformation: String,
        shippingInformation: String,
        availabilityStatus: String,
        reviews: [ProductReview],
        returnPolicy: String,
        minimumOrderQuantity: Int,
        meta: ProductMetadata,
        images: [String],
        thumbnail: String
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.price = price
        self.discountPercentage = discountPercentage
        self.rating = rating
        self.stock = stock
        self.tags = tags
        self.brand = brand
        self.sku = sku
        self.weight = weight
        self.dimensions = dimensions
        self.warrantyInformation = warrantyInformation
        self.shippingInformation = shippingInformation
        self.availabilityStatus = availabilityStatus
        self.reviews = reviews
        self.returnPolicy = returnPolicy
        self.minimumOrderQuantity = minimumOrderQuantity
        self.meta = meta
        self.images = images
        self.thumbnail = thumbnail
    }
}
