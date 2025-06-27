package com.cibc.managealerts.ui.screens.managealerts

import kotlin.test.*
import com.cibc.managealerts.data.datasources.ManageAlertsTestUtils
import com.cibc.managealerts.models.*
import com.cibc.managealerts.presenters.*
import com.cibc.managealerts.utils.toAlertSubscriptionData
import java.util.Locale

class ManageAlertsSubCategoryAlertPresenterTest {

    private val alertsApiData = ManageAlertsTestUtils.createAlertsData()
    private val locale = Locale("en")
    private lateinit var presenter: ManageAlertsSubCategoryAlertPresenter
    private lateinit var subscription: ManageAlertsConfigSubscription
    private val mockContentFile = ManageAlertsTestUtils.getContentFile()

    @BeforeTest
    fun setup() {
        val configData = ManageAlertsTestUtils.getServicesConfig()

        subscription = ManageAlertsConfigSubscription(
            name = configData.name,
            alwaysOn = configData.alwaysOn,
            purposeCode = configData.purposeCode,
            categoryId = configData.categoryId,
            subCategoryId = configData.subCategoryId,
            alertType = configData.alertType,
            subscriptions = alertsApiData.alertSubscriptions.map { it.toAlertSubscriptionData() }
        )

        presenter = ManageAlertsSubCategoryAlertPresenter(mockContentFile, locale, subscription)
    }

    @Test
    fun `alertTitle formats correctly`() {
        assertEquals("Contact information changed", presenter.alertTitle)
    }

    @Test
    fun `alertDescription formats delivery methods correctly`() {
        assertEquals("My messages, Email and Text", presenter.alertDescription)
    }

    @Test
    fun `alertActiveText returns OFF title when alert is disabled`() {
        subscription = subscription.copy(
            subscriptions = emptyList(),
            alwaysOn = false
        )
        presenter = createPresenter(subscription)
        assertEquals("Off", presenter.alertActiveText)
    }

    @Test
    fun `alert is enabled when alwaysOn is true`() {
        subscription = subscription.copy(alwaysOn = true)
        presenter = createPresenter(subscription)
        assertTrue(presenter.isAlertEnabled)
    }

    @Test
    fun `alert is disabled when no subscriptions exist`() {
        subscription = subscription.copy(
            subscriptions = emptyList(),
            alwaysOn = false
        )
        presenter = createPresenter(subscription)
        assertFalse(presenter.isAlertEnabled)
    }

    @Test
    fun `alertDescription formats Message Center only`() {
        val messageCenterOnly = alertsApiData.alertSubscriptions.first().copy(
            preferenceDetails = listOf(
                PreferenceDetail(id = "1", deliveryMethod = "MESSAGE_CENTER", selected = true)
            )
        )
        subscription = subscription.copy(subscriptions = listOf(messageCenterOnly))
        presenter = createPresenter(subscription)
        assertEquals("My messages", presenter.alertDescription)
    }

    @Test
    fun `alertDescription formats Email only`() {
        val emailOnly = alertsApiData.alertSubscriptions.first().copy(
            preferenceDetails = listOf(
                PreferenceDetail(id = "2", deliveryMethod = "EMAIL", selected = true)
            )
        )
        subscription = subscription.copy(subscriptions = listOf(emailOnly))
        presenter = createPresenter(subscription)
        assertEquals("Email", presenter.alertDescription)
    }

    @Test
    fun `alertDescription formats SMS only`() {
        val smsOnly = alertsApiData.alertSubscriptions.first().copy(
            preferenceDetails = listOf(
                PreferenceDetail(id = "3", deliveryMethod = "SMS", selected = true)
            )
        )
        subscription = subscription.copy(subscriptions = listOf(smsOnly))
        presenter = createPresenter(subscription)
        assertEquals("Text", presenter.alertDescription)
    }

    @Test
    fun `alertDescription returns null when display key is missing`() {
        val unknown = alertsApiData.alertSubscriptions.first().copy(
            preferenceDetails = listOf(
                PreferenceDetail(id = "4", deliveryMethod = "UNKNOWN", selected = true)
            )
        )
        subscription = subscription.copy(subscriptions = listOf(unknown))
        presenter = createPresenter(subscription)
        assertNull(presenter.alertDescription)
    }

    @Test
    fun `alertDescription formats multiple delivery methods with proper conjunction`() {
        // Already configured as: Message Center, Email, SMS
        assertEquals("My messages, Email and Text", presenter.alertDescription)
    }

    private fun createPresenter(sub: ManageAlertsConfigSubscription): ManageAlertsSubCategoryAlertPresenter {
        return ManageAlertsSubCategoryAlertPresenter(mockContentFile, locale, sub)
    }
}



assertEquals(mockContentFile.findContentValue(MANAGE_ALERTS_OFF_TITLE, locale.language), presenter.alertActiveText)


val configData = ManageAlertsTestUtils.getManageAlertsConfigData()["servicing"]?.first()


fun getPresenterFor(category: String): ManageAlertsSubCategoryAlertPresenter {
    val configData = ManageAlertsTestUtils.getManageAlertsConfigData()[category]?.first()
        ?: error("No config found for $category")

    val sub = ManageAlertsConfigSubscription(
        name = configData.name,
        alwaysOn = configData.alwaysOn,
        purposeCode = configData.purposeCode,
        categoryId = configData.categoryId,
        subCategoryId = configData.subCategoryId,
        alertType = configData.alertType,
        subscriptions = alertsApiData.alertSubscriptions.map { it.toAlertSubscriptionData() }
    )

    return ManageAlertsSubCategoryAlertPresenter(mockContentFile, locale, sub)
}

@Test
fun `alertTitle for servicing config`() {
    presenter = getPresenterFor("servicing")
    assertEquals("Contact information changed", presenter.alertTitle)
}

@Test
fun `alertTitle for Reminders config`() {
    presenter = getPresenterFor("Reminders")
    assertEquals("Starting balance above amount", presenter.alertTitle)
}
