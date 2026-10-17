import Foundation

public enum DummyJSONError: Error {
    case invalidConfiguration(String)
    case invalidRequest(String)
    case encoding(underlying: any Error)
    case transport(underlying: any Error)
    case invalidResponse
    case http(statusCode: Int, message: String?, body: Data)
    case decoding(underlying: any Error)
    case authenticationRequired
}

extension DummyJSONError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidConfiguration(let message), .invalidRequest(let message):
            return message
        case .encoding(let underlying):
            return "Request encoding failed: \(underlying.localizedDescription)"
        case .transport(let underlying):
            return "Transport failed: \(underlying.localizedDescription)"
        case .invalidResponse:
            return "The transport returned a non-HTTP response."
        case .http(let statusCode, let message, _):
            return "HTTP \(statusCode): \(message ?? HTTPURLResponse.localizedString(forStatusCode: statusCode))"
        case .decoding(let underlying):
            return "Response decoding failed: \(underlying.localizedDescription)"
        case .authenticationRequired:
            return "Authentication is required."
        }
    }
}
