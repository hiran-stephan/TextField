class ChangeUserIdFieldErrorPresenterTest {

    private fun problemsData(): List<ProblemData> = listOf(
        ProblemData(field = "oldUsername", code = "0255"),
        ProblemData(field = "newUsername", code = "0258"),
        ProblemData(field = "reenterUsername", code = "0257"),
        ProblemData(field = "oldUsername", code = "0256"),
        ProblemData(field = "newUsername", code = "0259")
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
        presenter = ChangeUserIdFieldErrorPresenter(messageCatalogue, problemsData())
    }

    @Test
    fun `test 0255 current user id error`() {
        val error = presenter.getError(ChangeUserIdField.FIELD_CURRENT_USERID)
        assertEquals("Enter your current user ID.", error?.errorMessage)
    }

    @Test
    fun `test 0256 current user id too short error`() {
        val error = presenter.getError(ChangeUserIdField.FIELD_CURRENT_USERID)
        assertEquals("The current user ID you entered is too short. Please try again.", error?.errorMessage)
    }

    @Test
    fun `test 0257 retype user id mismatch error`() {
        val error = presenter.getError(ChangeUserIdField.FIELD_RETYPE_USERID)
        assertEquals("The new user IDs you entered don't match. Please try again.", error?.errorMessage)
    }

    @Test
    fun `test 0258 new user id blank error`() {
        val error = presenter.getError(ChangeUserIdField.FIELD_NEW_USERID)
        assertEquals("Enter your new user ID.", error?.errorMessage)
    }

    @Test
    fun `test 0259 new user id same as current error`() {
        val error = presenter.getError(ChangeUserIdField.FIELD_NEW_USERID)
        assertEquals(
            "Your new user ID is the same as your current user ID. Please choose a different one.",
            error?.errorMessage
        )
    }
}
