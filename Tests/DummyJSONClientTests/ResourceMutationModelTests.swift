import Foundation
import Testing
@testable import DummyJSONClient

@Suite("Resource mutation models")
struct ResourceMutationModelTests {
    @Test("Post mutations decode the pinned partial response shape")
    func postMutation() throws {
        let data = Data(#"{"id":252,"title":"Title","body":"Body","userId":1}"#.utf8)
        let response = try JSONDecoder().decode(PostMutationResponse.self, from: data)
        #expect(response.id == 252)
        #expect(response.title == "Title")
        #expect(response.tags == nil)
    }

    @Test("New comments decode without likes")
    func commentMutation() throws {
        let data = Data(#"{"id":341,"body":"Body","postId":1,"user":{"id":1,"username":"emilys","fullName":"Emily Johnson"}}"#.utf8)
        let response = try JSONDecoder().decode(CommentMutationResponse.self, from: data)
        #expect(response.id == 341)
        #expect(response.likes == nil)
    }

    @Test("Recipe mutations decode supplied fields only")
    func recipeMutation() throws {
        let data = Data(#"{"id":51,"name":"Soup","ingredients":["Water"]}"#.utf8)
        let response = try JSONDecoder().decode(RecipeMutationResponse.self, from: data)
        #expect(response.id == 51)
        #expect(response.name == "Soup")
        #expect(response.instructions == nil)
    }

    @Test("JSONValue round trips arbitrary custom response content")
    func jsonValue() throws {
        let value = JSONValue.object([
            "enabled": .bool(true),
            "items": .array([.number(1), .null, .string("two")]),
        ])
        let data = try JSONEncoder().encode(value)
        #expect(try JSONDecoder().decode(JSONValue.self, from: data) == value)
    }
}
