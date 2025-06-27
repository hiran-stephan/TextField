package com.cibc.managealerts.ui.screens.subcategories

import app.cash.turbine.test
import com.cibc.managealerts.domain.model.ManageAlertsConfigSubscription
import com.cibc.managealerts.domain.model.NetworkResultState
import com.cibc.managealerts.navigation.ManageAlertsFeatureRouter
import com.cibc.managealerts.navigation.ManageAlertsNavigationItems
import com.cibc.managealerts.repository.ManageAlertsRepository
import com.cibc.managealerts.ui.screens.categories.ManageAlertsSubCategoriesViewModel
import com.cibc.managealerts.utils.ManageAlertsTestUtils.getContentFile
import com.cibc.mobile.framework.core.appstate.AppRegion
import com.cibc.mobile.framework.core.localization.MessageCatalogue
import com.cibc.mobile.framework.core.state.EventQueueImpl
import com.cibc.mobile.framework.core.state.StateUpdate
import com.cibc.mobile.framework.core.test.*
import com.cibc.mobile.framework.core.threading.Dispatchers
import com.cibc.mobile.framework.core.threading.UnconfinedTestDispatcher
import com.cibc.mobile.framework.core.util.locale
import io.mockk.*
import kotlinx.coroutines.Dispatchers.setMain
import kotlinx.coroutines.Dispatchers.resetMain
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.test.runTest
import org.junit.After
import org.junit.Before
import org.junit.Test
import kotlin.test.assertEquals
import kotlin.test.assertNull

@OptIn(ExperimentalCoroutinesApi::class)
class ManageAlertsSubCategoriesViewModelTest {
    private val repository = mockk<ManageAlertsRepository>()
    private lateinit var featureRouter: ManageAlertsFeatureRouter
    private lateinit var manageAlertsSubCategoriesViewModel: ManageAlertsSubCategoriesViewModel
    private val appRouter = mockk<ApplicationRouters>(MockMode.autoUnit)
    private val dispatcher = UnconfinedTestDispatcher()
    private val stepUpHandler: StepUpHandler = mockk()
    private val messageCatalogue = mockk<MessageCatalogue>()
    private val locale: Locale = Locale( appRegion = "US")
    private val manageAlertsAnalyticsHelper = mockk<ManageAlertsAnalyticsHelper>()
    private val eventQueue = EventQueueImpl()

    @Before
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
        manageAlertsSubCategoriesViewModel =
            ManageAlertsSubCategoriesViewModel(
                repository = repository,
                featureRouter = featureRouter,
                messageCatalogue = messageCatalogue,
                analyticsHelper = manageAlertsAnalyticsHelper,
                locale = locale,
                subCategoryNavigationItem = ManageAlertsNavigationItems.SubCategory(categoryId = "testCategory"),
                eventQueue = eventQueue,
            )
    }

    @After
    fun tearDown() {
        stopKoin()
        Dispatchers.resetMain()
    }

    @Test
    fun `loadCategoryPreferences success updates state`() = runTest {
        val categoryId = "testCategory"
        val expectedData = listOf(ManageAlertsConfigSubscription("1"))

        everySuspend {
            repository.fetchCategoryAlertPreferences(categoryId)
        } returns flow {
            emit(NetworkResultState.Success(id = "id", data = expectedData))
        }

        manageAlertsSubCategoriesViewModel.loadCategoryPreferences(categoryId)

        manageAlertsSubCategoriesViewModel.manageAlertsSubCategoriesUiState.test {
            val state = awaitItem()
            assertEquals(expectedData, state.categoryPreferenceData)
        }
    }

    @Test
    fun `loadCategoryPreferences failure updates error`() = runTest {
        val categoryId = "testCategory"
        val expectedException = Exception("0001")

        everySuspend {
            repository.fetchCategoryAlertPreferences(categoryId)
        } returns flow {
            emit(NetworkResultState.Failure(id = "id", exception = expectedException))
        }

        manageAlertsSubCategoriesViewModel.loadCategoryPreferences(categoryId)

        manageAlertsSubCategoriesViewModel.manageAlertsSubCategoriesUiState.test {
            val state = awaitItem()
            assertEquals(expectedException, state.error)
        }
    }
    
    @Test
    fun `updateShouldShowInfoDialogState updates UI state`() = runTest {
        // When
        manageAlertsSubCategoriesViewModel.updateShouldShowInfoDialogState(true)

        // Then
        val actual = manageAlertsSubCategoriesViewModel.manageAlertsSubCategoriesUiState.value.shouldShowInfoDialog
        assertTrue(actual)
    }
    
    @Test
    fun `checkAlertPreferenceUpdateSuccessMessageStatus handles success message event`() = runTest {
        // Given
        val expectedMessage = "Update success"
        val eventData = EventData.MessageEvent(
            message = expectedMessage,
            eventId = ALERT_PREFERENCE_UPDATE_SUCCESS_MESSAGE
        )

        // Inject the event into the queue before calling the method
        eventQueue.addEvent(
            purposeId = ALERT_PREFERENCE_UPDATE_SUCCESS_MESSAGE,
            eventData = eventData
        )

        // When
        manageAlertsSubCategoriesViewModel.checkAlertPreferenceUpdateSuccessMessageStatus()

        // Let coroutines collect the event
        advanceUntilIdle()

        // Then
        val actual = manageAlertsSubCategoriesViewModel.manageAlertsSubCategoriesUiState.value
        assertEquals(expectedMessage, actual.showAlertPreferenceUpdateSuccessMessage?.message)
    }

    @Test
    fun `detachViewModel clears alert success message`() = runTest {
        // First simulate success message
        val event = EventData.MessageEvent("Success", ALERT_PREFERENCE_UPDATE_SUCCESS_MESSAGE)
        manageAlertsSubCategoriesViewModel.checkAlertPreferenceUpdateSuccessMessageStatus()
        eventQueue.addEvent(ALERT_PREFERENCE_UPDATE_SUCCESS_MESSAGE, event)

        advanceUntilIdle()

        // Now call detach
        manageAlertsSubCategoriesViewModel.detachViewModel()

        // Then
        val actual = manageAlertsSubCategoriesViewModel.manageAlertsSubCategoriesUiState.value
        assertNull(actual.showAlertPreferenceUpdateSuccessMessage)
    }

}
