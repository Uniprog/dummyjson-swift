# DummyJSONClient Specification

[Русская версия](SPECIFICATION.ru.md)

- **Upstream repository:** [Ovi/DummyJSON](https://github.com/Ovi/DummyJSON)
- **Pinned commit:** [`3d78fed5f35b7f1087db1c162edc412f2a736722`](https://github.com/Ovi/DummyJSON/commit/3d78fed5f35b7f1087db1c162edc412f2a736722)
- **API guide:** [DummyJSON documentation](https://dummyjson.com/docs)

## Supported API Requests

The list below is based on the routes present in the pinned upstream commit.
Resource routes support both singular and plural prefixes, for example
`/product` and `/products`. The plural form is used below as the canonical path.

### Products

- `GET /products` — list products.
- `GET /products/search` — search products.
- `GET /products/category-list` — list category names.
- `GET /products/categories` — list category objects.
- `GET /products/{id}` — get a product.
- `GET /products/category/{categoryName}` — list products in a category.
- `POST /products/add` — simulate adding a product.
- `PUT /products/{id}` — simulate replacing a product.
- `PATCH /products/{id}` — simulate updating a product.
- `DELETE /products/{id}` — simulate deleting a product.

#### Verified Models

- `Product`
- `ProductDimensions`
- `ProductReview`
- `ProductMetadata`
- `ProductCategory`
- `ProductListResponse`
- `ProductMutationRequest`
- `ProductMutationResponse`
- `DeleteProductResponse`

### Carts

- `GET /carts` — list carts.
- `GET /carts/user/{userId}` — list carts for a user.
- `GET /carts/{id}` — get a cart.
- `POST /carts/add` — simulate adding a cart.
- `PUT /carts/{id}` — simulate replacing a cart.
- `PATCH /carts/{id}` — simulate updating a cart.
- `DELETE /carts/{id}` — simulate deleting a cart.

#### Planned Models

- `Cart`
- `CartProduct`
- `CartListResponse`
- `CreateCartRequest`
- `CreateCartProduct`
- `ReplaceCartRequest`
- `UpdateCartRequest`
- `DeleteCartResponse`

### Users

- `GET /users` — list users.
- `GET /users/search` — search users.
- `GET /users/filter` — filter users by a field and value.
- `GET /users/{id}` — get a user.
- `GET /users/{userId}/carts` — list a user's carts.
- `GET /users/{userId}/posts` — list a user's posts.
- `GET /users/{userId}/todos` — list a user's todos.
- `POST /users/add` — simulate adding a user.
- `PUT /users/{id}` — simulate replacing a user.
- `PATCH /users/{id}` — simulate updating a user.
- `DELETE /users/{id}` — simulate deleting a user.
- `POST /users/login` — log in; alias of `POST /auth/login`.
- `GET /users/me` — get the authenticated user; alias of `GET /auth/me`.

#### Verified Models

- `User`
- `UserAddress`
- `UserCoordinates`
- `UserHair`
- `UserBank`
- `UserCompany`
- `UserCrypto`

#### Planned Models

- `UserListResponse`
- `CreateUserRequest`
- `ReplaceUserRequest`
- `UpdateUserRequest`
- `DeleteUserResponse`

### Posts

- `GET /posts` — list posts.
- `GET /posts/search` — search posts.
- `GET /posts/tag-list` — list tag names.
- `GET /posts/tags` — list tag objects.
- `GET /posts/{id}` — get a post.
- `GET /posts/tag/{tag}` — list posts with a tag.
- `GET /posts/user/{userId}` — list posts for a user.
- `GET /posts/{postId}/comments` — list comments for a post.
- `POST /posts/add` — simulate adding a post.
- `PUT /posts/{id}` — simulate replacing a post.
- `PATCH /posts/{id}` — simulate updating a post.
- `DELETE /posts/{id}` — simulate deleting a post.

#### Verified Models

- `Post`
- `PostReactions`
- `PostTag`
- `PostListResponse`
- `CreatePostRequest`
- `ReplacePostRequest`
- `UpdatePostRequest`
- `DeletePostResponse`

### Comments

- `GET /comments` — list comments.
- `GET /comments/{id}` — get a comment.
- `GET /comments/post/{postId}` — list comments for a post.
- `POST /comments/add` — simulate adding a comment.
- `PUT /comments/{id}` — simulate replacing a comment.
- `PATCH /comments/{id}` — simulate updating a comment.
- `DELETE /comments/{id}` — simulate deleting a comment.

#### Planned Models

- `Comment`
- `CommentUser`
- `CommentListResponse`
- `CreateCommentRequest`
- `ReplaceCommentRequest`
- `UpdateCommentRequest`
- `DeleteCommentResponse`

### Todos

- `GET /todos` — list todos.
- `GET /todos/random/{length?}` — get one or more random todos.
- `GET /todos/{id}` — get a todo.
- `GET /todos/user/{userId}` — list todos for a user.
- `POST /todos/add` — simulate adding a todo.
- `PUT /todos/{id}` — simulate replacing a todo.
- `PATCH /todos/{id}` — simulate updating a todo.
- `DELETE /todos/{id}` — simulate deleting a todo.

#### Planned Models

- `Todo`
- `TodoListResponse`
- `CreateTodoRequest`
- `ReplaceTodoRequest`
- `UpdateTodoRequest`
- `DeleteTodoResponse`

### Quotes

- `GET /quotes` — list quotes.
- `GET /quotes/random/{length?}` — get one or more random quotes.
- `GET /quotes/{id}` — get a quote.

#### Planned Models

- `Quote`
- `QuoteListResponse`

### Recipes

- `GET /recipes` — list recipes.
- `GET /recipes/search` — search recipes.
- `GET /recipes/tags` — list recipe tags.
- `GET /recipes/{id}` — get a recipe.
- `GET /recipes/tag/{tag}` — list recipes with a tag.
- `GET /recipes/meal-type/{mealType}` — list recipes by meal type.
- `POST /recipes/add` — simulate adding a recipe.
- `PUT /recipes/{id}` — simulate replacing a recipe.
- `PATCH /recipes/{id}` — simulate updating a recipe.
- `DELETE /recipes/{id}` — simulate deleting a recipe.

#### Planned Models

- `Recipe`
- `RecipeListResponse`
- `CreateRecipeRequest`
- `ReplaceRecipeRequest`
- `UpdateRecipeRequest`
- `DeleteRecipeResponse`

### Authentication

- `POST /auth/login` — authenticate with a username and password.
- `POST /auth/logout` — clear the authenticated session.
- `GET /auth/me` — get the current authenticated user.
- `POST /auth/refresh` — refresh access and refresh tokens.

#### Planned Models

- `LoginRequest`
- `LoginResponse`
- `RefreshTokenRequest`
- `RefreshTokenResponse`
- `LogoutResponse`
- `User` for the authenticated-user response.

### Utilities

- `GET /ip` — return the client IP address and user-agent information.
- `GET /test` — health check; `/ping` and `/health` are aliases and all HTTP methods are accepted.
- `ANY /http/{httpCode}/{message?}` — return a chosen HTTP status; `/https` is an alias.
- `GET /image/{size}/{background?}/{color?}/{type?}` — generate a placeholder image; `/i` is an alias.
- `GET /icon/{hash?}/{size?}` — generate an icon.
- `GET /2fa?key={key}` — generate a TOTP code; `/totp` is an alias.
- `POST /2fa` — generate a TOTP code from a request body; `/totp` is an alias.
- `POST /c/generate` — create a temporary custom-response URL.
- `CONFIGURED_METHOD /c/{identifier}` — call a custom response using the method selected when it was created.
- `POST /webhook/create` — create a temporary webhook.
- `ANY /webhook/{identifier}` — capture a webhook request.
- `GET /webhook/{identifier}/requests` — list captured webhook requests.
- `DELETE /webhook/{identifier}/requests/{requestId}` — delete a captured webhook request.

#### Planned Models

- `ClientInfo`
- `HealthCheckResponse`
- `HTTPStatusResponse`
- `TOTPRequest`
- `TOTPResponse`
- `CreateCustomResponseRequest`
- `CreateCustomResponseResponse`
- `JSONValue` for arbitrary custom-response content.
- `CreateWebhookResponse`
- `CaptureWebhookResponse`
- `CapturedWebhookRequest`
- `WebhookRequestsResponse`
- `DeleteWebhookRequestResponse`

Image and icon endpoints return binary data and therefore do not require response Models.

List, search, filter, and related-resource requests may support common query
parameters such as `limit`, `skip`, `select`, `sortBy`, `order`, `q`, `delay`,
`modifiedAfter`, and `modifiedBefore`. Exact parameters and request and response
types will be specified when the Swift API is designed.

Model names are preliminary. Their fields and any opportunities to share types
between endpoint groups must be verified against the pinned upstream responses.

## Swift API Client Requirements

### Implemented Client Surface

The public module is `DummyJSONClient`; the client is `DummyJSONAPI`. The client
is `Sendable` and uses async/await. Typed APIs are implemented for Products, Carts,
Users, Posts, Comments, Todos, Quotes, Recipes, Authentication, and Utilities.
Authentication includes replaceable token storage, bearer headers, one retry after a
401 response, concurrent refresh deduplication, logout, and cancellation propagation.
Unauthenticated resource requests do not attach bearer tokens.

```swift
import DummyJSONClient

let api = DummyJSONAPI()
let page = try await api.products(query: ProductQuery(limit: 10, skip: 0))
let matches = try await api.searchProducts("phone")
let product = try await api.product(id: 1)
let names = try await api.productCategoryNames()
let categories = try await api.productCategories()
let beauty = try await api.products(inCategory: "beauty")
let added = try await api.addProduct(ProductMutationRequest(title: "New product"))
let replaced = try await api.replaceProduct(id: 1, with: ProductMutationRequest(price: 10))
let updated = try await api.updateProduct(id: 1, with: ProductMutationRequest(stock: 5))
let deleted = try await api.deleteProduct(id: 1)
```

`ProductQuery` supports optional `limit`, `skip`, `sortBy`, `order`, `delay`
(milliseconds), `modifiedAfter`, and `modifiedBefore` (`Date`, encoded as ISO 8601).
Omitted parameters retain server defaults; `limit: 0` requests all matching products.
Invalid pagination, delay outside 0...5000, and reversed date bounds fail locally.

Field selection uses caller-defined `Decodable & Sendable` projections, rather
than weakening the required fields of the full `Product` model:

```swift
struct ProductSummary: Decodable, Sendable {
    let id: Int
    let title: String
}

let selected = try await api.products(select: ["title"], as: ProductSummary.self)
let summary = try await api.product(id: 1, select: ["title"], as: ProductSummary.self)
```

Equivalent `select:as:` overloads exist for search and category lists. Selected
lists return `ProductPage<Item>`; full lists retain `ProductListResponse`.
The server always includes `id` when selecting fields. The projection must match
the selected response; an incompatible projection produces a decoding error.

`DummyJSONConfiguration` accepts an absolute HTTP(S) base URL (including an optional
path prefix) and positive finite timeout in seconds. Base URLs with credentials,
query strings, or fragments are rejected at execution. The default transport uses
an ephemeral, cookie-free URLSession. Applications can inject `URLSessionTransport(session:)`
or implement the `Sendable` `HTTPTransport` protocol to control responses in tests.
Cancellation propagates to transport; cancellation errors remain `CancellationError`.
No automatic retry is performed by this increment.

`DummyJSONError` distinguishes configuration, request construction, encoding,
transport, non-HTTP response, HTTP status, and decoding failures. HTTP errors retain
the status, optional upstream `message`, and raw response body; other execution
errors retain their underlying error. Decoders and encoders are created per request.

Behavior is verified against `src/routes/product.js`, `src/controllers/product.js`,
`src/helpers/resource.js`, `src/middleware/clean-request.js`, and
`src/middleware/error.js` at the pinned commit above. In particular, POST returns
201 with only supported supplied fields; PUT and PATCH both merge supported fields
with the original product (PUT is not a true replacement). Mutations are simulated
and not persisted. Deletion returns the complete flattened product with `isDeleted`
and `deletedOn`. Date filters on list, search, and category routes use inclusive
`meta.updatedAt` bounds. Tests use controlled transport and pinned product fixtures,
not mutable responses from the live service.

Minimum platforms for URLSession async/await are macOS 12, iOS/tvOS 15, watchOS 8,
and visionOS 1. The package remains in Swift 6 language mode.

The package must provide a typed Swift client with async/await methods for the
requests listed above.

### Authentication and Token Refresh

The pinned DummyJSON server supports login, authenticated-user lookup, token
refresh, and logout through the `/auth` routes listed above. The Swift client
must expose these operations and provide session management built on top of them.

- Store the access token and refresh token returned by login.
- Add the access token as a Bearer token only to requests that require authentication.
- When an authenticated request receives `401 Unauthorized`, use the refresh token
  to request a new access-token and refresh-token pair.
- Save both returned tokens and retry the original request once.
- Coordinate concurrent `401` responses through a single refresh operation so that
  the client does not submit multiple refresh requests for the same session.
- Never refresh login or refresh requests, and never retry an authenticated request
  more than once.
- If refresh credentials are rejected, clear the local session and return an
  authentication error.
- Logout must call the supported logout endpoint and clear locally stored tokens.

Token storage must be replaceable so applications can choose in-memory or secure
persistent storage without changing the API methods.

## Project Structure

```text
DummyJSONClient/
├── Package.swift
├── SPECIFICATION.md
├── SPECIFICATION.ru.md
├── Sources/
│   └── DummyJSONClient/
│       ├── Core/
│       ├── Authentication/
│       ├── Models/
│       │   ├── Products/
│       │   ├── Carts/
│       │   ├── Users/
│       │   ├── Posts/
│       │   ├── Comments/
│       │   ├── Todos/
│       │   ├── Quotes/
│       │   ├── Recipes/
│       │   ├── Authentication/
│       │   └── Utilities/
│       └── APIs/
└── Tests/
    └── DummyJSONClientTests/
        ├── Core/
        ├── Authentication/
        ├── APIs/
        └── Fixtures/
```

- `Core` contains configuration, endpoint construction, transport,
  request execution, response decoding, and error handling.
- `Authentication` contains session coordination and token storage.
- `Models` contains request and response types grouped by resource.
- `APIs` contains resource-specific API methods.
- `Fixtures` contains controlled response data used by tests.
