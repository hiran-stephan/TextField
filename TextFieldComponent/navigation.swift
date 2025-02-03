@OptIn(ExperimentalCoroutinesApi::class)
class AccountPreferencesViewModelTest {

    private val locale: Locale = Locale("US")
    private lateinit var accountPreferencesViewModel: AccountPreferencesViewModel

    // Use a real mock repository instead of manually creating mock data
    private val repository: AccountPreferencesRepositoryMock = AccountPreferencesRepositoryMock()
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
            repository,  // Using the mock repository instance
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
    fun `test fetch resources successful`() = runTest {
        // Directly using mock repository's method that returns predefined mock data
        everySuspend { repository.loadResources() } returns flow {
            emit(NetworkResultState.Success(id = "id", data = repository.mockContentResources))
        }

        accountPreferencesViewModel.fetchResources()

        val resourceState = accountPreferencesViewModel.resourceState.value
        assertEquals(resourceState.contentFile, repository.mockContentResources.content)
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

    @Test
    fun `test fetch account groups successful`() = runTest {
        everySuspend { repository.loadAccounts() } returns flow {
            emit(NetworkResultState.Success(id = "id", data = repository.mockAccountGroups))
        }

        accountPreferencesViewModel.fetchAccountGroups()

        val uiState = accountPreferencesViewModel.uiState.value
        assertEquals(uiState.accountPreferencesAccountsData, repository.mockAccountGroups)
    }

    @Test
    fun `test fetch account groups error`() = runTest {
        everySuspend { repository.loadAccounts() } returns flow {
            emit(NetworkResultState.Failure(id = "id", exception = repository.mockProblemException))
        }

        accountPreferencesViewModel.fetchAccountGroups()

        val uiState = accountPreferencesViewModel.uiState.value
        assertEquals(uiState.error, repository.mockProblemException)
    }
}
