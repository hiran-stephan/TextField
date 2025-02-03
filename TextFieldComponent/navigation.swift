@Test
    fun `test fetch account groups successful`() = runTest {
        val accountGroups = listOf(mock<AccountGroupData>())
        
        everySuspend { repository.loadAccounts() } returns flow {
            emit(NetworkResultState.Success(id = "id", data = accountGroups))
        }

        accountPreferencesViewModel.fetchAccountGroups()

        val uiState = accountPreferencesViewModel.uiState.value
        assertEquals(uiState.accountPreferencesAccountsData, accountGroups)
    }

    @Test
    fun `test fetch account groups error`() = runTest {
        val exception = ProblemsException(listOf(ProblemData("0001", "error")))

        everySuspend { repository.loadAccounts() } returns flow {
            emit(NetworkResultState.Failure(id = "id", exception = exception))
        }

        accountPreferencesViewModel.fetchAccountGroups()

        val uiState = accountPreferencesViewModel.uiState.value
        assertEquals(uiState.error, exception)
    }
