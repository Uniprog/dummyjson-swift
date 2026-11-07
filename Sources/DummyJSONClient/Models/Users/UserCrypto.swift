public struct UserCrypto: Decodable, Equatable, Sendable {
    public let coin: String
    public let wallet: String
    public let network: String

    public init(coin: String, wallet: String, network: String) {
        self.coin = coin
        self.wallet = wallet
        self.network = network
    }
}
