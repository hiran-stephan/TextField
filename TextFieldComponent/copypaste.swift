/**
 * Formats an amount string based on editing state.
 *
 * @param text The raw input string.
 * @param isEditing If true, apply validation filter (live editing mode).
 *                  If false, apply final formatting (e.g., append .00).
 * @return Formatted string, or an empty string if input is blank.
 */
fun ManageAlertsAlertSettingsViewModel.formatAmountField(
    text: String,
    isEditing: Boolean
): String = text.takeIf { it.isNotBlank() }?.let {
    if (isEditing) {
        it.validatedAmountFieldInput()
    } else {
        it.formattedAmountFieldInput()
    }
} ?: ""
