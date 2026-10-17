extension DummyJSONAPI {
    public func quotes(query: ResourceQuery = .init()) async throws -> QuoteListResponse {
        try await execute(Endpoint(method: .get, path: ["quotes"], query: query.queryItems()))
    }

    public func quote(id: Int) async throws -> Quote {
        try await execute(Endpoint(method: .get, path: ["quotes", String(id)]))
    }

    public func randomQuote() async throws -> Quote {
        try await execute(Endpoint(method: .get, path: ["quotes", "random"]))
    }

    public func randomQuotes(count: Int) async throws -> [Quote] {
        guard count > 0 else { throw DummyJSONError.invalidRequest("Random quote count must be positive.") }
        return try await execute(Endpoint(method: .get, path: ["quotes", "random", String(count)]))
    }
}
