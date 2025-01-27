override suspend fun updateAccountNickname(
    accountId: String,
    nickname: String
): Flow<NetworkResultState<AccountPreferencesAccountData>> {
    return flow {
        try {
            // Step 1: Call updateAccountNicknameInternal API
            updateAccountNicknameInternal(accountId, nickname).collect { updateResult ->
                when (updateResult) {
                    is NetworkResultState.Success -> {
                        // Step 2: If successful, call fetchAccountById
                        fetchAccountById(accountId).collect { fetchResult ->
                            emit(fetchResult) // Emit the result of fetchAccountById
                        }
                    }
                    else -> {
                        // Step 3: Emit update result directly (error/loading)
                        emit(updateResult)
                    }
                }
            }
        } catch (e: Exception) {
            // Handle exceptions and emit error state
            emit(NetworkResultState.Error(e))
        }
    }
}
