import com.cibc.changeuserid.ContentConstants
import com.cibc.changeuserid.ui.screens.changeuserid.presenters.ChangeUserIdConfirmUserIdValidationPresenter
import com.cibc.services.remoteresource.data.models.BaseContentFile
import com.cibc.services.utilities.Locale
import kotlin.test.BeforeTest
import kotlin.test.Test
import kotlin.test.assertEquals

class ChangeUserIdConfirmUserIdValidationPresenterTest {

    private lateinit var presenter: ChangeUserIdConfirmUserIdValidationPresenter
    private val contentFileMock: BaseContentFile = getChangeUserIdContent().changeUserIdContent
    private val locale = Locale(appRegion = "US")

    @BeforeTest
    fun setup() {
        presenter = ChangeUserIdConfirmUserIdValidationPresenter(
            newUsername = "user123",
            reEnteredUsername = "user123",
            contentFile = contentFileMock,
            locale = locale
        )
    }

    @Test
    fun `message should return success when usernames match`() {
        val expected = contentFileMock.findContentValue(
            ContentConstants.CHANGE_USERID_CONFIRM_USERID_FIELD_SUCCESS_MESSAGE,
            locale.lang
        )
        assertEquals(expected, presenter.message)
        assertEquals(true, presenter.isUserIdMatching)
    }

    @Test
    fun `message should return error when usernames do not match`() {
        val presenterMismatch = ChangeUserIdConfirmUserIdValidationPresenter(
            newUsername = "user123",
            reEnteredUsername = "user456",
            contentFile = contentFileMock,
            locale = locale
        )

        val expected = contentFileMock.findContentValue(
            ContentConstants.CHANGE_USERID_CONFIRM_USERID_FIELD_ERROR_MESSAGE,
            locale.lang
        )
        assertEquals(expected, presenterMismatch.message)
        assertEquals(false, presenterMismatch.isUserIdMatching)
    }

    @Test
    fun `message should be empty when reEnteredUsername is empty`() {
        val presenterEmpty = ChangeUserIdConfirmUserIdValidationPresenter(
            newUsername = "user123",
            reEnteredUsername = "",
            contentFile = contentFileMock,
            locale = locale
        )

        assertEquals("", presenterEmpty.message)
        assertEquals(false, presenterEmpty.isUserIdMatching)
    }
}


val message: String?
    get() = when {
        reEnteredUsername.isEmpty() -> null
        newUsername == reEnteredUsername -> displayContent(CHANGE_USERID_CONFIRM_USERID_FIELD_SUCCESS_MESSAGE)
        else -> displayContent(CHANGE_USERID_CONFIRM_USERID_FIELD_ERROR_MESSAGE)
    }
