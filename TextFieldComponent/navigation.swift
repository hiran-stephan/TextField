enum class ValidationStatus {
    INITIAL, VALID, INVALID
}

data class ValidationResult(
    val ruleId: Int,
    val status: ValidationStatus,
    val message: String
)

data class ChangeUserIdUiState(
    val content: ContentFile? = null,
    val oldUsername: String = StringUtils.EMPTY,
    val newUsername: String = StringUtils.EMPTY,
    val reEnteredUsername: String = StringUtils.EMPTY,
    val data: Any? = null,
    val isLoading: Boolean = false,
    val error: Throwable? = null,
    val validationResults: List<ValidationResult> = emptyList()
) : UiState<ChangeUserIdUiState> {
    val hasData: Boolean = true
    val hasError: Boolean = error != null

    override fun error(id: String, error: Throwable?) = copy(isLoading = false, error = error)
    override fun loading(id: String, loading: Boolean) = copy(isLoading = loading)
}



private val validationRules = listOf<ValidationRule<CharSequence>>(
    MinMaxLength(8, 32, "Between 8 and 32 characters"),
    AtLeastTwoCharactersAndTwoNumbersRule("At least 2 letters and 2 numbers"),
    NoAllowedUsernameCharactersRule("No invalid characters (',\\,>,<)")
)

// Initialize UI state with INITIAL validation status
private val _changeUserIdUiState = MutableStateFlow(
    ChangeUserIdUiState(
        validationResults = validationRules.map {
            ValidationResult(
                ruleId = it.id,
                status = ValidationStatus.INITIAL,
                message = it.message
            )
        }
    )
)
val changeUserIdUiState = _changeUserIdUiState.asStateFlow()


fun validateNewUserId(input: String) {
    val results = validationRules.map { rule ->
        val status = when (rule.isValid(input)) {
            true -> ValidationStatus.VALID
            false, null -> ValidationStatus.INVALID
        }

        ValidationResult(
            ruleId = rule.id,
            status = status,
            message = rule.message
        )
    }

    _changeUserIdUiState.value = _changeUserIdUiState.value.copy(
        newUsername = input,
        validationResults = results
    )
}

class ChangeUserIdValidationPresenter(
    private val validationResults: List<ValidationResult> = emptyList(),
    private val validationRules: List<ValidationRule<CharSequence>> = emptyList(),
    private val contentFile: ContentFile? = null,
    private val locale: Locale
) {
    val presentedResults: List<ValidationResult>
        get() = if (validationResults.isNotEmpty()) {
            validationResults
        } else {
            validationRules.map {
                ValidationResult(
                    ruleId = it.id,
                    status = ValidationStatus.INITIAL,
                    message = it.message // Or use displayContent(it.id)
                )
            }
        }

    private fun displayContent(
        key: String,
        forAccessibility: Boolean = false
    ): String = contentFile.findContentValue(key, locale.lang, forAccessibility)
}

object ChangeUserIdConstants {
    const val CHANGEUSERID_ROUTER_SCOPE = "changeuserid-router"

    // Validation limits
    const val USERID_MIN_LENGTH = 8
    const val USERID_MAX_LENGTH = 32

    // Validation messages
    const val VALIDATION_MESSAGE_LENGTH = "Between $USERID_MIN_LENGTH and $USERID_MAX_LENGTH characters"
    const val VALIDATION_MESSAGE_CHAR_AND_NUM = "At least 2 letters and 2 numbers"
    const val VALIDATION_MESSAGE_INVALID_CHARS = "No invalid characters (',\\,>,<)"
}

val validationRules = listOf<ValidationRule<CharSequence>>(
    ValidationRule.MinMaxLength(
        minimum = ChangeUserIdConstants.USERID_MIN_LENGTH,
        maximum = ChangeUserIdConstants.USERID_MAX_LENGTH,
        message = ChangeUserIdConstants.VALIDATION_MESSAGE_LENGTH
    ),
    ValidationRule.AtLeastTwoCharactersAndTwoNumbersRule(
        message = ChangeUserIdConstants.VALIDATION_MESSAGE_CHAR_AND_NUM
    ),
    ValidationRule.NoAllowedUsernameCharactersRule(
        message = ChangeUserIdConstants.VALIDATION_MESSAGE_INVALID_CHARS
    )
)
