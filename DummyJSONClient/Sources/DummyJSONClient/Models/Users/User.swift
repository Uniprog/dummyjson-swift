public struct User: Decodable, Equatable, Sendable {
    public let id: Int
    public let firstName: String
    public let lastName: String
    public let maidenName: String
    public let age: Int
    public let gender: String
    public let email: String
    public let phone: String
    public let username: String
    public let password: String
    public let birthDate: String
    public let image: String
    public let bloodGroup: String
    public let height: Double
    public let weight: Double
    public let eyeColor: String
    public let hair: UserHair
    public let ip: String
    public let address: UserAddress
    public let macAddress: String
    public let university: String
    public let bank: UserBank
    public let company: UserCompany
    public let ein: String
    public let ssn: String
    public let userAgent: String
    public let crypto: UserCrypto
    public let role: String

    public init(
        id: Int,
        firstName: String,
        lastName: String,
        maidenName: String,
        age: Int,
        gender: String,
        email: String,
        phone: String,
        username: String,
        password: String,
        birthDate: String,
        image: String,
        bloodGroup: String,
        height: Double,
        weight: Double,
        eyeColor: String,
        hair: UserHair,
        ip: String,
        address: UserAddress,
        macAddress: String,
        university: String,
        bank: UserBank,
        company: UserCompany,
        ein: String,
        ssn: String,
        userAgent: String,
        crypto: UserCrypto,
        role: String
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.maidenName = maidenName
        self.age = age
        self.gender = gender
        self.email = email
        self.phone = phone
        self.username = username
        self.password = password
        self.birthDate = birthDate
        self.image = image
        self.bloodGroup = bloodGroup
        self.height = height
        self.weight = weight
        self.eyeColor = eyeColor
        self.hair = hair
        self.ip = ip
        self.address = address
        self.macAddress = macAddress
        self.university = university
        self.bank = bank
        self.company = company
        self.ein = ein
        self.ssn = ssn
        self.userAgent = userAgent
        self.crypto = crypto
        self.role = role
    }
}
