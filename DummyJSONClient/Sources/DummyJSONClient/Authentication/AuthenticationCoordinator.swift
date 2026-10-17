actor AuthenticationCoordinator {
    private let store: any TokenStore
    private var refreshTask: Task<AuthenticationTokens, Error>?

    init(store: any TokenStore) {
        self.store = store
    }

    func accessToken() async -> String? {
        await store.tokens()?.accessToken
    }

    func save(_ tokens: AuthenticationTokens) async {
        await store.save(tokens)
    }

    func clear() async {
        refreshTask?.cancel()
        refreshTask = nil
        await store.clear()
    }

    func refresh(
        using operation: @escaping @Sendable (String) async throws -> AuthenticationTokens
    ) async throws -> AuthenticationTokens {
        if let refreshTask {
            return try await refreshTask.value
        }
        guard let refreshToken = await store.tokens()?.refreshToken else {
            throw DummyJSONError.authenticationRequired
        }
        let task = Task { try await operation(refreshToken) }
        refreshTask = task
        do {
            let tokens = try await task.value
            refreshTask = nil
            await store.save(tokens)
            return tokens
        } catch {
            refreshTask = nil
            if !(error is CancellationError) {
                await store.clear()
            }
            throw error
        }
    }
}
