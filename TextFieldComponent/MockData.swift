@OptIn(ExperimentalCoroutinesApi::class)
class ManageAlertsSubCategoriesViewModelTest {

    private val repository = mock<ManageAlertsRepository>()
    private lateinit var featureRouter: ManageAlertsFeatureRouter
    private lateinit var manageAlertsSubCategoriesViewModel: ManageAlertsSubCategoriesViewModel
    private val dispatcher = UnconfinedTestDispatcher()
    private val appRouter = mockApplicationRouters(MockMode.autoUnit)
    private val stepUpHandler = mock<StepUpHandler>()
    private val messageCatalogue = mock<MessageCatalogue>()
    private val locale: Locale = Locale(appRegion = "US")
    private val analyticsHelper = mock<ManageAlertsAnalyticsHelper>()
    private val eventQueue = EventQueueImpl()

    @BeforeTest
    fun setup() {
        startKoin {
            modules(
                module {
                    single { manageAlertsDiModule() }
                    single { stepUpHandler }
                }
            )
        }

        featureRouter = ManageAlertsFeatureRouter(appRouter)
        Dispatchers.setMain(dispatcher)

        manageAlertsSubCategoriesViewModel = ManageAlertsSubCategoriesViewModel(
            repository = repository,
            featureRouter = featureRouter,
            messageCatalogue = messageCatalogue,
            analyticsHelper = analyticsHelper,
            locale = locale,
            subCategoryNavigationItem = ManageAlertsNavigationItems.SubCategory(categoryId = "testCategory"),
            eventQueue = eventQueue,
        )
    }

    @AfterTest
    fun tearDown() {
        stopKoin()
        Dispatchers.resetMain()
    }

    @Test
    fun `goBack calls featureRouter parent popBack`() = runTest {
        manageAlertsSubCategoriesViewModel.goBack()
        verify(exactly = 1) {
            featureRouter.parent.popBack()
        }
    }

    @Test
    fun `navigateToSubCategoryAlerts calls featureRouter navigateTo with SubCategoryAlerts`() = runTest {
        val alertId = "testAlert"
        manageAlertsSubCategoriesViewModel.navigateToAlertSelectionScreen(alertId, isAlertTypeAccount = false)
        verify(exactly = 1) {
            featureRouter.navigateTo(
                ManageAlertsNavigationItems.AlertsSettings(
                    categoryId = "testCategory",
                    alertId = alertId,
                ),
            )
        }
    }

    @Test
    fun `navigateToSubCategoryAlertsAccounts calls featureRouter navigateTo with SubCategoryAlertsAccounts`() = runTest {
        val alertId = "testAlert"
        manageAlertsSubCategoriesViewModel.navigateToAlertSelectionScreen(alertId, isAlertTypeAccount = true)
        verify(exactly = 1) {
            featureRouter.navigateTo(
                ManageAlertsNavigationItems.SelectAccount(
                    categoryId = "testCategory",
                    alertId = alertId,
                ),
            )
        }
    }

    @Test
    fun `fetchResources sets content on success`() = runTest {
        val expectedContent = mockManageAlertsContent()
        coEvery { repository.fetchResources() } returns flowOf(
            StateResult.success(ManageAlertsResourceState(manageAlertsContent = expectedContent))
        )

        manageAlertsSubCategoriesViewModel.fetchResources()

        val state = manageAlertsSubCategoriesViewModel.manageAlertsSubCategoriesResourceState.value
        assertEquals(expectedContent, state.content)
        assertNull(state.error)
    }

    @Test
    fun `fetchResources sets error on failure`() = runTest {
        val exception = ProblemsException("Network failure")
        coEvery { repository.fetchResources() } returns flowOf(
            StateResult.failure(exception)
        )

        manageAlertsSubCategoriesViewModel.fetchResources()

        val state = manageAlertsSubCategoriesViewModel.manageAlertsSubCategoriesResourceState.value
        assertNull(state.content)
        assertEquals(exception, state.error)
    }

    @Test
    fun `attachViewModel triggers loadCategoryPreferences`() = runTest {
        coEvery { repository.fetchResources() } returns flowOf(StateResult.success(mock()))
        coEvery { repository.fetchCategoryAlertPreferences(any()) } returns flowOf(StateResult.success(mock()))
        every { analyticsHelper.trackAlertsSubCategoryDetailsState(any()) } just Runs

        manageAlertsSubCategoriesViewModel.attachViewModel()

        coVerify { repository.fetchCategoryAlertPreferences(categoryId = "testCategory") }
    }

    @Test
    fun `attachViewModel triggers analyticsHelper with correct category`() = runTest {
        coEvery { repository.fetchResources() } returns flowOf(StateResult.success(mock()))
        coEvery { repository.fetchCategoryAlertPreferences(any()) } returns flowOf(StateResult.success(mock()))
        every { analyticsHelper.trackAlertsSubCategoryDetailsState(any()) } just Runs

        manageAlertsSubCategoriesViewModel.attachViewModel()

        verify {
            analyticsHelper.trackAlertsSubCategoryDetailsState(category = "testCategory")
        }
    }

    @Test
    fun `checkAlertPreferenceUpdateSuccessMessageStatus updates messageEvent`() = runTest {
        val event = EventData.MessageEvent("Success!")
        eventQueue.sendEvent(ALERT_PREFERENCE_UPDATE_SUCCESS_MESSAGE, event)

        manageAlertsSubCategoriesViewModel.checkAlertPreferenceUpdateSuccessMessageStatus()

        advanceUntilIdle()

        val state = manageAlertsSubCategoriesViewModel.manageAlertsSubCategoriesUiState.value
        assertEquals(event, state.showAlertPreferenceUpdateSuccessMessage)
    }

    private fun mockManageAlertsContent(): ManageAlertsContent {
        return ManageAlertsContent(
            alerts = emptyList(),
            categories = emptyList(),
            subcategories = emptyList(),
        )
    }
    
    
    @Test
    fun `updateShouldShowInfoDialogState should update shouldShowInfoDialog`() {
        manageAlertsSubCategoriesViewModel.updateShouldShowInfoDialogState(true)

        val state = manageAlertsSubCategoriesViewModel.manageAlertsSubCategoriesUiState.value
        assertTrue(state.shouldShowInfoDialog)

        manageAlertsSubCategoriesViewModel.updateShouldShowInfoDialogState(false)
        val updatedState = manageAlertsSubCategoriesViewModel.manageAlertsSubCategoriesUiState.value
        assertFalse(updatedState.shouldShowInfoDialog)
    }

    @Test
    fun `detachViewModel should clear showAlertPreferenceUpdateSuccessMessage`() = runTest {
        // First, simulate a message arriving
        val message = EventData.MessageEvent("Saved!")
        eventQueue.sendEvent(ALERT_PREFERENCE_UPDATE_SUCCESS_MESSAGE, message)
        manageAlertsSubCategoriesViewModel.checkAlertPreferenceUpdateSuccessMessageStatus()
        advanceUntilIdle()

        // Confirm message was set
        assertEquals(
            message,
            manageAlertsSubCategoriesViewModel.manageAlertsSubCategoriesUiState.value.showAlertPreferenceUpdateSuccessMessage
        )

        // Now detach view model and confirm state was reset
        manageAlertsSubCategoriesViewModel.detachViewModel()

        val state = manageAlertsSubCategoriesViewModel.manageAlertsSubCategoriesUiState.value
        assertNull(state.showAlertPreferenceUpdateSuccessMessage)
    }

    
    
}
