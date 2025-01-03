private fun prepareRequestData(
    accountId: String,
    preferences: PreferencesApiData
): AccountPreferencesRequestApiData {
    val accountPreferences = AccountPreferencesApiData(
        id = accountId,
        preferences = preferences
    )
    return AccountPreferencesRequestApiData(
        accounts = listOf(accountPreferences)
    )
}


private suspend fun performApiCall(
    referenceId: String,
    requestData: AccountPreferencesRequestApiData
): AccountPreferencesResponseApiData {
    return builder.safeClientCall<AccountPreferencesResponseApiData>(referenceId, {
        cache.clear()
    }) {
        client.patch {
            url {
                path(API_UBS_AI_ACCOUNT_PREFERENCES)
                appendSessionToken()
                headers.append(HttpHeaders.ContentType, ContentType.Application.Json)
            }
            setBody(requestData)
        }
    }
}




override suspend fun updateAccountNickname(
    referenceId: String,
    accountId: String,
    nickname: String
): AccountPreferencesResponseApiData {
    val preferences = PreferencesApiData(nickname = nickname)
    val requestData = prepareRequestData(accountId, preferences)
    return performApiCall(referenceId, requestData)
}


override suspend fun updateAccountVisibility(
    referenceId: String,
    accountId: String,
    visibility: Boolean?
): AccountPreferencesResponseApiData {
    val preferences = PreferencesApiData(visibility = visibility ?: false)
    val requestData = prepareRequestData(accountId, preferences)
    return performApiCall(referenceId, requestData)
}
