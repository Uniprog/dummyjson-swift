public struct ProductDimensions: Decodable, Equatable, Sendable {
    public let width: Double
    public let height: Double
    public let depth: Double

    public init(width: Double, height: Double, depth: Double) {
        self.width = width
        self.height = height
        self.depth = depth
    }
}
