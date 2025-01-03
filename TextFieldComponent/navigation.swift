data class FormValidationResults(
    val nickname: ValidationResult
)

fun AccountPreferencesDetailsViewModel.validateForm(nickname: String): FormValidationResults {
    val nicknameFieldRules = listOf(
        ValidationRule.Required(),
        ValidationRule.MaxLength(20)
    )

    return FormValidationResults(
        nickname = nicknameFieldRules.validate(nickname)
    )
}

private val _uiState = MutableStateFlow(AccountPreferencesDetailsUiState(validationMessage = null))
val uiState = _uiState.asStateFlow()

fun validateNickname(nickname: String) {
    val validationResults = validateForm(nickname)
    val nicknameResult = validationResults.nickname

    if (!nicknameResult.isValid) {
        _uiState.value = _uiState.value.copy(validationMessage = nicknameResult.message)
    } else {
        _uiState.value = _uiState.value.copy(validationMessage = null)
    }
}

data class AccountPreferencesDetailsUiState(
    val validationMessage: String? = null
)
