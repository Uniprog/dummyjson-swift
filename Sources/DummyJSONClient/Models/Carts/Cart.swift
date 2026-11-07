public struct CartProduct: Codable, Equatable, Sendable {
    public let id: Int
    public let title: String
    public let price: Double
    public let quantity: Int
    public let total: Double
    public let discountPercentage: Double
    public let discountedTotal: Double
    public let thumbnail: String
}

public struct Cart: Codable, Equatable, Sendable {
    public let id: Int
    public let products: [CartProduct]
    public let total: Double
    public let discountedTotal: Double
    public let userId: Int
    public let totalProducts: Int
    public let totalQuantity: Int
}

public typealias CartListResponse = ResourcePage<Cart>

public struct CartProductRequest: Codable, Equatable, Sendable {
    public let id: Int
    public let quantity: Int

    public init(id: Int, quantity: Int) {
        self.id = id
        self.quantity = quantity
    }
}

public struct CreateCartRequest: Encodable, Equatable, Sendable {
    public let userId: Int
    public let products: [CartProductRequest]

    public init(userId: Int, products: [CartProductRequest]) {
        self.userId = userId
        self.products = products
    }
}

public struct UpdateCartRequest: Encodable, Equatable, Sendable {
    public let merge: Bool?
    public let products: [CartProductRequest]

    public init(products: [CartProductRequest], merge: Bool? = nil) {
        self.products = products
        self.merge = merge
    }
}

public typealias ReplaceCartRequest = UpdateCartRequest

public struct DeleteCartResponse: Decodable, Sendable {
    public let cart: Cart
    public let isDeleted: Bool
    public let deletedOn: String

    public init(from decoder: any Decoder) throws {
        cart = try Cart(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isDeleted = try container.decode(Bool.self, forKey: .isDeleted)
        deletedOn = try container.decode(String.self, forKey: .deletedOn)
    }

    private enum CodingKeys: CodingKey { case isDeleted, deletedOn }
}
