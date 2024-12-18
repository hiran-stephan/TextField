fun mapAccountGroups(
    accountCatalogue: AccountCatalogue,
    accountSorter: AccountSorter,
    response: AccountsSummaryApiData
): List<AccountGroup> {
    return response.meta.groups
        .filter { group -> // Filter groups with non-empty accounts
            val accountList = mapAccountsForGroup(response, group, accountCatalogue)
            accountList.isNotEmpty()
        }
        .map { group ->
            AccountGroup(
                label = group.id,
                accounts = accountSorter.sort(
                    accountList = mapAccountsForGroup(response, group, accountCatalogue)
                )
            )
        }
}
