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

