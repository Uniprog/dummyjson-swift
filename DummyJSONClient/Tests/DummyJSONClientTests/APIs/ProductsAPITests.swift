import Foundation
import Testing
import DummyJSONClient

@Suite("Products API")
struct ProductsAPITests {
    @Test("List, search, and category decode complete pinned products", arguments: ["list", "search", "category"])
    func listsProducts(operation: String) async throws {
        let transport = ControlledTransport(body: try ProductFixtures.page())
        let client = DummyJSONAPI(transport: transport)
        let result: ProductListResponse
        let expectedPath: String
        switch operation {
        case "search":
            result = try await client.searchProducts("mascara")
            expectedPath = "/products/search"
        case "category":
            result = try await client.products(inCategory: "beauty")
            expectedPath = "/products/category/beauty"
        default:
            result = try await client.products()
            expectedPath = "/products"
        }
        #expect(result.products.first?.title == "Essence Mascara Lash Princess")
        #expect(result.total == 194)
        #expect(result.skip == 0)
        #expect(result.limit == 1)
        let requests = await transport.recordedRequests()
        let request = try #require(requests.first)
        #expect(requests.count == 1)
        #expect(request.url?.path == expectedPath)
        #expect(request.httpMethod == "GET")
        #expect(request.httpBody == nil)
        if operation == "search" {
            #expect(queryItems(request)["q"] == "mascara")
        } else {
            #expect(request.url?.query == nil)
        }
    }

    @Test("Gets a complete product")
    func getsProduct() async throws {
        let transport = ControlledTransport(body: try ProductFixtures.product())
        let result = try await DummyJSONAPI(transport: transport).product(id: 1)
        #expect(result.id == 1)
        #expect(result.reviews.count == 3)
        let request = try #require(await transport.recordedRequests().first)
        #expect(request.httpMethod == "GET")
        #expect(request.url?.path == "/products/1")
    }

