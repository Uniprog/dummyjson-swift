import Foundation

extension DummyJSONAPI {
    public func recipes(query: ResourceQuery = .init()) async throws -> RecipeListResponse { try await execute(Endpoint(method: .get, path: ["recipes"], query: query.queryItems())) }
    public func searchRecipes(_ search: String, query: ResourceQuery = .init()) async throws -> RecipeListResponse {
        try await execute(Endpoint(method: .get, path: ["recipes", "search"], query: query.queryItems() + [URLQueryItem(name: "q", value: search)]))
    }
    public func recipe(id: Int) async throws -> Recipe { try await execute(Endpoint(method: .get, path: ["recipes", String(id)])) }
    public func recipeTags() async throws -> [String] { try await execute(Endpoint(method: .get, path: ["recipes", "tags"])) }
    public func recipes(tag: String, query: ResourceQuery = .init()) async throws -> RecipeListResponse { try await execute(Endpoint(method: .get, path: ["recipes", "tag", tag], query: query.queryItems())) }
    public func recipes(mealType: String, query: ResourceQuery = .init()) async throws -> RecipeListResponse { try await execute(Endpoint(method: .get, path: ["recipes", "meal-type", mealType], query: query.queryItems())) }
    public func addRecipe(_ request: CreateRecipeRequest) async throws -> RecipeMutationResponse { try await execute(Endpoint(method: .post, path: ["recipes", "add"], body: Endpoint.encode(request))) }
    public func replaceRecipe(id: Int, with request: ReplaceRecipeRequest) async throws -> RecipeMutationResponse { try await execute(Endpoint(method: .put, path: ["recipes", String(id)], body: Endpoint.encode(request))) }
    public func updateRecipe(id: Int, with request: UpdateRecipeRequest) async throws -> RecipeMutationResponse { try await execute(Endpoint(method: .patch, path: ["recipes", String(id)], body: Endpoint.encode(request))) }
    public func deleteRecipe(id: Int) async throws -> DeleteRecipeResponse { try await execute(Endpoint(method: .delete, path: ["recipes", String(id)])) }
}
