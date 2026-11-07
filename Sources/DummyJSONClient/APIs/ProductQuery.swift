import Foundation

public enum SortOrder: String, Sendable, Equatable {
    case ascending = "asc"
    case descending = "desc"
}

public struct ProductQuery: Sendable, Equatable {
    public var limit: Int?
    public var skip: Int?
    public var sortBy: String?
    public var order: SortOrder?
    public var delay: Int?
    public var modifiedAfter: Date?
    public var modifiedBefore: Date?

    public init(
        limit: Int? = nil,
        skip: Int? = nil,
        sortBy: String? = nil,
        order: SortOrder? = nil,
        delay: Int? = nil,
        modifiedAfter: Date? = nil,
        modifiedBefore: Date? = nil
    ) {
        self.limit = limit
        self.skip = skip
        self.sortBy = sortBy
        self.order = order
        self.delay = delay
        self.modifiedAfter = modifiedAfter
        self.modifiedBefore = modifiedBefore
    }

    func queryItems() throws -> [URLQueryItem] {
        guard limit.map({ $0 >= 0 }) ?? true, skip.map({ $0 >= 0 }) ?? true else {
            throw DummyJSONError.invalidRequest("Limit and skip must be nonnegative; limit 0 requests all products.")
        }
        guard delay.map({ (0...5000).contains($0) }) ?? true else {
            throw DummyJSONError.invalidRequest("Delay must be between 0 and 5000 milliseconds.")
        }
        guard [modifiedAfter, modifiedBefore].allSatisfy({ $0?.timeIntervalSince1970.isFinite ?? true }) else {
            throw DummyJSONError.invalidRequest("Modified date bounds must be finite.")
        }
        if let modifiedAfter, let modifiedBefore, modifiedAfter > modifiedBefore {
            throw DummyJSONError.invalidRequest("Modified-after must not be later than modified-before.")
        }
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let values: [(String, String?)] = [
            ("limit", limit.map(String.init)),
            ("skip", skip.map(String.init)),
            ("sortBy", sortBy),
            ("order", order?.rawValue),
            ("delay", delay.map(String.init)),
            ("modifiedAfter", modifiedAfter.map(formatter.string(from:))),
            ("modifiedBefore", modifiedBefore.map(formatter.string(from:))),
        ]
        return values.compactMap { name, value in
            value.map { URLQueryItem(name: name, value: $0) }
        }
    }
}
