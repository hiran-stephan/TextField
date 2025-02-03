@OptIn(ExperimentalCoroutinesApi::class)
class AccountPreferencesRepositoryTest {

    private val mockRemoteResourceApiService = mock<RemoteResourceApiService>()
    private val mockAccountsApiService = mock<AccountsApiService>()
    private val mockAccountCatalogue = mock<AccountCatalogue>()
    private val mockConnectivityChecker = mock<NetworkConnectivityChecker>()
    private val dispatcher = UnconfinedTestDispatcher()

    private lateinit var repository: AccountPreferencesRepository

    @BeforeTest
    fun setup() {
        Dispatchers.setMain(dispatcher)

        repository = AccountPreferencesRepositoryImpl(
            mockRemoteResourceApiService,
            mockAccountsApiService,
            mockAccountCatalogue
        )
    }

    @AfterTest
    fun tearDown() {
        Dispatchers.resetMain()
    }
}

@Test
fun `test loadAccounts successful`() = runTest {
    val accountSummaryApiData = getAccountsSummaryApiData()
    val accountGroups = mapAccountGroups(
        accountCatalogue = mockAccountCatalogue,
        accountSorter = mockAccountSorter,
        response = accountSummaryApiData
    ).filter { it.accounts.isNotEmpty() }

    val accountPreferencesAccountsData = AccountPreferencesAccountsData(
        accountGroups = accountGroups,
        problems = accountSummaryApiData.problems?.map { it.toProblemData() }
    )
    every { mockAccountSorter.sort(any()) } answers { it.invocation.args[0] as List<AccountPreferencesAccount> }

    every { mockConnectivityChecker.isConnected() } returns true
    every { mockAccountsApiService.fetchAccounts(any()) } returns accountSummaryApiData
    every { mockAccountCatalogue.formatAccountDisplayName(any(), any(), any()) } returns "Mocked Account Name"

    val result = repository.loadAccounts().last()

    (result as? NetworkResultState.Success)?.onSuccess { response ->
        assertEquals(accountPreferencesAccountsData, response)
    }
}



@Test
fun `test loadAccounts failure`() = runTest {
    everySuspend { mockAccountsApiService.fetchAccounts(any()) } throws Exception("API Error")

    val result = repository.loadAccounts().last()

    (result as? NetworkResultState.Failure)?.onException { response ->
        assertEquals("API Error", response.message)
    }
}



@Test
fun `test fetchAccountById successful`() = runTest {
    val accountId = "123"
    val mockAccountData = AccountPreferencesAccountData(account = mockAccountDetails(), problems = emptyList())

    everySuspend { mockAccountsApiService.fetchAccountById(any(), eq(accountId)) } returns mockAccountData

    val result = repository.fetchAccountById(accountId).last()

    (result as? NetworkResultState.Success)?.onSuccess { response ->
        assertEquals(mockAccountData, response)
    }
}


@Test
fun `test updateAccountNickname successful`() = runTest {
    val accountId = "123"
    val nickname = "New Nickname"
    val mockAccountData = AccountPreferencesAccountData(account = mockAccountDetails(), problems = emptyList())

    everySuspend { mockAccountsApiService.updateAccountNickname(any(), eq(accountId), eq(nickname)) } returns Unit
    everySuspend { mockAccountsApiService.fetchAccountById(any(), eq(accountId)) } returns mockAccountData

    val result = repository.updateAccountNickname(accountId, nickname).last()

    (result as? NetworkResultState.Success)?.onSuccess { response ->
        assertEquals(mockAccountData, response)
    }
}


@Test
fun `test updateAccountVisibility successful`() = runTest {
    val accountId = "123"
    val visibility = true
    val mockAccountData = AccountPreferencesAccountData(account = mockAccountDetails(), problems = emptyList())

    everySuspend { mockAccountsApiService.updateAccountVisibility(any(), eq(accountId), eq(visibility)) } returns Unit
    everySuspend { mockAccountsApiService.fetchAccountById(any(), eq(accountId)) } returns mockAccountData

    val result = repository.updateAccountVisibility(accountId, visibility).last()

    (result as? NetworkResultState.Success)?.onSuccess { response ->
        assertEquals(mockAccountData, response)
    }
}
