extension DummyJSONAPI {
    @discardableResult
    public func login(_ request: LoginRequest) async throws -> LoginResponse {
        let response: LoginResponse = try await execute(Endpoint(
            method: .post,
            path: ["auth", "login"],
            body: Endpoint.encode(request)
        ))
        await authentication.save(AuthenticationTokens(
            accessToken: response.accessToken,
            refreshToken: response.refreshToken
        ))
        return response
    }

    @discardableResult
    public func refreshAuthentication(expiresInMins: Int? = nil) async throws -> RefreshTokenResponse {
        let tokens = try await authentication.refresh { refreshToken in
            let response: RefreshTokenResponse = try await execute(Endpoint(
                method: .post,
                path: ["auth", "refresh"],
                body: Endpoint.encode(RefreshTokenRequest(
                    refreshToken: refreshToken,
                    expiresInMins: expiresInMins
                ))
            ))
            return AuthenticationTokens(accessToken: response.accessToken, refreshToken: response.refreshToken)
        }
        return RefreshTokenResponse(accessToken: tokens.accessToken, refreshToken: tokens.refreshToken)
    }

    public func authenticatedUser() async throws -> User {
        try await executeAuthenticated(Endpoint(method: .get, path: ["auth", "me"]))
    }

    @discardableResult
    public func logout() async throws -> LogoutResponse {
        do {
            let response: LogoutResponse = try await executeAuthenticated(Endpoint(method: .post, path: ["auth", "logout"]))
            await authentication.clear()
            return response
        } catch {
            await authentication.clear()
            throw error
        }
    }
}
