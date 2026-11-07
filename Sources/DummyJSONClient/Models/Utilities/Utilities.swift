public enum JSONValue: Codable, Equatable, Sendable {
    case null
    case bool(Bool)
    case number(Double)
    case string(String)
    case array([JSONValue])
    case object([String: JSONValue])

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() { self = .null }
        else if let value = try? container.decode(Bool.self) { self = .bool(value) }
        else if let value = try? container.decode(Double.self) { self = .number(value) }
        else if let value = try? container.decode(String.self) { self = .string(value) }
        else if let value = try? container.decode([JSONValue].self) { self = .array(value) }
        else { self = .object(try container.decode([String: JSONValue].self)) }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .null: try container.encodeNil()
        case .bool(let value): try container.encode(value)
        case .number(let value): try container.encode(value)
        case .string(let value): try container.encode(value)
        case .array(let value): try container.encode(value)
        case .object(let value): try container.encode(value)
        }
    }
}

public struct ClientInfo: Decodable, Equatable, Sendable {
    public let ip: String
    public let userAgent: String?
}

public struct HealthCheckResponse: Decodable, Equatable, Sendable {
    public let status: String
    public let method: String
}

public enum UtilityHTTPMethod: String, Sendable, Equatable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case head = "HEAD"
    case options = "OPTIONS"

    var endpointMethod: Endpoint.Method {
        switch self {
        case .get: .get
        case .post: .post
        case .put: .put
        case .patch: .patch
        case .delete: .delete
        case .head: .head
        case .options: .options
        }
    }
}

public struct HTTPStatusResponse: Decodable, Equatable, Sendable {
    public let status: Int
    public let message: String?
    public let title: String?
    public let type: String?
    public let detail: String?
}

public struct TOTPRequest: Encodable, Equatable, Sendable {
    public let key: String
    public init(key: String) { self.key = key }
}

public struct TOTPResponse: Decodable, Equatable, Sendable {
    public let totp: String
    public let expiresIn: Int
    public let period: Int
}

public struct CreateCustomResponseRequest: Encodable, Equatable, Sendable {
    public let json: JSONValue
    public let method: String
    public init(json: JSONValue, method: String) {
        self.json = json
        self.method = method
    }
}

public struct CreateCustomResponseResponse: Decodable, Equatable, Sendable {
    public let url: String
}

public struct CreateWebhookResponse: Decodable, Equatable, Sendable {
    public let identifier: String
    public let url: String
    public let expiresAt: String
}

public struct CaptureWebhookResponse: Decodable, Equatable, Sendable {
    public let received: Bool
    public let requestId: String
}

public struct CapturedWebhookRequest: Decodable, Equatable, Sendable {
    public let requestId: String
    public let method: String
    public let headers: [String: String]
    public let query: [String: String]
    public let body: JSONValue
    public let receivedAt: String
}

public struct WebhookRequestsResponse: Decodable, Equatable, Sendable {
    public let identifier: String
    public let expiresAt: String
    public let requests: [CapturedWebhookRequest]
}

public struct DeleteWebhookRequestResponse: Decodable, Equatable, Sendable {
    public let deleted: Bool
}
