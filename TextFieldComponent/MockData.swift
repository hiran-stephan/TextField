fun getThresholdValue(purposeCode: String): String? {
    return selectedAlertPreferenceData.subscriptions
        ?.firstOrNull { it.purposeCode == purposeCode }
        ?.threshold
        ?.thresholdValue
}

val alertInputFieldValue = getThresholdValue(purposeCode)


val id = subscriptions
        .flatMap { it.preferenceDetails }
        .firstOrNull { it.deliveryMethod == contactTypeName }
        ?.id



val preferenceDetailsList = selectedAlertPreferenceData.subscriptions
    .flatMap { it.preferenceDetails }

_manageAlertsAlertSettingsUiState.update {
    it.copy(preferenceDetailsList = preferenceDetailsList)
}

val contactTypes = presenter.mapToManageAlertsContactTypes(
    preferenceDetails = uiState.preferenceDetailsList,
    configTypes = alertSettingsData.contactTypes?.types ?: emptyList()
)

fun mapToManageAlertsContactTypes(
    preferenceDetails: List<PreferenceDetail>,
    configTypes: List<ConfigType>
): List<ManageAlertsContactTypes> {
    return configTypes.map { config ->
        val deliveryMethod = mapContactTypeNameToDeliveryMethod(config.name)
        val matchingDetail = preferenceDetails.firstOrNull {
            it.deliveryMethod == deliveryMethod
        }

        ManageAlertsContactTypes(
            contactTypeId = matchingDetail?.id,
            contactType = config.name,
            contactValue = getContactValue(deliveryMethod),
            isSelected = matchingDetail?.selected ?: false,
            isRequired = config.required,
            contactTypeText = getContactTypeText(deliveryMethod, config.required)
        )
    }
}

val preferenceDetailsList = alertSettingsData
    .selectedAlertPreferenceData
    .subscriptions
    ?.flatMap { it.preferenceDetails }
    ?.map { it.toPreferenceDetailData() }
    ?: emptyList()


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

fun updatePreferenceDetailItem(id: String?, deliveryMethod: String, selected: Boolean) {
    _manageAlertsAlertSettingsUiState.update { state ->
        val currentList = state.preferenceDetailList

        val updatedList = currentList
            .filterNot { it.deliveryMethod == deliveryMethod } // Always remove the current item if it exists
            .let { filteredList ->
                if (selected) {
                    // Add it back only if selected is true
                    filteredList + PreferenceDetailData(
                        id = id,
                        deliveryMethod = deliveryMethod,
                        selected = true
                    )
                } else {
                    filteredList // Do nothing (item stays removed)
                }
            }

        state.copy(preferenceDetailList = updatedList)
    }
}
