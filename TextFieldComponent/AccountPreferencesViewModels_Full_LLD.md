
## `AccountPreferencesViewModel`

---

- **Responsibilities**:
  - Loads grouped accounts and resources.
  - Maintains list screen state.
  - Handles navigation and analytics.
- **Dependencies**:
  - `AccountPreferencesFlowRouter`
  - `ApplicationRouter`
  - `AccountPreferencesRepository`
  - `MessageCatalogue`, `AccountCatalogue`, `Locale`
  - `AccountPreferencesAnalyticsHelper`

---

### State

#### `AccountPreferencesUIState`

```kotlin
data class AccountPreferencesUIState(
    val isLoading: Boolean = false,
    val error: Throwable? = null,
    val accountPreferencesAccountsData: AccountPreferencesAccountsData? = null
)
```

#### `AccountPreferencesResourceUIState`

```kotlin
data class AccountPreferencesResourceUIState(
    val isLoading: Boolean = false,
    val error: Throwable? = null,
    val contentFile: ContentFile? = null
)
```

---

### ViewModel Actions

- `attachViewModel()`: Triggers screen analytics and loads accounts.
- `fetchAccountGroups()`: Loads grouped account list; sets UI error if empty or contains problems.
- `fetchResources()`: Loads `ContentFile` and sets `resourceState`.
- `onAccountCardClicked(account)`: Navigates to details screen.
- `onEmptyStateAction()`: Signs out if unexpected error, else retries resource load.
- `onNavigateBack()`: Triggers navigation back.

---

### Presenters

#### `AccountPreferencesScreenPresenter`

| Property      | Description                    |
| ------------- | ------------------------------ |
| `screenTitle` | Title text for the list screen |

#### `AccountPreferencesAccountGroupPresenter`

| Property | Description                           |
| -------- | ------------------------------------- |
| `label`  | Section label like “Deposit Accounts” |

#### `AccountPreferencesAccountPresenter`

| Property                           | Description                             |
| ---------------------------------- | --------------------------------------- |
| `accountName`                      | Display name (nickname or product name) |
| `accountNumber`                    | Masked account number                   |
| `itemFirstRowLabel`                | Primary label (e.g., account name)      |
| `itemSecondRowLabel`               | Secondary label (e.g., account number)  |
| `isHidden`                         | Account visibility status               |
| `hasNickname`                      | Whether nickname exists                 |
| `visibilityLabel`                  | Label for visibility pill               |
| `visibilityLabelAccessibilityText` | Accessibility text for visibility pill  |
| `shouldShowMiniCard`               | Shows debit card icon if `hasDebitCard` |

#### `ProblemsPresenter` / `ProblemsFullPagePresenter`

| Property                  | Description                    |
| ------------------------- | ------------------------------ |
| `title`, `message`        | Shown in banner or full-screen |
| `retryText`, `actionText` | Retry/confirm CTA labels       |

---

## `AccountPreferencesDetailsViewModel`

---

- **Responsibilities**:
  - Loads specific account by ID.
  - Updates nickname and visibility.
  - Manages detailed UI state and error display.
- **Dependencies**: same as `AccountPreferencesViewModel`.

---

### State

#### `AccountPreferencesDetailsUiState`

```kotlin
data class AccountPreferencesDetailsUiState(
    val accountPreferencesAccountDetails: AccountPreferencesAccount? = null,
    val nickname: String? = null,
    val isEditingNickname: Boolean = false,
    val visibilityStatus: Boolean = true,
    val accountPreferencesUpdateComplete: Boolean = false,
    val showAccountDisplayAlert: Boolean = false,
    val showAccountDisplayInfoIconAlert: Boolean = false,
    val showAccountNicknameInfoIconAlert: Boolean = false,
    val isLoading: Boolean = false,
    val errorAccountPreferenceUpdate: Throwable? = null,
    val error: Throwable? = null
) {
    val hasData: Boolean = accountPreferencesAccountDetails != null
    val hasError: Boolean = error != null
    val hasUnexpectedError: Boolean = hasError && error?.message == "0001"
    val hasAccountPreferenceUpdateError: Boolean = errorAccountPreferenceUpdate != null
}
```

#### `AccountPreferencesDetailsResourceUiState`

