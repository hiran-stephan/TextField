package com.cibc.changeuserid.presenters

import com.cibc.changeuserid.ui.screens.changeuserid.presenters.ChangeUserIdValidationPresenter
import com.cibc.services.utilities.forms.validation.ValidationStatus
import com.cibc.testcontent.getChangeUserIdContent
import kotlin.test.*

class ChangeUserIdValidationPresenterTest {

    private val contentFileMock = getChangeUserIdContent().changeUserIdContent
    private val locale = Locale(appRegion = "US")

    private fun createPresenter(userId: String): ChangeUserIdValidationPresenter {
        return ChangeUserIdValidationPresenter(
            userId = userId,
            contentFile = contentFileMock,
            locale = locale
        )
    }

    @Test
    fun `should return UNKNOWN status for blank userId`() {
        val presenter = createPresenter("")

        presenter.userIdValidationResults.forEach {
            assertEquals(ValidationStatus.UNKNOWN, it.status)
        }
    }

    @Test
    fun `should return INVALID status for short userId`() {
        val presenter = createPresenter("a1")

        val invalidResults = presenter.userIdValidationResults.filter {
            it.status == ValidationStatus.INVALID
        }

        assertTrue(invalidResults.isNotEmpty())
    }

    @Test
    fun `should return INVALID status for userId with restricted characters`() {
        val presenter = createPresenter("abc@123")

        val restrictedCharRule = presenter.userIdValidationResults.find {
            it.ruleId == VALIDATE_USERNAME_ALLOWED_CHAR
        }

        assertEquals(ValidationStatus.INVALID, restrictedCharRule?.status)
    }

    @Test
    fun `should return INVALID for missing two letters and two numbers`() {
        val presenter = createPresenter("abcdefg")

        val rule = presenter.userIdValidationResults.find {
            it.ruleId == VALIDATE_USERNAME_TWO_CHAR_AND_TWO_NUMBERS
        }

        assertEquals(ValidationStatus.INVALID, rule?.status)
    }

    @Test
    fun `should return VALID for correct userId`() {
        val presenter = createPresenter("ab1234cd")

        presenter.userIdValidationResults.forEach {
            assertEquals(ValidationStatus.VALID, it.status)
        }
    }
}
