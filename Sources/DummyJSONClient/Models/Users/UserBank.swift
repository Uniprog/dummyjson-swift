public struct UserBank: Decodable, Equatable, Sendable {
    public let cardExpire: String
    public let cardNumber: String
    public let cardType: String
    public let currency: String
    public let iban: String

    public init(
        cardExpire: String,
        cardNumber: String,
        cardType: String,
        currency: String,
        iban: String
    ) {
        self.cardExpire = cardExpire
        self.cardNumber = cardNumber
        self.cardType = cardType
        self.currency = currency
        self.iban = iban
    }
}
