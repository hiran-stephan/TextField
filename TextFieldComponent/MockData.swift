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