```kotlin
data class AccountPreferencesDetailsResourceUiState(
    val contentFile: ContentFile? = null,
    val isLoading: Boolean = false,
    val error: Throwable? = null
) {
    val hasError: Boolean = error != null
    val hasUnexpectedError: Boolean = hasError && error?.message == "0001"
}
```

#### `AccountPreferencesDetailsActionState`

```kotlin
data class AccountPreferencesDetailsActionState(
    val isLoading: Boolean = false,
    val error: Throwable? = null
) {
    val hasError: Boolean = error != null
}
```

#### `DialogState`

```kotlin
data class DialogState(
    val titleText: String? = null,
    val bodyText: String? = null,
    val dismissButtonText: String? = null,
    val confirmButtonText: String? = null
)
```

---

### ViewModel Actions

- `fetchAccountDetails(accountId)`
- `updateAccountNickname(accountId, nickname)`
- `updateAccountVisibility(accountId, visibility)`
- `onNavigateBack()`

---

### Presenters

#### `AccountPreferencesAccountPresenter` (same as list view)

| Property                                                                       | Description |
| ------------------------------------------------------------------------------ | ----------- |
| Same as list presenter with real-time updates to nickname or visibility flags. |             |

#### `AccountPreferencesDetailsCardPresenter`

| Property                                     | Description                               |
| -------------------------------------------- | ----------------------------------------- |
| `accountControlHeaderTitle`                  | “Control your account” section title      |
| `accountControlInfoIconAccessibilityText`    | Accessibility label for control info icon |
| `accountControlInfoIconDialogBodyText`       | Info body shown in dialog                 |
| `accountControlDisplayHideThisAccountText`   | CTA text to hide account                  |
| `accountNicknameHeaderTitle`                 | Section title for nickname                |
| `accountNicknameAddNicknameButtonText`       | CTA for adding a nickname                 |
| `infoIconDialogCloseButtonText`              | Close button text in dialog               |
| `infoIconDialogCloseButtonTextAccessibility` | Accessibility variant                     |

#### `AccountPreferencesDetailsAccountNicknameFormPresenter`

| Property                                           | Description                 |
| -------------------------------------------------- | --------------------------- |
| `accountNicknameFieldLabelText`                    | Label for nickname field    |
| `accountNicknameInlineMessageText`                 | Helper text below field     |
| `accountNicknameSaveButtonText`                    | CTA to save nickname        |
| `accountNicknameCancelButtonText`                  | CTA to cancel nickname edit |
| `accountNicknameFieldCloseButtonAccessibilityText` | Icon accessibility label    |

#### `AccountPreferencesAccountHideDialogPresenter` / `ShowDialogPresenter`

| Property                                  | Description                        |
| ----------------------------------------- | ---------------------------------- |
| `accountDisplayDialogTitleText`           | Dialog title for hiding or showing |
| `accountDisplayDialogBodyText`            | Dialog body                        |
| `accountControlDisplayBackButtonText`     | Cancel button text                 |
| `accountControlDisplayContinueButtonText` | Confirm button text                |

---

## Common Dependencies

---

### Router – `AccountPreferencesFlowRouter`

- `goBack()`
- `navigateToAccountPreferenceDetails(account)`
- `signout()`

---

### Repository – `AccountPreferencesRepository`

- `loadAccounts()`
- `loadResources()`
- `fetchAccountById(accountId)`
- `updateAccountNickname(accountId, nickname)`
- `updateAccountVisibility(accountId, visibility)`

---

### Analytics – `AccountPreferencesAnalyticsHelper`

- `trackAccountPreferenceListState()`
- `trackAccountPreferenceDetailsState()`
- `trackAccountEditNicknameStartAction()`
- `trackAccountEditNicknameSaveAction()`
- `trackAccountVisibility(...)`
- Uses: `AccountPreferencesAnalyticsProperties` to build Adobe events

---

### Domain Models

| Model                              | Key Fields                                                                     |
| ---------------------------------- | ------------------------------------------------------------------------------ |
| `AccountPreferencesAccount`        | `id`, `group`, `nickname`, `maskedAccountNumber`, `visibility`, `hasDebitCard` |
| `AccountPreferencesAccountsData`   | `accountGroups`, `problems`                                                    |
| `AccountPreferencesAccountGroup`   | `label`, `accounts`                                                            |
| `AccountPreferencesAccountData`    | `account`, `problems`                                                          |
| `ContentResources` / `ContentFile` | Localized content used across presenters                                       |
