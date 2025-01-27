override suspend fun updateAccountNickname(
    accountId: String,
    nickname: String
): Flow<NetworkResultState<AccountPreferencesAccountData>> {
    return flow {
        // Call updateAccountNickname API
        updateAccountNicknameInternal(accountId, nickname).collect { updateResult ->
            when (updateResult) {
                is NetworkResultState.Success -> {
                    // If the nickname update is successful, call fetchAccountById
                    fetchAccountById(accountId).collect { fetchResult ->
                        emit(fetchResult) // Emit the result of fetchAccountById
                    }
                }
                else -> {
                    // Emit the update result directly (error/loading)
                    emit(updateResult)
                }
            }
        }
    }.catch { e ->
        // Emit error if any exception occurs
        emit(NetworkResultState.Error(e))
    }
}

// Separate internal function for updating the nickname
private suspend fun updateAccountNicknameInternal(
    accountId: String,
    nickname: String
): Flow<NetworkResultState<Unit>> {
    return safeApiCall { requestId ->
        accountsApiService.updateAccountNickname(
            requestId,
            accountId,
            nickname
        )
    }
}
