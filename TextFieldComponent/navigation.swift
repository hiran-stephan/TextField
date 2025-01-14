override suspend fun updateAccountNickname(
    accountId: String,
    nickname: String,
): Flow<NetworkResultState<AccountPreferencesData>> {
    return flow {
        // Emit Loading state
        emit(NetworkResultState.Loading("referenceId"))

        // Simulate different responses
        val simulateError = true // Change to 'false' to simulate success

        if (simulateError) {
            // Emit Failure state with ProblemsException
            emit(
                NetworkResultState.Failure(
                    referenceId = "referenceId",
                    exception = ProblemsException(
                        problems = listOf(
                            ProblemApiData(
                                type = "error",
                                code = "0001", // Error code
                                message = "Simulated error message"
                            )
                        )
                    )
                )
            )
        } else {
            // Emit Success state with AccountPreferencesData
            emit(
                NetworkResultState.Success(
                    referenceId = "referenceId",
                    data = AccountPreferencesData(
                        status = "SUCCESS",
                        problems = null // No problems for success
                    )
                )
            )
        }
    }
}
