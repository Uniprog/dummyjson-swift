import Foundation

extension DummyJSONAPI {
    public func products(query: ProductQuery = .init()) async throws -> ProductListResponse {
        try await execute(Endpoint(method: .get, path: ["products"], query: query.queryItems()))
    }

    public func searchProducts(_ search: String, query: ProductQuery = .init()) async throws -> ProductListResponse {
        try await execute(Endpoint(
            method: .get, path: ["products", "search"],
            query: query.queryItems() + [URLQueryItem(name: "q", value: search)]
        ))
    }

    public func product(id: Int) async throws -> Product {
        try await execute(Endpoint(method: .get, path: ["products", String(id)]))
    }

    public func productCategoryNames() async throws -> [String] {
        try await execute(Endpoint(method: .get, path: ["products", "category-list"]))
    }

    public func productCategories() async throws -> [ProductCategory] {
        try await execute(Endpoint(method: .get, path: ["products", "categories"]))
    }

    public func products(inCategory category: String, query: ProductQuery = .init()) async throws -> ProductListResponse {
        try await execute(Endpoint(method: .get, path: ["products", "category", category], query: query.queryItems()))
    }

    public func addProduct(_ request: ProductMutationRequest) async throws -> ProductMutationResponse {
        try await execute(Endpoint(method: .post, path: ["products", "add"], body: Endpoint.encode(request)))
    }

    /// The pinned server merges supplied fields for both PUT and PATCH; neither persists changes.
    public func replaceProduct(id: Int, with request: ProductMutationRequest) async throws -> ProductMutationResponse {
        try await execute(Endpoint(method: .put, path: ["products", String(id)], body: Endpoint.encode(request)))
    }

    public func updateProduct(id: Int, with request: ProductMutationRequest) async throws -> ProductMutationResponse {
        try await execute(Endpoint(method: .patch, path: ["products", String(id)], body: Endpoint.encode(request)))
    }

    public func deleteProduct(id: Int) async throws -> DeleteProductResponse {
        try await execute(Endpoint(method: .delete, path: ["products", String(id)]))
    }

    public func products<Item: Decodable & Sendable>(
        select fields: [String], as itemType: Item.Type, query: ProductQuery = .init()
    ) async throws -> ProductPage<Item> {
        try await execute(Endpoint(method: .get, path: ["products"], query: query.queryItems() + selection(fields)))
    }

    public func searchProducts<Item: Decodable & Sendable>(
        _ search: String, select fields: [String], as itemType: Item.Type, query: ProductQuery = .init()
    ) async throws -> ProductPage<Item> {
        try await execute(Endpoint(
            method: .get, path: ["products", "search"],
            query: query.queryItems() + [URLQueryItem(name: "q", value: search)] + selection(fields)
        ))
    }

    public func product<Item: Decodable & Sendable>(id: Int, select fields: [String], as itemType: Item.Type) async throws -> Item {
        try await execute(Endpoint(method: .get, path: ["products", String(id)], query: selection(fields)))
    }

    public func products<Item: Decodable & Sendable>(
        inCategory category: String, select fields: [String], as itemType: Item.Type, query: ProductQuery = .init()
    ) async throws -> ProductPage<Item> {
        try await execute(Endpoint(
            method: .get, path: ["products", "category", category], query: query.queryItems() + selection(fields)
        ))
    }

    private func selection(_ fields: [String]) -> [URLQueryItem] {
        [URLQueryItem(name: "select", value: fields.joined(separator: ","))]
    }
}
