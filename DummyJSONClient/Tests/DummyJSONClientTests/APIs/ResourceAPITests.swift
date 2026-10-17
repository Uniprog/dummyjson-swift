import Foundation
import Testing
@testable import DummyJSONClient

@Suite("Resource APIs")
struct ResourceAPITests {
    enum Resource: String, CaseIterable, Sendable {
        case users, carts, posts, comments, todos, quotes, recipes
    }

    @Test("Lists every primary resource with shared pagination", arguments: Resource.allCases)
    func lists(resource: Resource) async throws {
        let body = Data("{\"\(resource.rawValue)\":[],\"total\":0,\"skip\":2,\"limit\":5}".utf8)
        let transport = ControlledTransport(body: body)
        let api = DummyJSONAPI(transport: transport)
        let query = ResourceQuery(
            limit: 5,
            skip: 2,
            sortBy: "id",
            order: .descending,
            delay: 10,
            select: ["id"]
        )

        let metadata: (Int, Int, Int)
        switch resource {
        case .users:
            let response = try await api.users(query: query)
            metadata = (response.total, response.skip, response.limit)
        case .carts:
            let response = try await api.carts(query: query)
            metadata = (response.total, response.skip, response.limit)
        case .posts:
            let response = try await api.posts(query: query)
            metadata = (response.total, response.skip, response.limit)
        case .comments:
            let response = try await api.comments(query: query)
            metadata = (response.total, response.skip, response.limit)
        case .todos:
            let response = try await api.todos(query: query)
            metadata = (response.total, response.skip, response.limit)
        case .quotes:
            let response = try await api.quotes(query: query)
            metadata = (response.total, response.skip, response.limit)
        case .recipes:
            let response = try await api.recipes(query: query)
            metadata = (response.total, response.skip, response.limit)
        }

        #expect(metadata == (0, 2, 5))
        let request = try #require(await transport.recordedRequests().first)
        #expect(request.url?.path.hasSuffix("/\(resource.rawValue)") == true)
        let queryItems = URLComponents(url: try #require(request.url), resolvingAgainstBaseURL: false)?.queryItems
        #expect(queryItems?.contains(URLQueryItem(name: "limit", value: "5")) == true)
        #expect(queryItems?.contains(URLQueryItem(name: "skip", value: "2")) == true)
        #expect(queryItems?.contains(URLQueryItem(name: "sortBy", value: "id")) == true)
        #expect(queryItems?.contains(URLQueryItem(name: "order", value: "desc")) == true)
        #expect(queryItems?.contains(URLQueryItem(name: "delay", value: "10")) == true)
        #expect(queryItems?.contains(URLQueryItem(name: "select", value: "id")) == true)
    }

    @Test("Rejects invalid shared resource pagination locally")
    func invalidQuery() async throws {
        let transport = ControlledTransport(body: Data())
        let api = DummyJSONAPI(transport: transport)

        await #expect(throws: DummyJSONError.self) {
            try await api.quotes(query: ResourceQuery(limit: -1))
        }
        #expect(await transport.recordedRequests().isEmpty)
    }

    @Test("Rejects unsupported random collection lengths locally")
    func invalidRandomLengths() async throws {
        let transport = ControlledTransport(body: Data())
        let api = DummyJSONAPI(transport: transport)

        await #expect(throws: DummyJSONError.self) {
            try await api.randomQuotes(count: 11)
        }
        await #expect(throws: DummyJSONError.self) {
            try await api.randomTodos(count: 0)
        }
        #expect(await transport.recordedRequests().isEmpty)
    }

    @Test("Constructs related user and post routes")
    func relatedRoutes() async throws {
        let transport = ControlledTransport(body: Data(#"{"comments":[],"total":0,"skip":0,"limit":0}"#.utf8))
        let api = DummyJSONAPI(transport: transport)

        _ = try await api.commentsForPost(id: 7)

        let request = try #require(await transport.recordedRequests().first)
        #expect(request.url?.path.hasSuffix("/posts/7/comments") == true)
    }
}
