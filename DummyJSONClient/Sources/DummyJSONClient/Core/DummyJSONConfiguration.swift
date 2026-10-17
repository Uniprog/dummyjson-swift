import Foundation

public struct DummyJSONConfiguration: Sendable, Equatable {
    public let baseURL: String
    public let timeout: TimeInterval

    public init(baseURL: String = "https://dummyjson.com", timeout: TimeInterval = 60) {
        self.baseURL = baseURL
        self.timeout = timeout
    }
}
