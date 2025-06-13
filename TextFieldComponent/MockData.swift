val preferenceDetailsList = alertSettingsData
    .selectedAlertPreferenceData
    .subscriptions
    ?.flatMap { it.preferenceDetails }
    ?.map { it.toPreferenceDetailData() }
    ?: emptyList()

List<PreferenceDetailData>


fun contactTypeDataList(preferenceDetailsList: List<PreferenceDetailData>): List<ManageAlertsContactTypes> {
    val contactTypes = selectedAlertPreferenceData?.contactTypes?.types ?: emptyList()

    return contactTypes.map { contactType ->
        val contactTypeName = mapContactTypeNameToDeliveryMethod(contactType.name)
        val isRequired = contactType.required

        val matchingPreference = preferenceDetailsList.firstOrNull {
            it.deliveryMethod == contactTypeName
        }

        val contactTypeId = matchingPreference?.id
        val isSelected = matchingPreference?.selected ?: false

        val contactValue = when (contactTypeName) {
            MANAGEALERTS_PREFERENCE_DETAIL_EMAIL -> "test@email.com"
            MANAGEALERTS_PREFERENCE_DETAIL_SMS -> "123-456-7890"
            else -> null
        }

        val contactTypeText = when (contactTypeName) {
            MANAGEALERTS_PREFERENCE_DETAIL_MESSAGE_CENTER -> {
                if (isRequired) {
                    displayContent(MANAGE_ALERTS_MANDATORY_MY_MESSAGES_TEXT)
                } else {
                    displayContent(MANAGE_ALERTS_CHECKBOX_MY_MESSAGES_TEXT)
                }
            }
            MANAGEALERTS_PREFERENCE_DETAIL_PUSH -> displayContent(MANAGE_ALERTS_CHECKBOX_PUSH_NOTIFICATION_TEXT)
            MANAGEALERTS_PREFERENCE_DETAIL_EMAIL -> {
                if (isRequired) {
                    displayContent(MANAGE_ALERTS_MANDATORY_EMAIL_TEXT)
                } else {
                    displayContent(MANAGE_ALERTS_CHECKBOX_EMAIL_TEXT)
                }
            }
            MANAGEALERTS_PREFERENCE_DETAIL_SMS -> displayContent(MANAGE_ALERTS_CHECKBOX_TEXT_MESSAGE_TEXT)
            else -> null
        }

        ManageAlertsContactTypes(
            contactTypeId = contactTypeId,
            contactType = contactTypeText,
            contactValue = contactValue,
            isRequired = isRequired,
            isSelected = isSelected
        )
    }
}
