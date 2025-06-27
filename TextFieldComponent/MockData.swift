package com.cibc.managealerts.ui.screens.managealerts

import kotlin.test.*
import java.util.Locale
import com.cibc.managealerts.ui.screens.subcategories.presenters.ManageAlertsSubCategoryInfoMessagePresenter
import com.cibc.managealerts.testutils.ManageAlertsTestUtils // adjust to your actual test utils import
import com.cibc.managealerts.constants.*

class ManageAlertsSubCategoryInfoMessagePresenterTest {

    private lateinit var presenter: ManageAlertsSubCategoryInfoMessagePresenter
    private val locale = Locale("en")
    private val mockContentFile = ManageAlertsTestUtils.getContentFile()

    @BeforeTest
    fun setup() {
        presenter = ManageAlertsSubCategoryInfoMessagePresenter(mockContentFile, locale)
    }

    @Test
    fun `infoMessageText returns correct localized value`() {
        val expected = mockContentFile.findContentValue(MANAGE_ALERTS_QUICK_INFO_MESSAGE_TEXT, locale.language)
        assertEquals(expected, presenter.infoMessageText)
    }

    @Test
    fun `infoMessageLinkText returns correct localized value`() {
        val expected = mockContentFile.findContentValue(MANAGE_ALERTS_QUICK_INFO_MESSAGE_LINK_TEXT, locale.language)
        assertEquals(expected, presenter.infoMessageLinkText)
    }
}
