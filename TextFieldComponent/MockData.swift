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
        fun `test fetchResources success`() = runTest {
            val expectedContent = getContentFile()
            coEvery { repository.fetchResources() } returns flow {
                emit(NetworkResultState.Success(id = "id", data = expectedContent))
            }

            manageAlertsSubCategoriesViewModel.fetchResources()

            val actual = manageAlertsSubCategoriesViewModel.manageAlertsSubCategoriesResourceUiState.value.content
            assertEquals(expectedContent, actual)
        }

        @Test
        fun `test fetchResources failure`() = runTest {
            coEvery { repository.fetchResources() } returns flow {
                emit(NetworkResultState.Failure(id = "id", exception = Exception("error")))
            }

            manageAlertsSubCategoriesViewModel.fetchResources()

            val actual = manageAlertsSubCategoriesViewModel.manageAlertsSubCategoriesResourceUiState.value.content
            assertNull(actual)
        }

        @Test
        fun `updateShouldShowInfoDialogState should update shouldShowInfoDialog`() {
            manageAlertsSubCategoriesViewModel.updateShouldShowInfoDialogState(true)
            val stateTrue = manageAlertsSubCategoriesViewModel.manageAlertsSubCategoriesUiState.value
            assertTrue(stateTrue.shouldShowInfoDialog)

            manageAlertsSubCategoriesViewModel.updateShouldShowInfoDialogState(false)
            val stateFalse = manageAlertsSubCategoriesViewModel.manageAlertsSubCategoriesUiState.value
            assertFalse(stateFalse.shouldShowInfoDialog)
        }

        @Test
        fun `detachViewModel should clear showAlertPreferenceUpdateSuccessMessage`() = runTest {
            // Simulate incoming event
            val message = EventData.MessageEvent("Saved!")
            eventQueue.sendEvent(ALERT_PREFERENCE_UPDATE_SUCCESS_MESSAGE, message)

            manageAlertsSubCategoriesViewModel.checkAlertPreferenceUpdateSuccessMessageStatus()
            advanceUntilIdle()

            val beforeDetach = manageAlertsSubCategoriesViewModel.manageAlertsSubCategoriesUiState.value
            assertEquals(message, beforeDetach.showAlertPreferenceUpdateSuccessMessage)

            // Detach
            manageAlertsSubCategoriesViewModel.detachViewModel()

            val afterDetach = manageAlertsSubCategoriesViewModel.manageAlertsSubCategoriesUiState.value
            assertNull(afterDetach.showAlertPreferenceUpdateSuccessMessage)
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
