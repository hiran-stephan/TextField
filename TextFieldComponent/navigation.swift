fun AccountPreferencesDetailsViewModel.isNicknameValid(
    nickname: String,
): String {
    val charLimit: Int = 20
    val pattern = RegExPatterns.REGEX_ALPHANUMERIC_WITH_SPECIAL_CHARS

    // Step 1: Trim and filter in one go
    val validNickname = nickname.take(charLimit).filter { pattern.matches(it.toString()) }

    // Step 2: Return the valid nickname or empty string if it becomes invalid
    return validNickname
}
