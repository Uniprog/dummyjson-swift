public struct ResourcePage<Item: Decodable & Sendable>: Decodable, Sendable {
    public let items: [Item]
    public let total: Int
    public let skip: Int
    public let limit: Int

    public init(items: [Item], total: Int, skip: Int, limit: Int) {
        self.items = items
        self.total = total
        self.skip = skip
        self.limit = limit
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKey.self)
        guard let key = container.allKeys.first(where: { !["total", "skip", "limit"].contains($0.stringValue) }) else {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Missing resource collection."))
        }
        items = try container.decode([Item].self, forKey: key)
        total = try container.decode(Int.self, forKey: .init("total"))
        skip = try container.decode(Int.self, forKey: .init("skip"))
        limit = try container.decode(Int.self, forKey: .init("limit"))
    }
}

private struct DynamicCodingKey: CodingKey {
    let stringValue: String
    let intValue: Int? = nil
    init(_ stringValue: String) { self.stringValue = stringValue }
    init?(stringValue: String) { self.init(stringValue) }
    init?(intValue: Int) { nil }
}
