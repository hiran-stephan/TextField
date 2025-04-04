fun LoginViewModel.onDisplayRecoveredUserId(friendlyId: String?) {
    val cleanedId = friendlyId?.trim()

    // Return early if input is null or blank
    if (cleanedId.isNullOrBlank()) return

    updateLoginActionIfNeeded()
    updateLoginStateIfNeeded(cleanedId)
}

private fun updateLoginActionIfNeeded() {
    val currentState = _loginAction.value
    val needsUpdate = !currentState.showUserListTrailingIcon || currentState.isSavedUserIdFormAvailable

    if (needsUpdate) {
        _loginAction.update {
            it.copy(
                showUserListTrailingIcon = true,
                isSavedUserIdFormAvailable = false
            )
        }
    }
}

private fun updateLoginStateIfNeeded(friendlyId: String) {
    _loginState.update { previousState ->
        if (previousState.friendlyId == friendlyId) {
            return@update previousState // No change needed
        }
        previousState.copy(friendlyId = friendlyId)
    }
}
