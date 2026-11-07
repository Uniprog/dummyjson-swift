public struct UserCompany: Decodable, Equatable, Sendable {
    public let department: String
    public let name: String
    public let title: String
    public let address: UserAddress

    public init(department: String, name: String, title: String, address: UserAddress) {
        self.department = department
        self.name = name
        self.title = title
        self.address = address
    }
}
