public struct UserAddress: Decodable, Equatable, Sendable {
    public let address: String
    public let city: String
    public let state: String
    public let stateCode: String
    public let postalCode: String
    public let coordinates: UserCoordinates
    public let country: String

    public init(
        address: String,
        city: String,
        state: String,
        stateCode: String,
        postalCode: String,
        coordinates: UserCoordinates,
        country: String
    ) {
        self.address = address
        self.city = city
        self.state = state
        self.stateCode = stateCode
        self.postalCode = postalCode
        self.coordinates = coordinates
        self.country = country
    }
}
