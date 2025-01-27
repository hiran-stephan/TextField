override suspend fun updateAccountNickname(
    accountId: String,
    nickname: String
): Flow<NetworkResultState<AccountPreferencesAccountData>> {
    return flow {
        // Step 1: Call updateAccountNickname API using safeApiCall
        safeApiCall { requestId ->
            accountsApiService.updateAccountNickname(
                requestId,
                accountId,
                nickname
            )
        }.collect { updateResult ->
            when (updateResult) {
                is NetworkResultState.Loading -> {
                    // Emit the loading state
                    emit(NetworkResultState.Loading(updateResult.id))
                }
                is NetworkResultState.Success -> {
                    // If update is successful, fetch account details
                    fetchAccountById(accountId).collect { fetchResult ->
                        when (fetchResult) {
                            is NetworkResultState.Success -> {
                                // Emit success with refreshed data
                                emit(
                                    NetworkResultState.Success(
                                        fetchResult.id,
                                        fetchResult.data
                                    )
                                )
                            }
                            is NetworkResultState.Failure -> {
                                // Emit partial success: update succeeded, but refresh failed
                                emit(
                                    NetworkResultState.Failure(
                                        fetchResult.id,
                                        Exception(
                                            "Update succeeded, but refresh failed",
                                            fetchResult.exception
                                        )
                                    )
                                )
                            }
                            is NetworkResultState.Loading -> {
                                // Emit loading state during fetch
                                emit(NetworkResultState.Loading(fetchResult.id))
                            }
                        }
                    }
                }
                is NetworkResultState.Failure -> {
                    // Emit the failure state with exception
                    emit(NetworkResultState.Failure(updateResult.id, updateResult.exception))
                }
            }
        }
    }
}
