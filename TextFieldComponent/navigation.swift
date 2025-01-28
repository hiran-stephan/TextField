override suspend fun updateAccountNickname(
    accountId: String,
    nickname: String
): Flow<NetworkResultState<AccountPreferencesAccountData>> {
    return safeApiCall {
        // Find the account by ID and update the nickname
        accounts.indexOfFirst { it.id == accountId }
            .takeIf { it != -1 } // Check if account exists
            ?.let { index ->
                val updatedAccount = accounts[index].copy(
                    nickname = nickname.takeUnless { it.isBlank() }
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
