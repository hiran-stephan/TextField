package com.cibc.changeuserid.ui.screens.changeuserid.presenters

import com.cibc.services.messagecatalogue.MessageCatalogueImpl
import com.cibc.services.utilities.tools.errors.ProblemData
import kotlin.test.*

class ChangeUserIdFieldErrorPresenterTest {

    private fun problemsData(): List<ProblemData> = listOf(
        ProblemData(field = "oldUsername", code = "0255"),
        ProblemData(field = "newUsername", code = "0258"),
        ProblemData(field = "reenterUsername", code = "0257"),
    )

    private fun messageCatalogueData(): MessageCatalogueImpl {
        val catalogue = MessageCatalogueImpl(locale = Locale(appRegion = "US"))
        catalogue.messages = mapOf(
            "0255" to LocalizedText(en = "Enter your current user ID."),
            "0256" to LocalizedText(en = "The current user ID you entered is too short. Please try again."),
            "0257" to LocalizedText(en = "The new user IDs you entered don't match. Please try again."),
            "0258" to LocalizedText(en = "Enter your new user ID."),
            "0259" to LocalizedText(en = "Your new user ID is the same as your current user ID. Please choose a different one."),
        )
        return catalogue
    }

    private lateinit var presenter: ChangeUserIdFieldErrorPresenter

    @BeforeTest
    fun setup() {
        val messageCatalogue = messageCatalogueData()
        presenter = ChangeUserIdFieldErrorPresenter(messageCatalogue).apply {
            problems = problemsData()
        }
    }

    @Test
    fun `test current user id field error`() {
        val error = presenter.getError(ChangeUserIdField.FIELD_CURRENT_USERID)
        assertEquals("Enter your current user ID.", error?.message)
    }

    @Test
    fun `test new user id field error`() {
        val error = presenter.getError(ChangeUserIdField.FIELD_NEW_USERID)
        assertEquals("Enter your new user ID.", error?.message)
    }

    @Test
    fun `test confirm new user id field error`() {
        val error = presenter.getError(ChangeUserIdField.FIELD_RETYPE_USERID)
        assertEquals("The new user IDs you entered don't match. Please try again.", error?.message)
    }

    @Test
    fun `test no error when no matching code`() {
        val presenterWithNoError = ChangeUserIdFieldErrorPresenter(messageCatalogueData())
        val error = presenterWithNoError.getError(ChangeUserIdField.FIELD_CURRENT_USERID)
        assertNull(error)
    }
}
