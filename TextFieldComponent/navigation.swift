override suspend fun updateAccountNickname(
    accountId: String,
    nickname: String
): Flow<NetworkResultState<AccountPreferencesAccountData>> {
    return safeApiCall { requestId ->
        accountsApiService.updateAccountNickname(
            referenceId = requestId,
            accountId = accountId,
            nickname = nickname
        ).toAccountPreferencesData()
    }.transform { updateResult ->
        when (updateResult) {
            is NetworkResultState.Success -> {
                emitAll(fetchAccountById(accountId)) // Use emitAll for the next flow
            }
            is NetworkResultState.Error -> {
                emit(NetworkResultState.Error(updateResult.error)) // Directly emit the error
            }
            else -> {
                emit(NetworkResultState.Error(Exception("Unknown error occurred")))
            }
        }
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
