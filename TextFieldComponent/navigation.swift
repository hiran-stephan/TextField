override suspend fun updateAccountNickname(
    accountId: String,
    nickname: String,
): Flow<NetworkResultState<AccountPreferencesData>> {
    return flow {
        // Simulate error scenario
        emit(
            NetworkResultState.Error(
                ProblemsException(
                    listOf(
                        ProblemApiData(
                            type = "error",
                            code = "0001", // Error code for simulation
                            message = "Simulated error message" // Optional message
                        )
                    )
                )
            )
        )
    }
}

