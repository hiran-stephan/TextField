val message: String
    get() = if (reEnteredUsername.isNotEmpty()) {
        if (newUsername == reEnteredUsername) {
            displayContent(CHANGE_USERID_CONFIRM_USERID_FIELD_SUCCESS_MESSAGE)
        } else {
            displayContent(CHANGE_USERID_CONFIRM_USERID_FIELD_ERROR_MESSAGE)
        }
    } else {
        StringUtils.EMPTY
    }
