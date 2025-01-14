override suspend fun updateAccountNickname(
    accountId: String,
    nickname: String,
): Flow<NetworkResultState<AccountPreferencesData>> {
    return safeApiCall {
        emit(
            NetworkResultState.Failure(
                referenceId = UUID.randomUUID().toString(),
                exception = ProblemsException(
                    problems = listOf(
                        ProblemApiData(
                            type = "error",
                            code = "CUSTOM_ERROR_CODE",
                            message = "Simulated API error"
                        )
                    )
                )
            )
        )
    }
}
