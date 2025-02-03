object AccountPreferencesTestUtils {

    fun contentFileData(): ContentResources {
        val contentFile = ContentFile(
            mapOf(
                ACCOUNT_PREFERENCES to LocalizedText(
                    en = "Account Preferences",
                    accessibility_en = "Account Preferences"
                ),
                ACCOUNT_PREFERENCES_HIDDEN_STATUS_PILL_TEXT to LocalizedText(
                    en = "Hidden",
                    accessibility_en = "Account is hidden."
                ),
                ACCOUNT_PREFERENCES_GROUP_HEADING_DEPOSIT to LocalizedText(
                    en = "Deposit accounts",
                    accessibility_en = "Deposit accounts"
                ),
                ACCOUNT_PREFERENCES_GROUP_HEADING_LOAN to LocalizedText(
                    en = "Loan accounts",
                    accessibility_en = "Loan accounts"
                ),
                ACCOUNT_PREFERENCES_GROUP_HEADING_REVOLVING_CREDIT to LocalizedText(
                    en = "Revolving credit accounts",
                    accessibility_en = "Revolving credit accounts"
                ),
                PREFERENCE_SETTINGS_PRIMARY_HEADER_TITLE to LocalizedText(
                    en = "Preference settings",
                    accessibility_en = "Preference settings"
                ),
                ACCOUNT_DISPLAY_HEADER_TITLE to LocalizedText(
                    en = "Account display",
                    accessibility_en = "Account display"
                ),
                ACCOUNT_NICKNAME_HEADER_TITLE to LocalizedText(
                    en = "Account nickname",
                    accessibility_en = "Account nickname"
                ),
                ACCOUNT_DISPLAY_INFO_ICON_ACCESSIBILITY_TEXT to LocalizedText(
                    en = "",
                    accessibility_en = "Learn more about how your accounts are displayed. Opens in a dialog."
                ),
                ACCOUNT_NICKNAME_INFO_ICON_ACCESSIBILITY_TEXT to LocalizedText(
                    en = "",
                    accessibility_en = "Learn more about how your accounts are displayed. Opens in a dialog."
                ),
                ACCOUNT_DISPLAY_INFO_ICON_DIALOG_BODY_TEXT to LocalizedText(
                    en = "Hiding your account will affect your banking experience.\n\nHidden accounts are not able to be used for bill payments.",
                    accessibility_en = "Hiding your account will affect your banking experience.\n\nHidden accounts are not able to be used for bill payments."
                ),
                ACCOUNT_NICKNAME_INFO_ICON_DIALOG_BODY_TEXT to LocalizedText(
                    en = "Nicknames can be added to any of your online banking accounts and are only visible to you. They can be up to 20 characters long.",
                    accessibility_en = "Nicknames can be added to any of your online banking accounts and are only visible to you. They can be up to 20 characters long."
                ),
                INFO_ICON_DIALOG_CLOSE_BUTTON_TEXT to LocalizedText(
                    en = "Close",
                    accessibility_en = "Close"
                ),
                ACCOUNT_DISPLAY_HIDE_THIS_ACCOUNT_TEXT to LocalizedText(
                    en = "Hide this account",
                    accessibility_en = "Hide this account"
                ),
                ACCOUNT_NICKNAME_TEXT to LocalizedText(
                    en = "Account nickname",
                    accessibility_en = "Account nickname"
                ),
                ACCOUNT_NICKNAME_ADD_NICKNAME_BUTTON_TEXT to LocalizedText(
                    en = "Add a nickname",
                    accessibility_en = "Add a nickname"
                ),
                ACCOUNT_NICKNAME_NOT_CURRENTLY_AVAILABLE_TEXT to LocalizedText(
                    en = "Not currently available",
                    accessibility_en = "Not currently available"
                ),
                ACCOUNT_NICKNAME_FIELD_LABEL_TEXT to LocalizedText(
                    en = "Account nickname",
                    accessibility_en = "Account nickname"
                ),
                ACCOUNT_NICKNAME_DELETE_BUTTON_ACCESSIBILITY_TEXT to LocalizedText(
                    en = "",
                    accessibility_en = "Delete nickname."
                ),
                ACCOUNT_NICKNAME_BODY_TEXT to LocalizedText(
                    en = "Nicknames can be up to 20 characters long",
                    accessibility_en = "Nicknames can be up to 20 characters long"
                ),
                ACCOUNT_NICKNAME_CANCEL_BUTTON_TEXT to LocalizedText(
                    en = "Cancel",
                    accessibility_en = "Cancel"
                ),
                ACCOUNT_NICKNAME_SAVE_BUTTON_TEXT to LocalizedText(
                    en = "Save",
                    accessibility_en = "Save"
                ),
                ACCOUNT_DISPLAY_HIDE_DIALOG_TITLE_TEXT to LocalizedText(
                    en = "Before you hide your account",
                    accessibility_en = "Before you hide your account"
                ),
                ACCOUNT_DISPLAY_HIDE_DIALOG_BODY_TEXT to LocalizedText(
                    en = "Hiding your account will affect your banking experience.\n\nHidden accounts are not able to be used for bill payments.",
                    accessibility_en = "Hiding your account will affect your banking experience.\n\nHidden accounts are not able to be used for bill payments."
                ),
                ACCOUNT_DISPLAY_HIDE_DIALOG_BACK_BUTTON_TEXT to LocalizedText(
                    en = "Back",
                    accessibility_en = "Back"
                ),
                ACCOUNT_DISPLAY_SHOW_DIALOG_TITLE_TEXT to LocalizedText(
                    en = "Before you show your account",
                    accessibility_en = "Before you show your account"
                ),
                ACCOUNT_DISPLAY_SHOW_DIALOG_BODY_TEXT to LocalizedText(
                    en = "Showing your account will affect your banking experience.\n\nShowing your account may make it eligible for use in payments.",
                    accessibility_en = "Showing your account will affect your banking experience.\n\nShowing your account may make it eligible for use in payments."
                ),
                ACCOUNT_DISPLAY_SHOW_DIALOG_BACK_BUTTON_TEXT to LocalizedText(
                    en = "Back",
                    accessibility_en = "Back"
                ),
                ACCOUNT_DISPLAY_SHOW_DIALOG_CONTINUE_BUTTON_TEXT to LocalizedText(
                    en = "Continue",
                    accessibility_en = "Continue"
                ),
                ACCOUNT_PREFERENCES_CONFIRMATION_BANNER_BODY_TEXT to LocalizedText(
                    en = "Your account settings have been successfully updated.",
                    accessibility_en = "Your account settings have been successfully updated."
                )
            )
        )

        return ContentResources(
            contentFile
        )
    }
}
