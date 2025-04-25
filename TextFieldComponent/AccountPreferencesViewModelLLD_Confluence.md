
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

... (truncated for this example)
