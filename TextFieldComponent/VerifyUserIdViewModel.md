
# VerifyUserIdViewModel - Shared Changes

## ViewModel

### Class
`VerifyUserIdViewModel`

### Dependencies

| Dependency | Type |
|------------|------|
| `repository` | `RecoverUserIdRepository` |
| `remoteResourceRepository` | `RemoteResourceRepository` |
| `messageCatalogue` | `MessageCatalogue` |
| `locale` | `Locale` |
| `applicationRouter` | `ApplicationRouter` |
| `flowRouter` | `RecoverUserIdFlowRouter` |
| `analyticsHelper` | `RecoverUserIdAnalyticsHelper` |

### State

| Property | Type | Purpose |
|----------|------|---------|
| `verifyUserIdState` | `MutableStateFlow<VerifyUserIdUiState>` | UI state for Verify screen |
| `verifyUserIdStateWrapped` | `FlowWrapper<VerifyUserIdUiState>` | Exposed state for UI binding |
| `verifyUserIdResourceUiState` | `MutableStateFlow<VerifyUserIdResourceUiState>` | Holds content file and loading state |
| `verifyUserIdResourceUiStateWrapped` | `FlowWrapper<VerifyUserIdResourceUiState>` | Exposed resource state |
| `navigationItem` | `AuthenticationNavigationItems.VerifyUserId?` | Stores navigation input |

## ViewModel Actions

| Function | Purpose |
|----------|---------|
| `init { fetchResources() }` | Initializes and loads content |
| `attachViewModel(navItem: AuthenticationNavigationItems.VerifyUserId)` | Updates friendly ID and tracks screen |
| `fetchResources()` | Loads contentFile from remote and updates resource state |
| `onTapContinueButton()` | Navigates back to login using flow router |
| `onTapBackButton()` | Navigates back using flow router |
| `onEmptyStateAction()` | Reloads resources |
| `openPrivacyLink(link: String)` | Opens privacy link in in-app browser |
| `onCopyUserIdAction()` | Tracks user ID copy event via analytics |

## UI State

### VerifyUserIdUiState

| Property | Type | Purpose |
|----------|------|---------|
| `friendlyId` | `String?` | Stores user ID |
| `isLoading` | `Boolean` | Loading indicator |
| `error` | `Throwable?` | Captures state error |
| `hasError` | `Boolean` | True if error exists |
| `hasData` | `Boolean` | Always `true` (used for UI visibility) |
| `hasUnexpectedError` | `Boolean` | Checks if error message equals "0001" |

### VerifyUserIdResourceUiState

| Property | Type | Purpose |
|----------|------|---------|
| `contentFile` | `ContentFile?` | Holds localized UI content |
| `isLoading` | `Boolean` | Resource loading flag |
| `error` | `Throwable?` | Captures resource error |
| `hasError` | `Boolean` | True if error exists |
| `hasUnexpectedError` | `Boolean` | Same logic as UI state |

---

## Presenters

### VerifyUserIdPagePresenter

| Property | Purpose |
|----------|---------|
| `verifyUserIdTitle` | Screen title |
| `verifyUserIdAlertMessage` | Alert shown for confirmation |
| `verifyUserIdDropdownFieldLabel` | Dropdown label |
| `verifyUserIdDropdownFieldIconAccessibilityText` | Accessibility label for icon |
| `primaryButtonText` | Primary CTA button text |
| `shieldAccessibilityText` | Accessibility description for shield |
| `privacyLink` | External privacy URL |

### ViewModelPresenter Functions

| Function | Purpose |
|----------|---------|
| `createProblemsFullPagePresenter()` | Maps problem data to full page error |
| `createErrorPresenter()` | Maps problem data to inline error |
| `createVerifyUserIdPagePresenter()` | Creates presenter with contentFile and locale |
