package com.cibc.managealerts.ui.screens.subcategories.presenters

import kotlin.test.*
import java.util.Locale
import com.cibc.managealerts.testutils.ManageAlertsTestUtils
import com.cibc.managealerts.constants.*

class ManageAlertSubCategoryHeadingPresenterTest {

    private lateinit var presenter: ManageAlertSubCategoryHeadingPresenter
    private val locale = Locale("en")
    private val mockContentFile = ManageAlertsTestUtils.getContentFile()

    // Use values that match mock content
    private val categoryId = "servicing"
    private val subCategoryId = "security"

    @BeforeTest
    fun setup() {
        presenter = ManageAlertSubCategoryHeadingPresenter(
            contentFile = mockContentFile,
            locale = locale,
            categoryId = categoryId,
            subCategoryId = subCategoryId
        )
    }

    @Test
    fun `alertSectionHeading returns correct localized heading`() {
        val key = "${categoryId}_${subCategoryId}_heading".lowercase()
        val expected = mockContentFile.findContentValue(key, locale.language)
        assertEquals(expected, presenter.alertSectionHeading)
    }

    @Test
    fun `infoDialogBodyText returns correct localized text`() {
        val key = "${categoryId}_${subCategoryId}_info_dialog_text".lowercase()
        val expected = mockContentFile.findContentValue(key, locale.language)
        assertEquals(expected, presenter.infoDialogBodyText)
    }

    @Test
    fun `showInfoIcon is true when dialog body text is present`() {
        val key = "${categoryId}_${subCategoryId}_info_dialog_text".lowercase()
        val presentInContent = mockContentFile.content2?.containsKey(key) ?: false
        assertEquals(presentInContent, presenter.showInfoIcon)
    }

    @Test
    fun `infoDialogAccessibilityText returns correct localized text for accessibility`() {
        val key = "${categoryId}_${subCategoryId}_info_accessibility_text".lowercase()
        val expected = mockContentFile.findContentValue(key, locale.language, forAccessibility = true)
        assertEquals(expected, presenter.infoDialogAccessibilityText)
    }

    @Test
    fun `infoDialogOkButtonTitle returns correct localized text`() {
        val expected = mockContentFile.findContentValue(MANAGE_ALERTS_OK_BUTTON_TITLE, locale.language)
        assertEquals(expected, presenter.infoDialogOkButtonTitle)
    }
}
