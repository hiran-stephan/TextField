// Define an Enum for ActionStatus
enum class ActionStatus(val value: String) {
    SUCCESSFUL("successful"),
    UNSUCCESSFUL("unsuccessful");

    companion object {
        fun fromBoolean(status: Boolean): String {
            return if (status) SUCCESSFUL.value else UNSUCCESSFUL.value
        }
    }
}

// ViewModel Method
override fun trackAccountHideConfirmAction(status: Boolean) {
    val item = ActionStatus.fromBoolean(status) // Use the helper from Enum
    trackAction(
        properties.stateAccountPreferenceDetails(),
        properties.accountHideConfirmActionItem(item = item)
    )
}
