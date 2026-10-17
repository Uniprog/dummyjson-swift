import Foundation
import Testing
@testable import DummyJSONClient

@Suite("Pinned resource fixtures")
struct ResourceFixtureTests {
    @Test("Decodes every cart from the pinned upstream dataset")
    func carts() throws {
        let values: [Cart] = try decodeFixture("carts")
        #expect(!values.isEmpty)
        #expect(values.allSatisfy { $0.totalProducts == $0.products.count })
    }

    @Test("Decodes every post from the pinned upstream dataset")
    func posts() throws {
        let values: [Post] = try decodeFixture("posts")
        #expect(!values.isEmpty)
        #expect(Set(values.map(\.id)).count == values.count)
    }

    @Test("Decodes every comment from the pinned upstream dataset")
    func comments() throws {
        let values: [DummyJSONClient.Comment] = try decodeFixture("comments")
        #expect(!values.isEmpty)
        #expect(values.allSatisfy { !$0.user.username.isEmpty })
    }

    @Test("Decodes every todo from the pinned upstream dataset")
    func todos() throws {
        let values: [Todo] = try decodeFixture("todos")
        #expect(!values.isEmpty)
        #expect(Set(values.map(\.id)).count == values.count)
    }

    @Test("Decodes every quote from the pinned upstream dataset")
    func quotes() throws {
        let values: [Quote] = try decodeFixture("quotes")
        #expect(!values.isEmpty)
        #expect(values.allSatisfy { !$0.quote.isEmpty && !$0.author.isEmpty })
    }

    @Test("Decodes every recipe from the pinned upstream dataset")
    func recipes() throws {
        let values: [Recipe] = try decodeFixture("recipes")
        #expect(!values.isEmpty)
        #expect(values.allSatisfy { !$0.ingredients.isEmpty && !$0.instructions.isEmpty })
    }

    private func decodeFixture<Value: Decodable>(_ name: String) throws -> Value {
        let url = try #require(Bundle.module.url(forResource: name, withExtension: "json"))
        return try JSONDecoder().decode(Value.self, from: Data(contentsOf: url))
    }
}
