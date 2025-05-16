package com.cibc.changeuserid.presenters

import com.cibc.changeuserid.ui.screens.changeuserid.presenters.ChangeUserIdField
import com.cibc.changeuserid.ui.screens.changeuserid.presenters.ChangeUserIdFieldErrorPresenter
import com.cibc.services.messagecatalogue.MessageCatalogueImpl
import com.cibc.services.remoteresource.data.models.LocalizedText
import com.cibc.services.utilities.tools.errors.ProblemData
import com.cibc.services.utilities.Locale
import kotlin.test.BeforeTest
import kotlin.test.Test
import kotlin.test.assertEquals

class ChangeUserIdFieldErrorPresenterTest {

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

    private lateinit var catalogue: MessageCatalogueImpl

    @BeforeTest
    fun setup() {
        catalogue = messageCatalogueData()
    }

    @Test
    fun `test 0255 current user id prompt`() {
        val problems = listOf(ProblemData(field = "oldUsername", code = "0255"))
        val presenter = ChangeUserIdFieldErrorPresenter(catalogue, problems)

        val error = presenter.getError(ChangeUserIdField.FIELD_CURRENT_USERID)
        assertEquals("Enter your current user ID.", error?.errorMessage)
    }

    @Test
    fun `test 0256 current user id too short`() {
        val problems = listOf(ProblemData(field = "oldUsername", code = "0256"))
        val presenter = ChangeUserIdFieldErrorPresenter(catalogue, problems)

        val error = presenter.getError(ChangeUserIdField.FIELD_CURRENT_USERID)
        assertEquals("The current user ID you entered is too short. Please try again.", error?.errorMessage)
    }

    @Test
    fun `test 0257 retype user id mismatch`() {
        val problems = listOf(ProblemData(field = "reenterUsername", code = "0257"))
        val presenter = ChangeUserIdFieldErrorPresenter(catalogue, problems)

        val error = presenter.getError(ChangeUserIdField.FIELD_RETYPE_USERID)
        assertEquals("The new user IDs you entered don't match. Please try again.", error?.errorMessage)
    }

    @Test
    fun `test 0258 new user id blank`() {
        val problems = listOf(ProblemData(field = "newUsername", code = "0258"))
        val presenter = ChangeUserIdFieldErrorPresenter(catalogue, problems)

        val error = presenter.getError(ChangeUserIdField.FIELD_NEW_USERID)
        assertEquals("Enter your new user ID.", error?.errorMessage)
    }

    @Test
    fun `test 0259 new user id same as current`() {
        val problems = listOf(ProblemData(field = "newUsername", code = "0259"))
        val presenter = ChangeUserIdFieldErrorPresenter(catalogue, problems)

        val error = presenter.getError(ChangeUserIdField.FIELD_NEW_USERID)
        assertEquals(
            "Your new user ID is the same as your current user ID. Please choose a different one.",
            error?.errorMessage
        )
    }
}
