private val allAccounts = mutableListOf(
    AccountPreferencesAccount(
        id = "af9f1f3...1",
        productName = "EASYPATH ACCESS ACCOUNT",
        nickname = "Sync Meeting Demo",
        groupType = AccountGroupType.DEPOSIT,
        // ...
    ),
    AccountPreferencesAccount(
        id = "5114618...2",
        productName = "SMALL BUSINESS BANKING",
        groupType = AccountGroupType.DEPOSIT,
        // ...
    ),
    AccountPreferencesAccount(
        id = "3af506a...3",
        productName = "INSTALLMENT",
        groupType = AccountGroupType.LOAN,
        // ...
    ),
    AccountPreferencesAccount(
        id = "db0f305...4",
        productName = "REVOLVING CREDIT",
        groupType = AccountGroupType.CREDIT,
        // ...
    ),
    // ... more accounts ...
)


override suspend fun loadAccounts(): Flow<NetworkResultState<List<AccountPreferencesAccountGroup>>> = flow {
    val depositAccounts = allAccounts.filter { it.groupType == AccountGroupType.DEPOSIT }
    val loanAccounts = allAccounts.filter { it.groupType == AccountGroupType.LOAN }
    val creditAccounts = allAccounts.filter { it.groupType == AccountGroupType.CREDIT }

    emit(
        NetworkResultState.Success(
            listOf(
                AccountPreferencesAccountGroup(label = "DEPOSIT", accounts = depositAccounts),
                AccountPreferencesAccountGroup(label = "LOAN",    accounts = loanAccounts),
                AccountPreferencesAccountGroup(label = "CREDIT",  accounts = creditAccounts)
            )
        )
    )
}



override suspend fun updateAccountNickname(
    accountId: String,
    nickname: String
): Flow<NetworkResultState<AccountPreferencesData>> = flow {
    val idx = allAccounts.indexOfFirst { it.id == accountId }
    if (idx != -1) {
        val oldAccount = allAccounts[idx]
        allAccounts[idx] = oldAccount.copy(nickname = nickname)
    }

    emit(
        NetworkResultState.Success(
            AccountPreferencesData(
                status = "SUCCESS",
                problems = listOf(/* ... */)
            )
        )
    )
}
 
val matchingAccount = allAccounts.firstOrNull { it.id == accountId }

accounts
    .indexOfFirst { it.id == accountId }
    .takeIf { it != -1 }
    ?.let { idx ->
        accounts[idx] = accounts[idx].copy(nickname = newNickname)
    }

accounts.find { it.id == accountId }?.let { oldAccount ->
    val idx = accounts.indexOf(oldAccount)
    accounts[idx] = oldAccount.copy(nickname = newNickname)
}
