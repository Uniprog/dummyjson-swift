import Foundation

struct Endpoint: Sendable {
    enum Method: String, Sendable {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
    }

    let method: Method
    let path: [String]
    var query: [URLQueryItem] = []
    var body: Data? = nil

    func request(configuration: DummyJSONConfiguration) throws -> URLRequest {
        guard var components = URLComponents(string: configuration.baseURL),
              let scheme = components.scheme?.lowercased(), ["http", "https"].contains(scheme),
              let host = components.host, !host.isEmpty,
              components.user == nil, components.password == nil,
              components.query == nil, components.fragment == nil else {
            throw DummyJSONError.invalidConfiguration("The base URL must be an absolute HTTP(S) URL without credentials, query, or fragment.")
        }
        guard configuration.timeout.isFinite, configuration.timeout > 0 else {
            throw DummyJSONError.invalidConfiguration("The timeout must be finite and greater than zero.")
        }
        let allowed = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "-._~"))
        let segments = try path.map { segment in
            guard !segment.isEmpty, segment != ".", segment != "..",
                  let encoded = segment.addingPercentEncoding(withAllowedCharacters: allowed) else {
                throw DummyJSONError.invalidRequest("Invalid endpoint path component.")
            }
            return encoded
        }
        components.percentEncodedPath = components.percentEncodedPath.replacingOccurrences(
            of: "/+$", with: "", options: .regularExpression
        ) + "/" + segments.joined(separator: "/")
        components.queryItems = query.isEmpty ? nil : query
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        guard let url = components.url else {
            throw DummyJSONError.invalidRequest("Unable to construct the request URL.")
        }
        var request = URLRequest(url: url, timeoutInterval: configuration.timeout)
        request.httpMethod = method.rawValue
        request.httpShouldHandleCookies = false
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = body
        if body != nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        return request
    }

    static func encode<Body: Encodable>(_ body: Body) throws -> Data {
        do {
            return try JSONEncoder().encode(body)
        } catch {
            throw DummyJSONError.encoding(underlying: error)
        }
    }
}
