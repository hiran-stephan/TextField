override suspend fun updateAccountNicknameAndFetch(
    accountId: String,
    nickname: String
): Flow<NetworkResultState<AccountPreferencesAccountData>> {
    return flow {
        // Step 1: Update the account nickname
        updateAccountNickname(accountId, nickname).collect { updateResult ->
            when (updateResult) {
                is NetworkResultState.Success -> {
                    // Step 2: Fetch account details if update is successful
                    fetchAccountById(accountId).collect { fetchResult ->
                        emit(fetchResult) // Emit the result of fetching the account
                    }
                }
                else -> {
                    // Emit the update result (error or loading)
                    emit(updateResult)
                }
            }
        }
    }.catch { e ->
        // Handle any exceptions
        emit(NetworkResultState.Error(e))
    }
}



fun updateAccountNickname(accountId: String, nickname: String) = launch(_actionState) {
    repository.updateAccountNickname(accountId, nickname).collect { result ->
        result.isLoading { isLoading ->
            applicationRouter.trackBlockingLoading(result.id, isLoading)
        }
        onStateSuccess(result) { response ->
            copy(
                accountPreferencesUpdateComplete = true,
                accountData = response // Updated account data after fetching
            )
        }
        onStateException(result) { response ->
            copy(
                isLoading = false,
                error = response
            )
        }
    }
}
