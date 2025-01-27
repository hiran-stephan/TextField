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
    }.map { updateResult ->
        when (updateResult) {
            is NetworkResultState.Success -> fetchAccountById(accountId, updateResult.data.referenceId)
            is NetworkResultState.Error -> NetworkResultState.Error(updateResult.error)
            else -> NetworkResultState.Error(Exception("Unknown error occurred"))
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
