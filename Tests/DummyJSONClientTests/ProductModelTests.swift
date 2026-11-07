import Foundation
import Testing
@testable import DummyJSONClient

@Suite("Product models")
struct ProductModelTests {
    @Test("Decodes every product from the pinned upstream dataset")
    func decodesCompleteDataset() throws {
        let fixtureURL = try #require(Bundle.module.url(forResource: "products", withExtension: "json"))
        let data = try Data(contentsOf: fixtureURL)
        let products = try JSONDecoder().decode([Product].self, from: data)

        #expect(products.count == 194)

        let firstProduct = try #require(products.first)
        #expect(firstProduct.id == 1)
        #expect(firstProduct.title == "Essence Mascara Lash Princess")
        #expect(firstProduct.dimensions.width == 15.14)
        #expect(firstProduct.reviews.count == 3)
        #expect(firstProduct.meta.barcode == "5784719087687")

        let productWithoutBrand = try #require(products.first { $0.id == 16 })
        #expect(productWithoutBrand.title == "Apple")
        #expect(productWithoutBrand.brand == nil)
    }

    @Test("Decodes list, category, mutation, and deletion response shapes")
    func decodesEndpointResponses() throws {
        let fixtureURL = try #require(Bundle.module.url(forResource: "products", withExtension: "json"))
        let productData = try Data(contentsOf: fixtureURL)
        let productObjects = try #require(JSONSerialization.jsonObject(with: productData) as? [[String: Any]])
        let firstProductObject = try #require(productObjects.first)

        let listData = try JSONSerialization.data(withJSONObject: [
            "products": [firstProductObject],
            "total": 194,
            "skip": 0,
            "limit": 1,
        ])
        let list = try JSONDecoder().decode(ProductListResponse.self, from: listData)
        #expect(list.products.count == 1)
        #expect(list.total == 194)
        #expect(list.skip == 0)
        #expect(list.limit == 1)

        let categoryData = Data(
            #"{"slug":"beauty","name":"Beauty","url":"https://dummyjson.com/products/category/beauty"}"#.utf8
        )
        let category = try JSONDecoder().decode(ProductCategory.self, from: categoryData)
        #expect(category.slug == "beauty")

        let mutationData = Data(#"{"id":195,"title":"New product","price":9.99}"#.utf8)
        let mutation = try JSONDecoder().decode(ProductMutationResponse.self, from: mutationData)
        #expect(mutation.id == 195)
        #expect(mutation.title == "New product")
        #expect(mutation.price == 9.99)
        #expect(mutation.category == nil)

        var deletedProductObject = firstProductObject
        deletedProductObject["isDeleted"] = true
        deletedProductObject["deletedOn"] = "2026-10-16T00:00:00.000Z"
        let deletionData = try JSONSerialization.data(withJSONObject: deletedProductObject)
        let deletion = try JSONDecoder().decode(DeleteProductResponse.self, from: deletionData)
        #expect(deletion.product.id == 1)
        #expect(deletion.isDeleted)
        #expect(deletion.deletedOn == "2026-10-16T00:00:00.000Z")
    }

    @Test("Encodes only supplied product mutation fields")
    func encodesMutationRequest() throws {
        let request = ProductMutationRequest(title: "New product", price: 9.99)
        let data = try JSONEncoder().encode(request)
        let object = try #require(JSONSerialization.jsonObject(with: data) as? [String: Any])

        #expect(object.count == 2)
        #expect(object["title"] as? String == "New product")
        #expect(object["price"] as? Double == 9.99)
    }
}
