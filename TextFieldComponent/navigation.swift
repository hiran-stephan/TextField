override suspend fun updateAccountNickname(
    accountId: String,
    nickname: String,
): Flow<NetworkResultState<AccountPreferencesData>> {
    return safeApiCall {
        accounts
            .indexOfFirst { it.id == accountId }
            .takeIf { it != -1 }
            ?.let { id ->
                accounts[id] = accounts[id].copy(
                    nickname = if (nickname.isBlank()) null else nickname
                )
            }

        AccountPreferencesData(
            status = "SUCCESS",
            problems = listOf(
                ProblemApiData(
                    type = "error",
                    id = "strategic"
                )
            )
        )
    }
}
