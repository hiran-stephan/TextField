package com.cibc.account.preferences.data.datasources

import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow

class AccountPreferencesRepositoryMock : AccountPreferencesRepository {

    override suspend fun loadAccounts(): Flow<NetworkResultState<List<AccountPreferencesAccountGroup>>> {
        return flow {
            emit(NetworkResultState.Loading)
            delay(1000) // Simulate API call delay

            // Mocked account preference groups
            val accountGroups = listOf(
                getDepositAccountGroup(),
                getLoanAccountGroup(),
                getCreditAccountGroup()
            )

            emit(NetworkResultState.Success(accountGroups))
        }
    }

    override suspend fun loadResources(): Flow<NetworkResultState<ContentResources>> {
        return flow {
            emit(NetworkResultState.Loading)
            delay(500) // Simulate API call delay

            val customerServiceContent = ContentFile(
                id = "123",
                content = "Mock customer service content"
            )

            emit(NetworkResultState.Success(ContentResources(content = customerServiceContent)))
        }
    }

    private fun getDepositAccountGroup(): AccountPreferencesAccountGroup {
        val depositAccounts = listOf(
            AccountPreferencesAccount(
                id = "1",
                group = "DEPOSIT",
                accountNumber = "12345",
                maskedAccountNumber = "*12345",
                productName = "Savings Account",
                currentBalance = "500.00",
                availableBalance = "400.00",
                accountStatus = "ACTIVE"
            )
        )
        return AccountPreferencesAccountGroup(
            group = "DEPOSIT",
            accounts = depositAccounts
        )
    }

    private fun getLoanAccountGroup(): AccountPreferencesAccountGroup {
        val loanAccounts = listOf(
            AccountPreferencesAccount(
                id = "2",
                group = "LOAN",
                accountNumber = "67890",
                maskedAccountNumber = "*67890",
                productName = "Personal Loan",
                currentBalance = "2000.00",
                availableBalance = null,
                accountStatus = "ACTIVE"
            )
        )
        return AccountPreferencesAccountGroup(
            group = "LOAN",
            accounts = loanAccounts
        )
    }

    private fun getCreditAccountGroup(): AccountPreferencesAccountGroup {
        val creditAccounts = listOf(
            AccountPreferencesAccount(
                id = "3",
                group = "CREDIT",
                accountNumber = "11111",
                maskedAccountNumber = "*11111",
                productName = "Credit Card",
                currentBalance = "3000.00",
                availableBalance = "1000.00",
                accountStatus = "ACTIVE"
            )
        )
        return AccountPreferencesAccountGroup(
            group = "CREDIT",
            accounts = creditAccounts
        )
    }
}