    @Test("Gets category names and objects")
    func getsCategories() async throws {
        let namesTransport = ControlledTransport(body: Data(#"["beauty","furniture"]"#.utf8))
        let names = try await DummyJSONAPI(transport: namesTransport).productCategoryNames()
        #expect(names == ["beauty", "furniture"])
        let namesRequest = try #require(await namesTransport.recordedRequests().first)
        #expect(namesRequest.url?.path == "/products/category-list")
        #expect(namesRequest.httpMethod == "GET")

        let categoriesTransport = ControlledTransport(body: Data(
            #"[{"slug":"beauty","name":"Beauty","url":"https://dummyjson.com/products/category/beauty"}]"#.utf8
        ))
        let categories = try await DummyJSONAPI(transport: categoriesTransport).productCategories()
        #expect(categories.first?.slug == "beauty")
        let categoriesRequest = try #require(await categoriesTransport.recordedRequests().first)
        #expect(categoriesRequest.url?.path == "/products/categories")
        #expect(categoriesRequest.httpMethod == "GET")
    }

    @Test("Mutation requests use the correct verb and only supplied fields", arguments: ["POST", "PUT", "PATCH"])
    func mutatesProducts(method: String) async throws {
        let transport = ControlledTransport(body: Data(#"{"id":195,"title":"New product","price":9.99}"#.utf8), statusCode: method == "POST" ? 201 : 200)
        let client = DummyJSONAPI(transport: transport)
        let mutation = ProductMutationRequest(title: "New product", price: 9.99)
        let result: ProductMutationResponse
        switch method {
        case "PUT": result = try await client.replaceProduct(id: 195, with: mutation)
        case "PATCH": result = try await client.updateProduct(id: 195, with: mutation)
        default: result = try await client.addProduct(mutation)
        }
        #expect(result.id == 195)
        #expect(result.title == "New product")
        #expect(result.price == 9.99)
        #expect(result.brand == nil)
        let request = try #require(await transport.recordedRequests().first)
        #expect(request.httpMethod == method)
        #expect(request.url?.path == (method == "POST" ? "/products/add" : "/products/195"))
        #expect(request.value(forHTTPHeaderField: "Content-Type") == "application/json")
        let data = try #require(request.httpBody)
        let object = try #require(JSONSerialization.jsonObject(with: data) as? [String: Any])
        #expect(object.count == 2)
        #expect(object["title"] as? String == "New product")
        #expect(object["price"] as? Double == 9.99)
    }

    @Test("Deletes a product and decodes the flattened deletion envelope")
    func deletesProduct() async throws {
        let transport = ControlledTransport(body: try ProductFixtures.deletedProduct())
        let result = try await DummyJSONAPI(transport: transport).deleteProduct(id: 1)
        #expect(result.product.id == 1)
        #expect(result.isDeleted)
        #expect(result.deletedOn == "2026-10-16T00:00:00.000Z")
        let request = try #require(await transport.recordedRequests().first)
        #expect(request.httpMethod == "DELETE")
        #expect(request.url?.path == "/products/1")
        #expect(request.httpBody == nil)
    }

    @Test("Encodes pagination, sorting, delay, date bounds, and search literally", arguments: ["list", "search", "category"])
    func encodesQuery(operation: String) async throws {
        let transport = ControlledTransport(body: try ProductFixtures.page())
        let client = DummyJSONAPI(transport: transport)
        let query = ProductQuery(
            limit: 0, skip: 2, sortBy: "meta.updatedAt", order: .descending, delay: 5000,
            modifiedAfter: Date(timeIntervalSince1970: 1_700_000_000.125),
            modifiedBefore: Date(timeIntervalSince1970: 1_800_000_000.5)
        )
        switch operation {
        case "search": _ = try await client.searchProducts("phone + café & x=?/#%", query: query)
        case "category": _ = try await client.products(inCategory: "beauty", query: query)
        default: _ = try await client.products(query: query)
        }
        let request = try #require(await transport.recordedRequests().first)
        let items = queryItems(request)
        #expect(items["limit"] == "0")
        #expect(items["skip"] == "2")
        #expect(items["sortBy"] == "meta.updatedAt")
        #expect(items["order"] == "desc")
        #expect(items["delay"] == "5000")
        #expect(items["modifiedAfter"] == "2023-11-14T22:13:20.125Z")
        #expect(items["modifiedBefore"] == "2027-01-15T08:00:00.500Z")
        if operation == "search" {
            #expect(items["q"] == "phone + café & x=?/#%")
            #expect(request.url?.absoluteString.contains("%2B") == true)
        }
    }

    @Test("Escapes category names as a single path segment and retains base paths")
    func escapesCategory() async throws {
        let transport = ControlledTransport(body: try ProductFixtures.page())
        let client = DummyJSONAPI(configuration: .init(baseURL: "https://example.com/api/v1/"), transport: transport)
        _ = try await client.products(inCategory: "beauty/ café?x=1#%")
        let request = try #require(await transport.recordedRequests().first)
        let url = try #require(request.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        #expect(components.percentEncodedPath == "/api/v1/products/category/beauty%2F%20caf%C3%A9%3Fx%3D1%23%25")
        #expect(components.query == nil)
        #expect(components.fragment == nil)
    }

    @Test("Selected fields decode into caller-owned projections", arguments: ["list", "search", "category", "single"])
    func selectsFields(operation: String) async throws {
        let single = #"{"id":1,"title":"Essence Mascara Lash Princess"}"#
        let page = "{\"products\":[\(single)],\"total\":1,\"skip\":0,\"limit\":1}"
        let transport = ControlledTransport(body: Data((operation == "single" ? single : page).utf8))
        let client = DummyJSONAPI(transport: transport)
        let selected: ProductSummary?
        switch operation {
        case "search":
            selected = try await client.searchProducts("mascara", select: ["title"], as: ProductSummary.self).products.first
        case "category":
            selected = try await client.products(inCategory: "beauty", select: ["title"], as: ProductSummary.self).products.first
        case "single":
            selected = try await client.product(id: 1, select: ["title"], as: ProductSummary.self)
        default:
            selected = try await client.products(select: ["title"], as: ProductSummary.self).products.first
        }
        #expect(selected?.id == 1)
        #expect(selected?.title == "Essence Mascara Lash Princess")
        let request = try #require(await transport.recordedRequests().first)
        #expect(queryItems(request)["select"] == "title")
        let expectedPath = switch operation {
        case "search": "/products/search"
        case "category": "/products/category/beauty"
        case "single": "/products/1"
        default: "/products"
        }
        #expect(request.url?.path == expectedPath)
    }

    private func queryItems(_ request: URLRequest) -> [String: String] {
        guard let url = request.url else { return [:] }
        return Dictionary(uniqueKeysWithValues: (URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems ?? []).map {
            ($0.name, $0.value ?? "")
        })
    }
}

private struct ProductSummary: Decodable, Sendable {
    let id: Int
    let title: String
}
