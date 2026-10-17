import Foundation

/// The public entry point for the DummyJSON API client.
public struct DummyJSONAPI: Sendable {
    public let configuration: DummyJSONConfiguration
    private let transport: any HTTPTransport

    public init(
        configuration: DummyJSONConfiguration = .init(),
        transport: any HTTPTransport = URLSessionTransport()
    ) {
        self.configuration = configuration
        self.transport = transport
    }

    func execute<Response: Decodable & Sendable>(
        _ endpoint: Endpoint,
        as responseType: Response.Type = Response.self
    ) async throws -> Response {
        try Task.checkCancellation()
        let request = try endpoint.request(configuration: configuration)
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await transport.data(for: request)
        } catch {
            if error is CancellationError || (error as? URLError)?.code == .cancelled || Task.isCancelled {
                throw CancellationError()
            }
            throw DummyJSONError.transport(underlying: error)
        }
        try Task.checkCancellation()
        guard let response = response as? HTTPURLResponse else {
            throw DummyJSONError.invalidResponse
        }
        guard (200..<300).contains(response.statusCode) else {
            let message = try? JSONDecoder().decode(ServerError.self, from: data).message
            throw DummyJSONError.http(statusCode: response.statusCode, message: message, body: data)
        }
        do {
            return try JSONDecoder().decode(responseType, from: data)
        } catch {
            throw DummyJSONError.decoding(underlying: error)
        }
    }
}

private struct ServerError: Decodable {
    let message: String
}
