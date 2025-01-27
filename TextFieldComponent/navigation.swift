override suspend fun updateAccountNickname(
    accountId: String,
    nickname: String
): Flow<NetworkResultState<AccountPreferencesAccountData>> = flow {
    safeApiCall { requestId ->
        accountsApiService.updateAccountNickname(
            referenceId = requestId,
            accountId = accountId,
            nickname = nickname
        ).toAccountPreferencesData()
    }.collect { updateResult ->
        when (updateResult) {
            is NetworkResultState.Success -> {
                emit(fetchAccountById(accountId, updateResult.data.referenceId))
            }
            is NetworkResultState.Error -> {
                emit(NetworkResultState.Error(updateResult.error))
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
