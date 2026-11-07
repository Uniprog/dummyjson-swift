import DummyJSONClient
import Testing

private struct Product {}

@Test("Qualifies remote models when the application has a model with the same name")
func qualifiesRemoteProductModel() {
    let client = DummyJSONAPI()
    let remoteProductType: DummyJSONClient.Product.Type = DummyJSONClient.Product.self
    let localProductType: Product.Type = Product.self

    #expect(type(of: client) == DummyJSONAPI.self)
    #expect(remoteProductType == DummyJSONClient.Product.self)
    #expect(localProductType == Product.self)
}
