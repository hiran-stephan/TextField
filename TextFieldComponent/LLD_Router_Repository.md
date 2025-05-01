# LLD – Router and Repository (Impl & Mock)

---

## 🔁 Router – `RecoverUserIdFlowRouter.kt`

| Property       | Description                                                                 |
|----------------|-----------------------------------------------------------------------------|
| **Interface**  | `RecoverUserIdFlowRouter`                                                   |
| **Functions**  | - `goBack()`<br>- `navigateToVerifyUserId(friendlyId: String)`<br>- `navigateBackToLogin(friendlyId: String?)` |
| **Purpose**    | Handles navigation between VerifyUserId and Login screens.                 |
| **Used In**    | `VerifyUserIdViewModelActions.kt`                                           |

---

## 🗂 Repository Implementation – `RecoverUserIdRepositoryImpl.kt`

| Property               | Description                                                                                      |
|------------------------|--------------------------------------------------------------------------------------------------|
| **Class**              | `RecoverUserIdRepositoryImpl`                                                                    |
| **Implements**         | `RecoverUserIdRepository`                                                                        |
| **Injected Services**  | `AuthenticationApiService`, `RemoteResourceApiService`                                          |
| **Functions**          | - `searchFriendlyId(...)`<br>- `retrieveFriendlyId(mfaTransactionId: String)`<br>- `loadResources()` |
| **Return Types**       | `Flow<NetworkResultState<...>>`                                                                  |
| **Responsibilities**   | - Executes backend API calls for user ID search and resource loading<br>- Wraps results in `Flow` |

---

## 🧪 Repository Mock – `RecoverUserIdRepositoryMock.kt`

| Property               | Description                                                                                          |
|------------------------|------------------------------------------------------------------------------------------------------|
| **Class**              | `RecoverUserIdRepositoryMock`                                                                         |
| **Implements**         | `RecoverUserIdRepository`                                                                             |
| **Injected Services**  | `RemoteResourceApiService`                                                                            |
| **Functions**          | - `searchFriendlyId(...)`<br>- `retrieveFriendlyId(...)`<br>- `loadResources()`                       |
| **Validation Logic**   | - Phone number: regex, blank, length check<br>- ID number: empty or length ≠ 9<br>- Account type: presence or invalid value<br>- Account number: per authentication type, checks blank or incorrect length |
| **Error Handling**     | Collects errors in `problems` list and throws `ProblemsException` if not empty                        |
| **Mock Return Value**  | - `retrieveFriendlyId`: returns hardcoded friendlyId `"LY user032"`<br>- `loadResources`: mocks a `ContentFile` download |
| **Used For**           | Local validation in testing or when no backend is connected                                           |