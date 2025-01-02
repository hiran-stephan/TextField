override suspend fun updateAccountPreferences(
    estatement: Boolean,
    accountId: String,
    nickname: String,
    visibility: Boolean?,
    consentType: String,
    consentVersion: String,
    consentTimestamp: String
): AccountPreferencesResponse {
    // Create Preferences object
    val preferences = Preferences(
        estatement = estatement,
        nickname = nickname,
        visibility = visibility ?: false
    )

    // Create AccountPreferences object
    val accountPreferences = AccountPreferences(
        id = accountId,
        preferences = preferences
    )

    // Create Consent object
    val consent = Consent(
        type = consentType,
        version = consentVersion,
        acceptTimestamp = consentTimestamp
    )

    // Create the request object
    val requestData = AccountPreferencesRequest(
        accounts = listOf(accountPreferences),
        consent = consent
    )

    // Make the API call
    return builder.safeClientCall(referenceId) {
        client.post {
            url {
                path(API_ACCOUNTS_UPDATE_PREFERENCES)
            }
            headers.append(HttpHeaders.ContentType, ContentType.Application.Json.toString())
            setBody(requestData)
        }
    }
}
