/**
 * Formats an amount string based on editing state.
 *
 * @param text The raw input string.
 * @param isEditing If true, apply validation filter (live editing mode). If false, apply final formatting.
 * @return Formatted string for display.
 */
fun ManageAlertsAlertSettingsViewModel.formatAmountField(
    text: String,
    isEditing: Boolean
): String = if (isEditing) {
    text.validatedAmountFieldInput()
} else {
    text.formattedAmountFieldInput()
}
