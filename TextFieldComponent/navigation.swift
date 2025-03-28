fun RecoverUserIdViewModel.filterPhoneNumber(number: String): String {
    val isIntl = recoverUserIdState.value.isInternationalPhoneNumber
    val characterLimit = if (isIntl)
        RecoverUserIdConstants.PHONE_NUMBER_INTERNATIONAL_CHARACTER_LIMIT
    else
        RecoverUserIdConstants.PHONE_NUMBER_NORTH_AMERICAN_CHARACTER_LIMIT

    val validPattern = "[0-9]".toRegex() // Only digits
    return number.filter { validPattern.matches(it.toString()) }
        .take(characterLimit)
}

fun RecoverUserIdViewModel.filterTaxId(number: String): String {
    val characterLimit = if (recoverUserIdState.value.isSSNorTIN)
        RecoverUserIdConstants.SSN_CHARACTER_LIMIT
    else
        RecoverUserIdConstants.SIN_CHARACTER_LIMIT

    val validPattern = "[0-9]".toRegex()
    return number.filter { validPattern.matches(it.toString()) }
        .take(characterLimit)
}

fun RecoverUserIdViewModel.filterAccountNumber(number: String): String {
    val characterLimit = when (recoverUserIdState.value.accountType) {
        "Deposit" -> RecoverUserIdConstants.ACCOUNT_NUMBER_CHARACTER_LIMIT
        "Loan" -> RecoverUserIdConstants.LOAN_NUMBER_CHARACTER_LIMIT
        "Card" -> RecoverUserIdConstants.CARD_NUMBER_CHARACTER_LIMIT
        else -> RecoverUserIdConstants.ACCOUNT_NUMBER_CHARACTER_LIMIT
    }

    val validPattern = "[0-9]".toRegex()
    return number.filter { validPattern.matches(it.toString()) }
        .take(characterLimit)
}
