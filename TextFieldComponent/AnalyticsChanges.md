
# Analytics Changes

The following analytics events have been integrated for the Account Preferences feature using Adobe Analytics:

## State Tracking

- **Account Preferences List Screen**  
  Triggered via: `trackAccountPreferenceListState()`  
  Maps to: `properties.stateAccountPreferenceList()`

- **Account Preferences Details Screen**  
  Triggered via: `trackAccountPreferenceDetailsState()`  
  Maps to: `properties.stateAccountPreferenceDetails()`

## User Actions

- **Hide Account Verification**  
  - `trackAccountHideVerificationAction()`  
  - `trackAccountHideConfirmAction(status: Boolean)`

- **Show Account Verification**  
  - `trackAccountShowVerificationAction()`  
  - `trackAccountShowConfirmAction(status: Boolean)`

- **Nickname Actions**  
  - `trackAccountEditNicknameAction()`  
  - `trackAccountEditNicknameSaveAction()`

## Helper Structure

All tracking is handled via:
- `AccountPreferencesAnalyticsHelper` (interface)
- `AccountPreferencesAnalyticsHelperImpl` (implementation)

Each method calls into the `AdobeAnalyticsPagePlugin` using helper functions:
- `trackState(stateAnalyticsData: StateAnalyticsData)`
- `trackAction(stateAnalyticsData: StateAnalyticsData, actionAnalyticsData: ActionAnalyticsData)`

## Supporting Properties

Analytics metadata is built from:
- `AccountPreferencesAnalyticsProperties.kt`  
  Provides page context and interaction identifiers (e.g., `"account-preferences"`, `"manage-account"`)

