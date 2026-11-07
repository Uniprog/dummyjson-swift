public struct DeleteProductResponse: Decodable, Equatable, Sendable {
    public let product: Product
    public let isDeleted: Bool
    public let deletedOn: String

    public init(product: Product, isDeleted: Bool, deletedOn: String) {
        self.product = product
        self.isDeleted = isDeleted
        self.deletedOn = deletedOn
    }

    public init(from decoder: any Decoder) throws {
        product = try Product(from: decoder)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        isDeleted = try container.decode(Bool.self, forKey: .isDeleted)
        deletedOn = try container.decode(String.self, forKey: .deletedOn)
    }

    private enum CodingKeys: String, CodingKey {
        case isDeleted
        case deletedOn
    }
}
