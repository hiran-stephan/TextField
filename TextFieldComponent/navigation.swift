@OptIn(ExperimentalCoroutinesApi::class)
class AccountPreferencesViewModelTest {

    private val locale: Locale = Locale("US")
    private lateinit var accountPreferencesViewModel: AccountPreferencesViewModel

    private val repository: AccountPreferencesRepository = mock()
    private val applicationRouter: ApplicationRouter = mock()
    private val flowRouter: AccountPreferencesFlowRouter = mock()
    private val messageCatalogue: MessageCatalogue = mock()
    private val accountCatalogue: AccountCatalogue = mock()
    private val analyticsHelper: AccountPreferencesAnalyticsHelper = mock()
    private val dispatcher = UnconfinedTestDispatcher()

    @BeforeTest
    fun setup() {
        Dispatchers.setMain(dispatcher)

        accountPreferencesViewModel = AccountPreferencesViewModel(
            flowRouter,
            applicationRouter,
            repository,
            messageCatalogue,
            accountCatalogue,
            analyticsHelper,
            locale
        )
    }

    @AfterTest
    fun tearDown() {
        Dispatchers.resetMain()
    }

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

    @Test
    fun `test fetch resources successful`() = runTest {
        val contentData = mock<ContentFileData>()

        everySuspend { repository.loadResources() } returns flow {
            emit(NetworkResultState.Success(id = "id", data = contentData))
        }

        accountPreferencesViewModel.fetchResources()

        val resourceState = accountPreferencesViewModel.resourceState.value
        assertEquals(resourceState.contentFile, contentData.content)
    }

    @Test
    fun `test fetch resources unsuccessful`() = runTest {
        val exception = Exception("Content is unavailable")

        everySuspend { repository.loadResources() } returns flow {
            emit(NetworkResultState.Failure(id = "id", exception = exception))
        }

        accountPreferencesViewModel.fetchResources()

        val resourceState = accountPreferencesViewModel.resourceState.value
        assertEquals(resourceState.contentFile, null)
    }
}
