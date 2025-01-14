fun AccountPreferencesDetailsViewModel.isNicknameValid(
    nickname: String,
): String {
    val charLimit: Int = 20
    val validCharacterPattern = "[a-zA-Z0-9 &.,-]".toRegex()

    // Step 1: Filter out invalid characters
    val filteredNickname = nickname.filter { validCharacterPattern.matches(it.toString()) }

    // Step 2: Limit to the maximum allowed length, keeping leading and trailing spaces
    return filteredNickname.take(charLimit)
}
