Account Preferences Details ViewModel

AccountPreferencesDetailsViewModel is responsible for managing the UI state and logic for the Account Preferences Details screen.

This ViewModel extends a base ViewModel (likely from KoinComponent) and uses dependency injection to receive its collaborators.

Injected Dependencies:

AccountPreferencesRepository

ApplicationRouter

AccountPreferencesFlowRouter

Locale

MessageCatalogue

AccountCatalogue

AccountPreferencesAnalyticsHelper

State Management:

_uiState: MutableStateFlow<AccountPreferencesDetailsUiState>

_resourceState: MutableStateFlow<AccountPreferencesDetailsResourceUiState>

_actionState: MutableStateFlow<AccountPreferencesDetailsActionState>

Public state wrappers:

uiState, resourceState, actionState

uiStateWrapped, resourceStateWrapped, actionStateWrapped (for iOS compatibility)

Methods:

attachViewModel(navItem: SettingsNavigationItems.AccountPreferencesDetails)

Should be the first method called from the UI

Sets navigationItem and triggers fetchAccountById

Sends an analytics event: trackAccountPreferenceDetailsState

fetchAccountById()

Uses navigationItem.id to load account details

Updates uiState with loading, success, or error

On success: updates accountPreferencesAccountDetails and tracks loading

On failure: sets error in the state

fetchResources()

Loads supplementary resources (e.g., content file)

Updates _resourceState with result or error

updateAccountNickname(accountId: String, nickname: String)

Sends updated nickname to the backend

Tracks loading

On success: updates account state and sets accountPreferencesUpdateComplete = true

On failure: sets errorAccountPreferenceUpdate and disables isEditingNickname

updateAccountVisibility(accountId: String, visibility: Boolean)

Updates account visibility flag

Tracks loading and analytics (trackAccountVisibility)

On success: updates account state and sets accountPreferencesUpdateComplete = true

On failure: sets errorAccountPreferenceUpdate
