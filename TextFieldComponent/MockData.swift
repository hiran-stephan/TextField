Component Overview
Component Name: ManageAlertsRepository

Layer: Domain (Interface) & Data (Implementation)

Purpose:
Acts as the central contract for managing alert-related operations. This includes fetching, creating, updating, and deleting alerts, as well as retrieving alert configurations and user contact information.

2. Responsibilities
Retrieve all alert configurations and user subscriptions grouped by category.

Fetch alert preferences for a specific category or subcategory.

Create, update, and delete user alert subscriptions.

Download and cache alert configuration data from remote sources.

Retrieve eligible accounts for alert delivery.

Fetch detailed alert settings for a specific alert/account combination.

Get the user’s primary email address and phone number.

3. Interface Design
The ManageAlertsRepository interface exposes all methods as suspend functions returning Flow<NetworkResultState<...>>.

Promotes:

Asynchronous, reactive data handling.

Single Responsibility Principle.

High testability and separation of concerns.

4. Implementation Details
Class: ManageAlertsRepositoryImpl

Dependencies:

AlertsApiService, AccountsApiService, RemoteResourceApiService, ProfileApiService – For network communication.

ManageAlertsBusinessLogic – For domain-specific transformations and validations.

ManageAlertsRepositoryApplicationCache, ManageAlertsRepositoryAlertsCache – For local in-memory caching.

Caching Strategy:

Caches alert preferences and configuration resources locally to reduce redundant API calls.

Error Handling:

Uses LocalErrorException for invalid or missing data scenarios.

All network calls wrapped using safeApiCall / safeApiCoroutineCall for consistent error propagation.

Data Transformation:

API responses are mapped to domain models.

Data is grouped/filtered as required by business logic.

5. Sequence Example – Fetch Alerts
UI calls fetchAlerts().

Repository checks cache; if data is missing, triggers API call.

Combines API results with local resource configurations.

Returns grouped alert preferences and caches them.

6. Extensibility
Easily supports new alert types, categories, or delivery channels by updating domain models and business logic.

Minimal/no changes required in the repository interface.

7. Error Handling
All methods return NetworkResultState, encapsulating:

Success

Loading

Error

Ensures uniform and predictable error handling at the UI level.

8. Security & Compliance
Email and phone number are retrieved securely and only when required.

All network calls follow secure communication protocols and input validations.

9. Summary Table
                                ### ✅ Summary Table

                                | **Method**                         | **Responsibility**                                             | **Returns**                         |
                                |-----------------------------------|----------------------------------------------------------------|-------------------------------------|
                                | `fetchAlerts()`                   | Fetch all alert configs and user subscriptions                | `Flow<GroupedAlertConfig>`          |
                                | `fetchCategoryAlertPreferences()` | Fetch alert preferences for a specific category               | `Flow<SubcategoryGroupedAlertConfig>` |
                                | `createAlert()`                   | Create a new alert subscription                                | `Flow<Boolean>`                     |
                                | `deleteAlert()`                   | Delete an existing alert subscription                          | `Flow<Boolean>`                     |
                                | `updateAlert()`                   | Update an existing alert subscription                          | `Flow<Boolean>`                     |
                                | `fetchResources()`                | Download & cache alert config resources                        | `Flow<ResourceConfig>`              |
                                | `fetchAlertAccountsConfig()`      | Retrieve eligible accounts for a given alert                   | `Flow<AccountPreferenceData>`       |
                                | `fetchAlertsSettings()`           | Fetch settings for a specific alert/account                    | `Flow<AlertSettingsConfig>`         |
                                | `fetchCustomerContactData()`      | Get the user’s primary contact details (email/phone)           | `Flow<ContactInfo>`                 |
