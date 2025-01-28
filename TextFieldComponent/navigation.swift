override suspend fun updateAccountVisibility(
    accountId: String,
    visibility: Boolean
): Flow<NetworkResultState<AccountPreferencesAccountData>> {
    return safeApiCall {
        // Find the account by ID and update the visibility
        accounts.indexOfFirst { it.id == accountId }
            .takeIf { it != -1 } // Check if account exists
            ?.let { index ->
                val updatedAccount = accounts[index].copy(
                    visibility = visibility
                )
                accounts[index] = updatedAccount // Update the account in the list

                // Return the updated account data
                AccountPreferencesAccountData(
                    account = updatedAccount,
                    problems = null // Update this if you have any problems to attach
                )
            } ?: throw Exception("Account not found") // Handle the case where the account is not found
    }
}
