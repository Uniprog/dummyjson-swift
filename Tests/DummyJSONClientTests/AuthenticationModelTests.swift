import Foundation
import Testing
@testable import DummyJSONClient

@Suite("Authentication models")
struct AuthenticationModelTests {
    @Test("Encodes login and refresh request bodies")
    func encodesRequests() throws {
        let login = LoginRequest(
            username: "emilys",
            password: "emilyspass",
            expiresInMins: 30
        )
        let loginData = try JSONEncoder().encode(login)
        let loginObject = try #require(JSONSerialization.jsonObject(with: loginData) as? [String: Any])
        #expect(loginObject["username"] as? String == "emilys")
        #expect(loginObject["password"] as? String == "emilyspass")
        #expect(loginObject["expiresInMins"] as? Int == 30)

        let refresh = RefreshTokenRequest(refreshToken: "refresh-token")
        let refreshData = try JSONEncoder().encode(refresh)
        let refreshObject = try #require(JSONSerialization.jsonObject(with: refreshData) as? [String: Any])
        #expect(refreshObject.count == 1)
        #expect(refreshObject["refreshToken"] as? String == "refresh-token")
    }

    @Test("Decodes login, refresh, and logout responses")
    func decodesAuthenticationResponses() throws {
        let loginData = Data(
            #"{"id":1,"username":"emilys","email":"emily.johnson@x.dummyjson.com","firstName":"Emily","lastName":"Johnson","gender":"female","image":"https://dummyjson.com/icon/emilys/128","accessToken":"access-token","refreshToken":"refresh-token"}"#.utf8
        )
        let login = try JSONDecoder().decode(LoginResponse.self, from: loginData)
        #expect(login.id == 1)
        #expect(login.username == "emilys")
        #expect(login.accessToken == "access-token")
        #expect(login.refreshToken == "refresh-token")

        let refreshData = Data(
            #"{"accessToken":"new-access-token","refreshToken":"new-refresh-token"}"#.utf8
        )
        let refresh = try JSONDecoder().decode(RefreshTokenResponse.self, from: refreshData)
        #expect(refresh.accessToken == "new-access-token")
        #expect(refresh.refreshToken == "new-refresh-token")

        let logoutData = Data(#"{"message":"Logged out successfully"}"#.utf8)
        let logout = try JSONDecoder().decode(LogoutResponse.self, from: logoutData)
        #expect(logout.message == "Logged out successfully")
    }

    @Test("Decodes every authenticated-user response from the pinned upstream dataset")
    func decodesCompleteUserDataset() throws {
        let fixtureURL = try #require(Bundle.module.url(forResource: "users", withExtension: "json"))
        let data = try Data(contentsOf: fixtureURL)
        let users = try JSONDecoder().decode([User].self, from: data)

        #expect(users.count == 208)

        let firstUser = try #require(users.first)
        #expect(firstUser.id == 1)
        #expect(firstUser.username == "emilys")
        #expect(firstUser.address.coordinates.lat == -77.16213)
        #expect(firstUser.company.address.city == "San Francisco")
        #expect(firstUser.bank.currency == "GBP")
        #expect(firstUser.crypto.coin == "Bitcoin")
        #expect(firstUser.role == "admin")
    }
}
