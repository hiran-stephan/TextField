package com.cibc.managealerts.ui.screens.selectaccount.presenters

import com.cibc.services.remoteresource.data.models.ContentFileAlertsConfig
import com.cibc.services.remoteresource.data.models.LocalizedText
import com.cibc.services.remoteresource.data.models.MastheadConfig
import com.cibc.services.utilities.Locale
import kotlin.test.BeforeTest
import kotlin.test.Test
import kotlin.test.assertEquals

class ManageAlertSelectAccountMastheadPresenterTest {

    private val contentFile = ContentFileAlertsConfig(
        content = mapOf(),
        masthead = listOf(
            mapOf(
                KEY_SELECT_AN_ACCOUNT_MASTHEAD to MastheadConfig(
                    title = LocalizedText(en = "Select an account")
                )
            )
        ),
        categories = listOf()
    )

    private val locale = Locale(appRegion = "US")

    private lateinit var presenter: ManageAlertSelectAccountMastheadPresenter

    @BeforeTest
    fun setup() {
        presenter = ManageAlertSelectAccountMastheadPresenter(
            contentFile = contentFile,
            locale = locale
        )
    }

    @Test
    fun `getSelectAccountMastheadTitle returns correct title`() {
        val expected = "Select an account"
        val actual = presenter.mastheadTitle
        assertEquals(expected, actual)
    }

    companion object {
        private const val KEY_SELECT_AN_ACCOUNT_MASTHEAD = "default_masthead"
    }
}
