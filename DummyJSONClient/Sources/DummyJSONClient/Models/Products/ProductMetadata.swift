public struct ProductMetadata: Decodable, Equatable, Sendable {
    public let createdAt: String
    public let updatedAt: String
    public let barcode: String
    public let qrCode: String

    public init(createdAt: String, updatedAt: String, barcode: String, qrCode: String) {
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.barcode = barcode
        self.qrCode = qrCode
    }
}
