import Foundation
import Testing
@testable import DummyJSONClient

actor ControlledTransport: HTTPTransport {
    private var requests: [URLRequest] = []
    private let handler: @Sendable (URLRequest) async throws -> (Data, URLResponse)

    init(handler: @escaping @Sendable (URLRequest) async throws -> (Data, URLResponse)) {
        self.handler = handler
    }

    init(body: Data, statusCode: Int = 200) {
        handler = { request in
            let url = try #require(request.url)
            let response = try #require(HTTPURLResponse(
                url: url, statusCode: statusCode, httpVersion: "HTTP/1.1",
                headerFields: ["Content-Type": "application/json"]
            ))
            return (body, response)
        }
    }

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        requests.append(request)
        return try await handler(request)
    }

    func recordedRequests() -> [URLRequest] {
        requests
    }
}

enum ProductFixtures {
    static func firstProductObject() throws -> [String: Any] {
        let url = try #require(Bundle.module.url(forResource: "products", withExtension: "json"))
        let objects = try #require(JSONSerialization.jsonObject(with: Data(contentsOf: url)) as? [[String: Any]])
        return try #require(objects.first)
    }

    static func product() throws -> Data {
        try JSONSerialization.data(withJSONObject: firstProductObject())
    }

    static func page() throws -> Data {
        try JSONSerialization.data(withJSONObject: [
            "products": [firstProductObject()], "total": 194, "skip": 0, "limit": 1,
        ])
    }

    static func deletedProduct() throws -> Data {
        var object = try firstProductObject()
        object["isDeleted"] = true
        object["deletedOn"] = "2026-10-16T00:00:00.000Z"
        return try JSONSerialization.data(withJSONObject: object)
    }
}
