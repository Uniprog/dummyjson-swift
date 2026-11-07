import Foundation

extension DummyJSONAPI {
    public func clientInfo() async throws -> ClientInfo {
        try await execute(Endpoint(method: .get, path: ["ip"]))
    }

    public func healthCheck(method: UtilityHTTPMethod = .get) async throws -> HealthCheckResponse {
        try await execute(Endpoint(method: method.endpointMethod, path: ["test"]))
    }

    public func httpStatus(code: Int, message: String? = nil, method: UtilityHTTPMethod = .get) async throws -> HTTPStatusResponse {
        try await execute(Endpoint(
            method: method.endpointMethod,
            path: ["http", String(code)] + [message].compactMap { $0 }
        ))
    }

    public func totp(key: String) async throws -> TOTPResponse {
        try await execute(Endpoint(method: .get, path: ["2fa"], query: [URLQueryItem(name: "key", value: key)]))
    }

    public func totp(_ request: TOTPRequest) async throws -> TOTPResponse {
        try await execute(Endpoint(method: .post, path: ["2fa"], body: Endpoint.encode(request)))
    }

    public func createCustomResponse(_ request: CreateCustomResponseRequest) async throws -> CreateCustomResponseResponse {
        try await execute(Endpoint(method: .post, path: ["c", "generate"], body: Endpoint.encode(request)))
    }

    public func customResponse<Response: Decodable & Sendable>(
        identifier: String,
        method: UtilityHTTPMethod = .get,
        as responseType: Response.Type = Response.self
    ) async throws -> Response {
        try await execute(Endpoint(method: method.endpointMethod, path: ["c", identifier]), as: responseType)
    }

    public func createWebhook() async throws -> CreateWebhookResponse {
        try await execute(Endpoint(method: .post, path: ["webhook", "create"]))
    }

    public func captureWebhook(
        identifier: String,
        method: UtilityHTTPMethod = .post,
        body: JSONValue? = nil
    ) async throws -> CaptureWebhookResponse {
        try await execute(Endpoint(
            method: method.endpointMethod,
            path: ["webhook", identifier],
            body: try body.map(Endpoint.encode)
        ))
    }

    public func webhookRequests(identifier: String) async throws -> WebhookRequestsResponse {
        try await execute(Endpoint(method: .get, path: ["webhook", identifier, "requests"]))
    }

    public func deleteWebhookRequest(identifier: String, requestId: String) async throws -> DeleteWebhookRequestResponse {
        try await execute(Endpoint(method: .delete, path: ["webhook", identifier, "requests", requestId]))
    }

    public func placeholderImage(size: String, background: String? = nil, color: String? = nil, type: String? = nil) async throws -> Data {
        try await executeData(Endpoint(method: .get, path: ["image", size] + [background, color, type].compactMap { $0 }))
    }

    public func icon(hash: String? = nil, size: Int? = nil) async throws -> Data {
        try await executeData(Endpoint(method: .get, path: ["icon"] + [hash, size.map(String.init)].compactMap { $0 }))
    }
}
