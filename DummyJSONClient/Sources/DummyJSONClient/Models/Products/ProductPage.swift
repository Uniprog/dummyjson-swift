/// A list response for caller-defined product projections requested with `select`.
public struct ProductPage<Item: Decodable & Sendable>: Decodable, Sendable {
    public let products: [Item]
    public let total: Int
    public let skip: Int
    public let limit: Int
}

extension ProductPage: Equatable where Item: Equatable {}
