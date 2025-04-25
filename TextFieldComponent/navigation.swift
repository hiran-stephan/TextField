Shared Module – AccountPreferencesDetailsViewModel (KMP)

This section describes the shared module implementation in the KMP (Kotlin Multiplatform) project for handling Account Preferences logic. It defines the data flow, state management, and presenter-based UI formatting for the AccountPreferencesDetailsViewModel class and its associated presenters. This code is platform-agnostic and reused across Android and iOS clients.

ViewModel Dependencies

Injected through constructor:

AccountPreferencesRepository

ApplicationRouter

AccountPreferencesFlowRouter

MessageCatalogue

AccountCatalogue

AccountPreferencesAnalyticsHelper

Locale

State Management

1. AccountPreferencesDetailsUiState

Maintains the current account preference details, editing states, and error handling.

Derived properties:

hasData, hasError, hasUnexpectedError, hasAccountPreferenceUpdateError

Overrides for error() and loading()

2. AccountPreferencesDetailsResourceUiState

Handles content file loading for localized UI.

3. AccountPreferencesDetailsActionState

Captures transient UI actions with their own loading and error state.

4. DialogState

Provides the structure to build simple alert dialog UI content.

Core Methods

Initialization & Data Fetch

attachViewModel(...)

fetchAccountById()

fetchResources()

Update APIs

updateAccountNickname(...)

updateAccountVisibility(...)

User Actions

Nickname

onStartEditingNickname()

onCancelEditingNickname()

onChangeNickname()

onSaveNickname()

filterNickname()

canEditNickname()

Visibility

onChangeAccountVisibilityToggle()

onAccountVisibilityChangeAccepted()

onAccountVisibilityChangeCancelled()

onSaveVisibility()

Dialog Alerts

onShowAccountDisplayInfoIconAlert()

onShowAccountNicknameInfoIconAlert()

Navigation

onNavigateBack()

onSignOut()

Analytics

trackAccountPreferenceDetailsState()

trackAccountEditNicknameStatus()

trackAccountEditNicknameSaveStatus()

trackAccountVisibility(successful: Boolean)

trackAccountVisibilityAlert(status: Boolean)

Presenter Builders (UI Formatters)

ViewModel provides factory methods for various presenters:

fun createAccountHideDialogPresenter()
fun createAccountShowDialogPresenter()
fun createMastheadPresenter()
fun createAccountPreferencesDetailsCardPresenter()
fun createAccountNicknameFormPresenter()
fun createAccountPreferencesGlobalAlertPresenter()
fun createProblemsListPresenter(error: Throwable?)
fun createProblemsFullPagePresenter(stateError: Throwable?, resourceError: Throwable?)
fun createErrorPresenter(error: Throwable?)
fun createAccountPresenter(account: AccountPreferencesAccount)
fun getAccountDialogState(isAccountHidden: Boolean): DialogState

Presenters

This section details each presenter class used to generate formatted, localized, and accessible data from the shared state and content file for UI display. Each presenter is initialized with a ContentFile and Locale, and formats specific sections of the Account Preferences UI.

AccountPreferencesAccountHideDialogPresenter

Used to localize content for the account visibility hide confirmation alert dialog.

accountDisplayDialogTitleText

accountDisplayDialogBodyText

accountControlDisplayBackButtonText

accountControlDisplayContinueButtonText
All text values are fetched using content keys from ContentConstants with localization support.

AccountPreferencesAccountShowDialogPresenter

Provides content for the account visibility show confirmation alert dialog.

accountDisplayShowDialogTitleText

accountDisplayShowDialogBodyText

accountControlDisplayShowBackButtonText

accountControlDisplayShowContinueButtonText

These are mirror keys of the hide presenter but tailored for the show scenario.
Mirrors hide presenter with alternate content keys for account show alert.

AccountPreferencesDetailsAccountNicknameFormPresenter

Used to populate nickname editing form fields.

accountNicknameFieldLabelText

accountNicknameFieldCloseButtonAccessibilityText

accountNicknameInlineMessageText

accountNicknameSaveButtonText

accountNicknameCancelButtonText

This presenter formats both label and accessibility-friendly messages.

AccountPreferencesDetailsCardPresenter

Used to format the account card section displayed at the top of the screen.

accountControlInfoIconAccessibilityText

accountControlInfoIconDialogBodyText

accountNicknameHeaderTitle, accountNicknameInfoIconDialogBodyText

accountNicknameAddNicknameButtonText

accountDisplayHideThisAccountText

Includes titles, help icons, and action button labels.

AccountPreferencesDetailsAccountPresenter

Formats and provides access to all data needed for rendering an individual account in the account preferences screen.

Inputs:

accountPreferencesAccount: AccountPreferencesAccount

error: Throwable?

contentFile: ContentFile?

locale: Locale

accountCatalogue: AccountCatalogue

Responsibilities:

Formats the account name using the accountCatalogue.formatAccountDisplayName() API combining nickname, product name, and lookup key.

Returns accountNumber as a masked account number for privacy.

Provides computed fields:

itemFirstRowLabel → always shows accountName

itemSecondRowLabel → shows accountNumber alone or with prefix depending on nickname availability

Extracts error codes from Throwable? and builds:

isNicknameRetrieved: true if nickname retrieval didn’t fail with specific error code

isShowHideRetrieved: true if visibility status is available (error-free)

Resolves display content with localization via ContentFile.findContentValue():

visibilityLabel and visibilityLabelAccessibilityText

notCurrentlyAvailableText (nickname fallback text)

nickname: Uses localized fallback if nickname is not retrieved

This presenter acts as the bridge between raw backend data and localized, display-friendly UI content for one account.

AccountPreferencesDetailsMastheadPresenter

Provides the screen header title for the Preferences page.

screenTitle fetched using PREFERENCE_SETTINGS_PRIMARY_HEADER_TITLE

AccountPreferencesGlobalAlertPresenter

Used to generate banner alert content for confirmation scenarios.

accountPreferencesConfirmationBannerBodyText is localized and retrieved from ACCOUNT_PREFERENCES_CONFIRMATION_BANNER_BODY_TEXT

