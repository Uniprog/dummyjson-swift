# Спецификация DummyJSONClient

[English version](SPECIFICATION.md)

- **Upstream-репозиторий:** [Ovi/DummyJSON](https://github.com/Ovi/DummyJSON)
- **Зафиксированный коммит:** [`3d78fed5f35b7f1087db1c162edc412f2a736722`](https://github.com/Ovi/DummyJSON/commit/3d78fed5f35b7f1087db1c162edc412f2a736722)
- **Руководство по API:** [документация DummyJSON](https://dummyjson.com/docs)

## Поддерживаемые API-запросы

Приведённый ниже список основан на маршрутах зафиксированного upstream-коммита.
Маршруты ресурсов поддерживают префиксы как в единственном, так и во множественном
числе, например `/product` и `/products`. Ниже в качестве канонического используется
вариант во множественном числе.

### Продукты

- `GET /products` — получить список продуктов.
- `GET /products/search` — найти продукты.
- `GET /products/category-list` — получить список названий категорий.
- `GET /products/categories` — получить список объектов категорий.
- `GET /products/{id}` — получить продукт.
- `GET /products/category/{categoryName}` — получить продукты категории.
- `POST /products/add` — имитировать добавление продукта.
- `PUT /products/{id}` — имитировать замену продукта.
- `PATCH /products/{id}` — имитировать обновление продукта.
- `DELETE /products/{id}` — имитировать удаление продукта.

#### Проверенные модели

- `Product`
- `ProductDimensions`
- `ProductReview`
- `ProductMetadata`
- `ProductCategory`
- `ProductListResponse`
- `ProductMutationRequest`
- `ProductMutationResponse`
- `DeleteProductResponse`

### Корзины

- `GET /carts` — получить список корзин.
- `GET /carts/user/{userId}` — получить корзины пользователя.
- `GET /carts/{id}` — получить корзину.
- `POST /carts/add` — имитировать добавление корзины.
- `PUT /carts/{id}` — имитировать замену корзины.
- `PATCH /carts/{id}` — имитировать обновление корзины.
- `DELETE /carts/{id}` — имитировать удаление корзины.

#### Предполагаемые модели

- `Cart`
- `CartProduct`
- `CartListResponse`
- `CreateCartRequest`
- `CreateCartProduct`
- `ReplaceCartRequest`
- `UpdateCartRequest`
- `DeleteCartResponse`

### Пользователи

- `GET /users` — получить список пользователей.
- `GET /users/search` — найти пользователей.
- `GET /users/filter` — отфильтровать пользователей по полю и значению.
- `GET /users/{id}` — получить пользователя.
- `GET /users/{userId}/carts` — получить корзины пользователя.
- `GET /users/{userId}/posts` — получить публикации пользователя.
- `GET /users/{userId}/todos` — получить задачи пользователя.
- `POST /users/add` — имитировать добавление пользователя.
- `PUT /users/{id}` — имитировать замену пользователя.
- `PATCH /users/{id}` — имитировать обновление пользователя.
- `DELETE /users/{id}` — имитировать удаление пользователя.
- `POST /users/login` — выполнить вход; псевдоним `POST /auth/login`.
- `GET /users/me` — получить аутентифицированного пользователя; псевдоним `GET /auth/me`.

#### Проверенные модели

- `User`
- `UserAddress`
- `UserCoordinates`
- `UserHair`
- `UserBank`
- `UserCompany`
- `UserCrypto`

#### Предполагаемые модели

- `UserListResponse`
- `CreateUserRequest`
- `ReplaceUserRequest`
- `UpdateUserRequest`
- `DeleteUserResponse`

### Публикации

- `GET /posts` — получить список публикаций.
- `GET /posts/search` — найти публикации.
- `GET /posts/tag-list` — получить список названий тегов.
- `GET /posts/tags` — получить список объектов тегов.
- `GET /posts/{id}` — получить публикацию.
- `GET /posts/tag/{tag}` — получить публикации с тегом.
- `GET /posts/user/{userId}` — получить публикации пользователя.
- `GET /posts/{postId}/comments` — получить комментарии публикации.
- `POST /posts/add` — имитировать добавление публикации.
- `PUT /posts/{id}` — имитировать замену публикации.
- `PATCH /posts/{id}` — имитировать обновление публикации.
- `DELETE /posts/{id}` — имитировать удаление публикации.

#### Проверенные модели

- `Post`
- `PostReactions`
- `PostTag`
- `PostListResponse`
- `CreatePostRequest`
- `ReplacePostRequest`
- `UpdatePostRequest`
- `DeletePostResponse`

### Комментарии

- `GET /comments` — получить список комментариев.
- `GET /comments/{id}` — получить комментарий.
- `GET /comments/post/{postId}` — получить комментарии публикации.
- `POST /comments/add` — имитировать добавление комментария.
- `PUT /comments/{id}` — имитировать замену комментария.
- `PATCH /comments/{id}` — имитировать обновление комментария.
- `DELETE /comments/{id}` — имитировать удаление комментария.

#### Предполагаемые модели

- `Comment`
- `CommentUser`
- `CommentListResponse`
- `CreateCommentRequest`
- `ReplaceCommentRequest`
- `UpdateCommentRequest`
- `DeleteCommentResponse`

### Задачи

- `GET /todos` — получить список задач.
- `GET /todos/random/{length?}` — получить одну или несколько случайных задач.
- `GET /todos/{id}` — получить задачу.
- `GET /todos/user/{userId}` — получить задачи пользователя.
- `POST /todos/add` — имитировать добавление задачи.
- `PUT /todos/{id}` — имитировать замену задачи.
- `PATCH /todos/{id}` — имитировать обновление задачи.
- `DELETE /todos/{id}` — имитировать удаление задачи.

#### Предполагаемые модели

- `Todo`
- `TodoListResponse`
- `CreateTodoRequest`
- `ReplaceTodoRequest`
- `UpdateTodoRequest`
- `DeleteTodoResponse`

### Цитаты

- `GET /quotes` — получить список цитат.
- `GET /quotes/random/{length?}` — получить одну или несколько случайных цитат.
- `GET /quotes/{id}` — получить цитату.

#### Предполагаемые модели

- `Quote`
- `QuoteListResponse`

### Рецепты

- `GET /recipes` — получить список рецептов.
- `GET /recipes/search` — найти рецепты.
- `GET /recipes/tags` — получить список тегов рецептов.
- `GET /recipes/{id}` — получить рецепт.
- `GET /recipes/tag/{tag}` — получить рецепты с тегом.
- `GET /recipes/meal-type/{mealType}` — получить рецепты по типу приёма пищи.
- `POST /recipes/add` — имитировать добавление рецепта.
- `PUT /recipes/{id}` — имитировать замену рецепта.
- `PATCH /recipes/{id}` — имитировать обновление рецепта.
- `DELETE /recipes/{id}` — имитировать удаление рецепта.

#### Предполагаемые модели

- `Recipe`
- `RecipeListResponse`
- `CreateRecipeRequest`
- `ReplaceRecipeRequest`
- `UpdateRecipeRequest`
- `DeleteRecipeResponse`

### Аутентификация

- `POST /auth/login` — аутентифицироваться по имени пользователя и паролю.
- `POST /auth/logout` — очистить аутентифицированную сессию.
- `GET /auth/me` — получить текущего аутентифицированного пользователя.
- `POST /auth/refresh` — обновить токены доступа и обновления.

#### Предполагаемые модели

- `LoginRequest`
- `LoginResponse`
- `RefreshTokenRequest`
- `RefreshTokenResponse`
- `LogoutResponse`
- `User` для ответа с аутентифицированным пользователем.

### Вспомогательные запросы

- `GET /ip` — получить IP-адрес клиента и информацию о user-agent.
- `GET /test` — проверить работоспособность; `/ping` и `/health` являются псевдонимами, поддерживаются все HTTP-методы.
- `ANY /http/{httpCode}/{message?}` — вернуть выбранный HTTP-статус; `/https` является псевдонимом.
- `GET /image/{size}/{background?}/{color?}/{type?}` — сгенерировать изображение-заполнитель; `/i` является псевдонимом.
- `GET /icon/{hash?}/{size?}` — сгенерировать иконку.
- `GET /2fa?key={key}` — сгенерировать TOTP-код; `/totp` является псевдонимом.
- `POST /2fa` — сгенерировать TOTP-код из тела запроса; `/totp` является псевдонимом.
- `POST /c/generate` — создать временный URL с пользовательским ответом.
- `CONFIGURED_METHOD /c/{identifier}` — вызвать пользовательский ответ методом, выбранным при его создании.
- `POST /webhook/create` — создать временный webhook.
- `ANY /webhook/{identifier}` — принять webhook-запрос.
- `GET /webhook/{identifier}/requests` — получить принятые webhook-запросы.
- `DELETE /webhook/{identifier}/requests/{requestId}` — удалить принятый webhook-запрос.

#### Предполагаемые модели

- `ClientInfo`
- `HealthCheckResponse`
- `HTTPStatusResponse`
- `TOTPRequest`
- `TOTPResponse`
- `CreateCustomResponseRequest`
- `CreateCustomResponseResponse`
- `JSONValue` для произвольного содержимого пользовательского ответа.
- `CreateWebhookResponse`
- `CaptureWebhookResponse`
- `CapturedWebhookRequest`
- `WebhookRequestsResponse`
- `DeleteWebhookRequestResponse`

Эндпоинты изображений и иконок возвращают бинарные данные, поэтому для них не нужны response model.

Запросы списков, поиска, фильтрации и связанных ресурсов могут поддерживать
общие query-параметры: `limit`, `skip`, `select`, `sortBy`, `order`, `q`, `delay`,
`modifiedAfter` и `modifiedBefore`. Точные параметры, а также типы запросов и
ответов будут определены при проектировании Swift API.

Имена моделей являются предварительными. Их поля и возможность совместного использования
типов разными группами эндпоинтов необходимо проверить по ответам зафиксированного upstream.

## Требования к Swift API-клиенту

### Реализовано: Core и Products

Публичный модуль — `DummyJSONClient`, клиент — `DummyJSONAPI`. Клиент соответствует
`Sendable` и использует async/await. Реализованы Core и все десять маршрутов Products.
Аутентификация, заменяемое хранилище токенов, координация refresh и остальные группы
ресурсов остаются следующими этапами. Запросы Products не добавляют Bearer-токен.

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

`ProductQuery` содержит необязательные `limit`, `skip`, `sortBy`, `order`, `delay`
(миллисекунды), `modifiedAfter` и `modifiedBefore` (`Date`, кодируется как ISO 8601).
Пропущенные параметры сохраняют серверные значения по умолчанию; `limit: 0`
запрашивает все подходящие товары. Некорректные параметры пагинации, задержка вне
0...5000 и обратный порядок границ дат отклоняются локально.

Выбор полей использует пользовательские проекции `Decodable & Sendable`, не ослабляя
обязательные поля полной модели `Product`:

```swift
struct ProductSummary: Decodable, Sendable {
    let id: Int
    let title: String
}

let selected = try await api.products(select: ["title"], as: ProductSummary.self)
let summary = try await api.product(id: 1, select: ["title"], as: ProductSummary.self)
```

Аналогичные перегрузки `select:as:` доступны для поиска и списка категории.
Выбранные списки возвращают `ProductPage<Item>`, полные — `ProductListResponse`.
Сервер всегда добавляет `id` при выборе полей. Проекция должна соответствовать
ответу; несовместимая проекция приводит к ошибке декодирования.

`DummyJSONConfiguration` принимает абсолютный HTTP(S) URL (включая префикс пути)
и положительный конечный тайм-аут в секундах. URL с учётными данными, query или
fragment отклоняются при выполнении. Транспорт по умолчанию использует временную
URLSession без cookies. Можно передать `URLSessionTransport(session:)` или
реализовать `Sendable`-протокол `HTTPTransport` для контролируемых ответов в тестах.
Отмена передаётся транспорту; ошибки отмены остаются `CancellationError`.
Автоматических повторов на этом этапе нет.

`DummyJSONError` различает ошибки конфигурации, построения запроса, кодирования,
транспорта, не-HTTP ответа, HTTP-статуса и декодирования. HTTP-ошибки сохраняют
статус, необязательный upstream `message` и исходное тело ответа; другие ошибки
выполнения сохраняют исходную ошибку. Кодировщики и декодировщики создаются на запрос.

Поведение проверено по `src/routes/product.js`, `src/controllers/product.js`,
`src/helpers/resource.js`, `src/middleware/clean-request.js` и
`src/middleware/error.js` в зафиксированном commit. POST возвращает 201 и только
поддерживаемые переданные поля. PUT и PATCH объединяют поддерживаемые поля с
исходным товаром (PUT не является полной заменой). Изменения имитируются и не
сохраняются. Удаление возвращает полный товар на верхнем уровне вместе с
`isDeleted` и `deletedOn`. Фильтры дат для списков, поиска и категорий используют
включительные границы `meta.updatedAt`. Тесты используют контролируемый транспорт
и зафиксированные fixtures, а не изменяемые ответы живого сервиса.

Минимальные платформы для URLSession async/await: macOS 12, iOS/tvOS 15, watchOS 8
и visionOS 1. Сохраняется языковой режим Swift 6.

Пакет должен предоставлять типизированный Swift-клиент с async/await-методами
для перечисленных выше запросов.

### Аутентификация и обновление токенов

Зафиксированная версия сервера DummyJSON поддерживает вход, получение текущего
аутентифицированного пользователя, обновление токенов и выход через перечисленные
выше маршруты `/auth`. Swift-клиент должен предоставлять эти операции и построенное
на их основе управление сессией.

- Сохранять access token и refresh token, возвращённые при входе.
- Добавлять access token как Bearer-токен только к запросам, требующим аутентификации.
- При получении `401 Unauthorized` от аутентифицированного запроса использовать
  refresh token для получения новой пары access token и refresh token.
- Сохранять оба возвращённых токена и один раз повторять исходный запрос.
- Координировать конкурентные ответы `401` через одну операцию refresh, чтобы клиент
  не отправлял несколько запросов обновления для одной сессии.
- Не обновлять токены для запросов login или refresh и не повторять
  аутентифицированный запрос более одного раза.
- Если refresh credentials отклонены, очищать локальную сессию и возвращать ошибку
  аутентификации.
- При выходе вызывать поддерживаемый logout endpoint и очищать локально сохранённые токены.

Хранилище токенов должно быть заменяемым, чтобы приложение могло выбрать хранение
в памяти или защищённое постоянное хранилище без изменения API-методов.

## Структура проекта

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

- `Core` содержит конфигурацию, построение endpoint, транспорт,
  выполнение запросов, декодирование ответов и обработку ошибок.
- `Authentication` содержит координацию сессии и хранение токенов.
- `Models` содержит типы запросов и ответов, сгруппированные по ресурсам.
- `APIs` содержит API-методы для отдельных ресурсов.
- `Fixtures` содержит контролируемые данные ответов, используемые тестами.
