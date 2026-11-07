# DummyJSONClient

A typed, asynchronous Swift client for the [DummyJSON](https://dummyjson.com) API.

`DummyJSONClient` covers products, users, carts, posts, comments, todos, quotes,
recipes, authentication, webhooks, custom responses, TOTP, placeholder images,
icons, and HTTP testing utilities. It uses Swift concurrency throughout and keeps
the HTTP transport injectable for deterministic testing.

> [!IMPORTANT]
> `DummyJSONClient` is an early-stage, AI-assisted package developed with OpenAI
> Codex. AI-generated changes have been reviewed and tested by the project
> maintainer, but the package has not yet been validated in production. Its
> public API may change before version 1.0.0.

## Requirements

- Swift 6.3+
- macOS 12+
- iOS and tvOS 15+
- watchOS 8+
- visionOS 1+

## Installation

Add the package in Xcode using:

```text
https://github.com/Uniprog/dummyjson-swift.git
```

Or add it to `Package.swift`:

```swift
dependencies: [
    .package(
        url: "https://github.com/Uniprog/dummyjson-swift.git",
        from: "0.1.0"
    )
]
```

Then add `DummyJSONClient` to the dependencies of your target:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "DummyJSONClient", package: "dummyjson-swift")
    ]
)
```

## Quick start

```swift
import DummyJSONClient

let api = DummyJSONAPI()

let page = try await api.products(
    query: ProductQuery(limit: 10, skip: 0)
)
let product = try await api.product(id: 1)
let matches = try await api.searchProducts("phone")
```

All operations are `async throws`. HTTP, transport, encoding, decoding, request,
configuration, and authentication failures are represented by `DummyJSONError`.

## Resources

The client provides typed list, detail, relationship, and simulated mutation
operations for:

- Products
- Users
- Carts
- Posts
- Comments
- Todos
- Quotes
- Recipes

For example:

```swift
let users = try await api.users(
    query: ResourceQuery(limit: 20, sortBy: "firstName", order: .ascending)
)

let posts = try await api.posts(userId: 1)
let comments = try await api.commentsForPost(id: 1)
let recipes = try await api.recipes(mealType: "Dinner")
let randomQuote = try await api.randomQuote()
```

`ResourceQuery` supports pagination, sorting, artificial delay, and field
selection:

```swift
let summaries = try await api.posts(
    query: ResourceQuery(
        limit: 10,
        skip: 20,
        sortBy: "title",
        order: .ascending,
        select: ["id", "title"]
    )
)
```

DummyJSON mutation endpoints simulate changes and do not persist them on the
server.

## Authentication

Login stores the returned access and refresh tokens:

```swift
let api = DummyJSONAPI()

try await api.login(
    LoginRequest(
        username: "your-username",
        password: "your-password"
    )
)

let user = try await api.authenticatedUser()
try await api.logout()
```

Authenticated requests:

- attach the access token as a Bearer token;
- refresh after a `401 Unauthorized` response;
- retry the original request once;
- deduplicate concurrent refresh operations;
- clear rejected sessions;
- preserve Swift task cancellation.

The default token store is in-memory. Applications can supply secure persistent
storage by implementing `TokenStore`:

```swift
let api = DummyJSONAPI(tokenStore: MyKeychainTokenStore())
```

## Utilities

```swift
let health = try await api.healthCheck()
let client = try await api.clientInfo()
let code = try await api.totp(key: "BASE32SECRET")

let pngData = try await api.placeholderImage(size: "300x200")
let iconData = try await api.icon(hash: "example", size: 128)

let webhook = try await api.createWebhook()
let captured = try await api.captureWebhook(
    identifier: webhook.identifier,
    body: .object(["event": .string("example")])
)
```

`JSONValue` represents arbitrary JSON used by custom responses and webhooks.
Binary image and icon operations return `Data`.

## Configuration and custom transport

```swift
let configuration = DummyJSONConfiguration(
    baseURL: "https://dummyjson.com",
    timeout: 30
)

let api = DummyJSONAPI(
    configuration: configuration,
    transport: URLSessionTransport()
)
```

Implement `HTTPTransport` to intercept requests, provide fixtures, or integrate
a custom networking stack:

```swift
struct FixtureTransport: HTTPTransport {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        // Return a controlled response.
    }
}
```

## Verification

The models and route behavior are verified against pinned DummyJSON commit
[`3d78fed5f35b7f1087db1c162edc412f2a736722`](https://github.com/Ovi/DummyJSON/commit/3d78fed5f35b7f1087db1c162edc412f2a736722).
Local fixtures decode every product, user, cart, post, comment, todo, quote, and
recipe in that revision.

Run the test suite with:

```sh
swift test
```

For the complete endpoint inventory and behavioral details, see
[`SPECIFICATION.md`](SPECIFICATION.md). A Russian translation is available in
[`SPECIFICATION.ru.md`](SPECIFICATION.ru.md).

## Contributing

Issues and pull requests are welcome. Please keep changes scoped, add controlled
tests for new behavior, and avoid relying on mutable live API responses.
