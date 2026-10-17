import Foundation

/// The public entry point for the DummyJSON API client.
public struct DummyJSONAPI: Sendable {
    public let configuration: DummyJSONConfiguration
    private let transport: any HTTPTransport
    let authentication: AuthenticationCoordinator

    public init(
        configuration: DummyJSONConfiguration = .init(),
        transport: any HTTPTransport = URLSessionTransport(),
        tokenStore: any TokenStore = InMemoryTokenStore()
    ) {
        self.configuration = configuration
        self.transport = transport
        self.authentication = AuthenticationCoordinator(store: tokenStore)
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

    func executeAuthenticated<Response: Decodable & Sendable>(
        _ endpoint: Endpoint,
        as responseType: Response.Type = Response.self
    ) async throws -> Response {
        guard let token = await authentication.accessToken() else {
            throw DummyJSONError.authenticationRequired
        }
        var request = endpoint
        request.bearerToken = token
        do {
            return try await execute(request, as: responseType)
        } catch DummyJSONError.http(let statusCode, _, _) where statusCode == 401 {
            let tokens = try await authentication.refresh { refreshToken in
                try await performRefresh(refreshToken: refreshToken)
            }
            request.bearerToken = tokens.accessToken
            return try await execute(request, as: responseType)
        }
    }

    private func performRefresh(refreshToken: String) async throws -> AuthenticationTokens {
        let response: RefreshTokenResponse = try await execute(Endpoint(
            method: .post,
            path: ["auth", "refresh"],
            body: Endpoint.encode(RefreshTokenRequest(refreshToken: refreshToken))
        ))
        return AuthenticationTokens(accessToken: response.accessToken, refreshToken: response.refreshToken)
    }
}

private struct ServerError: Decodable {
    let message: String
}
