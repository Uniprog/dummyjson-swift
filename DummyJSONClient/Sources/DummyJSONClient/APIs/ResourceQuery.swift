import Foundation

public struct ResourceQuery: Sendable, Equatable {
    public var limit: Int?
    public var skip: Int?
    public var sortBy: String?
    public var order: SortOrder?
    public var delay: Int?
    public var select: [String]?

    public init(
        limit: Int? = nil,
        skip: Int? = nil,
        sortBy: String? = nil,
        order: SortOrder? = nil,
        delay: Int? = nil,
        select: [String]? = nil
    ) {
        self.limit = limit
        self.skip = skip
        self.sortBy = sortBy
        self.order = order
        self.delay = delay
        self.select = select
    }

    func queryItems() throws -> [URLQueryItem] {
        guard limit.map({ $0 >= 0 }) ?? true, skip.map({ $0 >= 0 }) ?? true else {
            throw DummyJSONError.invalidRequest("Limit and skip must be nonnegative.")
        }
        guard delay.map({ (0...5000).contains($0) }) ?? true else {
            throw DummyJSONError.invalidRequest("Delay must be between 0 and 5000 milliseconds.")
        }
        return [
            limit.map { URLQueryItem(name: "limit", value: String($0)) },
            skip.map { URLQueryItem(name: "skip", value: String($0)) },
            sortBy.map { URLQueryItem(name: "sortBy", value: $0) },
            order.map { URLQueryItem(name: "order", value: $0.rawValue) },
            delay.map { URLQueryItem(name: "delay", value: String($0)) },
            select.flatMap { $0.isEmpty ? nil : URLQueryItem(name: "select", value: $0.joined(separator: ",")) },
        ].compactMap { $0 }
    }
}
