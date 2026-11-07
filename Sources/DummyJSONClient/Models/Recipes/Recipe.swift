public struct Recipe: Codable, Equatable, Sendable {
    public let id: Int
    public let name: String
    public let ingredients: [String]
    public let instructions: [String]
    public let prepTimeMinutes: Int
    public let cookTimeMinutes: Int
    public let servings: Int
    public let difficulty: String
    public let cuisine: String
    public let caloriesPerServing: Int
    public let tags: [String]
    public let userId: Int
    public let image: String
    public let rating: Double
    public let reviewCount: Int
    public let mealType: [String]
}

public typealias RecipeListResponse = ResourcePage<Recipe>

public struct RecipeMutationRequest: Encodable, Equatable, Sendable {
    public let name: String?
    public let ingredients: [String]?
    public let instructions: [String]?
    public let prepTimeMinutes: Int?
    public let cookTimeMinutes: Int?
    public let servings: Int?
    public let difficulty: String?
    public let cuisine: String?
    public let caloriesPerServing: Int?
    public let tags: [String]?
    public let userId: Int?
    public let image: String?
    public let mealType: [String]?

    public init(name: String? = nil, ingredients: [String]? = nil, instructions: [String]? = nil, prepTimeMinutes: Int? = nil, cookTimeMinutes: Int? = nil, servings: Int? = nil, difficulty: String? = nil, cuisine: String? = nil, caloriesPerServing: Int? = nil, tags: [String]? = nil, userId: Int? = nil, image: String? = nil, mealType: [String]? = nil) {
        self.name = name
        self.ingredients = ingredients
        self.instructions = instructions
        self.prepTimeMinutes = prepTimeMinutes
        self.cookTimeMinutes = cookTimeMinutes
        self.servings = servings
        self.difficulty = difficulty
        self.cuisine = cuisine
        self.caloriesPerServing = caloriesPerServing
        self.tags = tags
        self.userId = userId
        self.image = image
        self.mealType = mealType
    }
}

public typealias CreateRecipeRequest = RecipeMutationRequest
public typealias ReplaceRecipeRequest = RecipeMutationRequest
public typealias UpdateRecipeRequest = RecipeMutationRequest

public struct RecipeMutationResponse: Decodable, Equatable, Sendable {
    public let id: Int
    public let name: String?
    public let ingredients: [String]?
    public let instructions: [String]?
    public let prepTimeMinutes: Int?
    public let cookTimeMinutes: Int?
    public let servings: Int?
    public let difficulty: String?
    public let cuisine: String?
    public let caloriesPerServing: Int?
    public let tags: [String]?
    public let userId: Int?
    public let image: String?
    public let mealType: [String]?
}

public struct DeleteRecipeResponse: Decodable, Sendable {
    public let recipe: Recipe
    public let isDeleted: Bool
    public let deletedOn: String

    public init(from decoder: any Decoder) throws {
        recipe = try Recipe(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isDeleted = try container.decode(Bool.self, forKey: .isDeleted)
        deletedOn = try container.decode(String.self, forKey: .deletedOn)
    }

    private enum CodingKeys: CodingKey { case isDeleted, deletedOn }
}
