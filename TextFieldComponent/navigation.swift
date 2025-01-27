override suspend fun updateAccountNickname(
    accountId: String,
    nickname: String
): Flow<NetworkResultState<AccountPreferencesAccountData>> {
    return flow {
        // Step 1: Call updateAccountNickname API
        val updateResult = safeApiCall { requestId ->
            accountsApiService.updateAccountNickname(
                requestId,
                accountId,
                nickname
            )
        }

        when (updateResult) {
            is NetworkResultState.Success -> {
                // Step 2: Reset cache (optional, depends on your implementation)
                cache.clear()

                // Step 3: Call fetchAccountById to refresh data
                fetchAccountById(accountId).collect { fetchResult ->
                    when (fetchResult) {
                        is NetworkResultState.Success -> {
                            // Emit success with refreshed data
                            emit(fetchResult)
                        }
                        is NetworkResultState.Error -> {
                            // Emit partial success: update succeeded, but refresh failed
                            emit(
                                NetworkResultState.Error(
                                    Exception("Update was successful, but refresh failed", fetchResult.exception)
                                )
                            )
                        }
                        is NetworkResultState.Loading -> {
                            // Emit loading state during the fetch process
                            emit(NetworkResultState.Loading)
                        }
                    }
                }
            }
            is NetworkResultState.Error -> {
                // Step 4: Handle update failure
                emit(NetworkResultState.Error(updateResult.exception))
            }
            is NetworkResultState.Loading -> {
                // Emit loading state during the update process
                emit(NetworkResultState.Loading)
            }
        }
    }.retryWhen { cause, attempt ->
        // Retry logic for transient failures
        if (attempt < 2) { // Retry up to 2 times
            delay(2000) // Wait 2 seconds before retrying
            true
        } else {
            false
        }
    }.catch { e ->
        // Handle any unexpected exceptions
        emit(NetworkResultState.Error(e))
    }
}
