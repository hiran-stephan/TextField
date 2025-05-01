# Shared Changes for Recover User ID – Android/iOS

This document summarizes **shared changes** for the *RecoverUserId* feature implementation across ViewModels, Presenters, and UI logic.

---

## 📦 Shared ViewModel: `RecoverUserIdViewModel`

### 🔧 Properties
| Property | Type | Purpose |
|----------|------|---------|
| `repository` | `RecoverUserIdRepository` | Handles core recover user ID logic |
| `remoteResourceRepository` | `RemoteResourceRepository` | Fetches remote content (e.g., labels, tooltips) |
| `messageCatalogue` | `MessageCatalogue` | Formats field error messages |
| `locale` | `Locale` | Provides locale for localized content |
| `applicationRouter` | `ApplicationRouter` | Handles app-level navigation |
| `flowRouter` | `RecoverUserIdFlowRouter` | Handles feature-specific navigation |
| `tmxProvider` | `TmxProvider` | Provides profiling/session ID |
| `analyticsHelper` | `RecoverUserIdAnalyticsHelper` | Tracks analytics for screen and flow events |
| `_recoverUserIdState` | `MutableStateFlow<RecoverUserIdUiState>` | Internal UI state management |
| `recoverUserIdState` | `StateFlow<RecoverUserIdUiState>` | Exposed immutable state flow |
| `contentFile` | `ContentFile?` | Localized content for UI rendering |

### 🧠 Methods
| Method | Purpose |
|--------|---------|
| `fetchRecoverUserIdPageContent()` | Fetches content from `RemoteResourceRepository` |
| `searchFriendlyId()` | Triggers search flow and calls `retrieveFriendlyId()` |
| `retrieveFriendlyId()` | Retrieves `friendlyId` after validation |
| `updateRecoverUserIdState()` | Updates entire UI state object |
| `updatePhoneNumber(phone: String)` | Updates user phone number |
| `updateSSNOrTIN(number: String)` | Updates SSN or TIN |
| `updateSIN(number: String)` | Updates SIN |
| `updateAccountType(accountType: String?)` | Updates selected account type |
| `updateAccountNumber(accountNumber: String)` | Updates account number |
| `updateOTVCTransactionId(id: String)` | Sets verified MFA transaction ID |
| `show*/hide*TooltipDialog()` | Shows/hides tooltip dialogs per section |
| `onTapContinueButton()` | Calls `searchFriendlyId()` |
| `onTapBackButton()` | Navigates back via `flowRouter` |
| `openPrivacyLink(link: String)` | Opens privacy link in browser |
| `onEmptyStateAction()` | Refetches screen content |
| `filterPhoneNumber/TaxId/AccountNumber()` | Validates and limits input formats |
| `getFormattedErrorCode(code)` | Formats error code display |
| `getWwwAuthenticationType(accountType)` | Determines auth type from account type |

---

## 🧩 Presenter Components

### 🔸 `RecoverUserIdAccountPresenter`
| Property | Purpose |
|----------|---------|
| `accountTypes` | List of available account types |
| `accountTypeLabel` | Label for dropdown |
| `accountTypeDefaultValue` | Default dropdown text |
| `accountNumberLabel` | Label for account number field |
| `accountNumberTooltip*` | Tooltip texts & accessibility for account number |

---

### 🔸 `RecoverUserIdActionPresenter`
| Property | Purpose |
|----------|---------|
| `primaryButtonText` | Text for CTA (e.g., Continue) |
| `secondaryButtonText` | Text for back or secondary action |

---

### 🔸 `RecoverUserIdFieldErrorPresenter`
| Property / Method | Purpose |
|-------------------|---------|
| `problems` | List of inline field problems |
| `getError()` | Gets error details for a given field |
| `findErrorMessage()` | Gets localized error message |

---

### 🔸 `RecoverUserIdMastheadPresenter`
| Property | Purpose |
|----------|---------|
| `title` | Screen title |
| `shieldAccessibilityText` | Accessibility for shield icon |
| `privacyLink` | Link text/URL for privacy policy |

---

### 🔸 `RecoverUserIdPhoneNumberPresenter`
| Property | Purpose |
|----------|---------|
| `phoneNumberLabel` | Label for input field |
| `phoneNumberCheckboxLabel` | Checkbox label for international number |
| `phoneNumberTooltip*` | Tooltip texts and accessibility |

---

### 🔸 `RecoverUserIdTaxIdPresenter`
| Property | Purpose |
|----------|---------|
| `radioButtonGroupLabel` | Label for SSN/SIN toggle |
| `radioButtonTooltip*` | Tooltip and accessibility for radio group |
| `ssn/sinRadioButtonLabel` | Labels for options |
| `ssn/sinInputFieldLabel` | Labels for input fields |

---

### 🏷️ `AccountType.kt`
| Enum | Description |
|------|-------------|
| `DEPOSIT`, `LOAN`, `CARD` | Enum options for accountType |
| `types`, `from(type)` | Utilities to convert string to enum |

---

### 🛠️ ViewModel Presenter Factory Methods

| Method | Presenter |
|--------|-----------|
| `createActionPresenter()` | `RecoverUserIdActionPresenter` |
| `createMastheadPresenter()` | `RecoverUserIdMastheadPresenter` |
| `createPhoneNumberPresenter()` | `RecoverUserIdPhoneNumberPresenter` |
| `createTaxIdPresenter()` | `RecoverUserIdTaxIdPresenter` |
| `createAccountPresenter()` | `RecoverUserIdAccountPresenter` |
| `createErrorPresenter()` | `ProblemsPresenter` |
| `createProblemsFullPagePresenter()` | `ProblemsFullPagePresenter` |

---

> ✅ All presenter and view model changes listed here are used in both **Android** and **iOS** via Kotlin Multiplatform.