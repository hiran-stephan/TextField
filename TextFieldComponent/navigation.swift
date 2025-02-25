package com.cibc.consents.ui.screens.consents

import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.update

class ConsentsPresenter(
    private val contentFile: ContentFile?,
    private val uiState: ConsentsUiState
) {

    val consentDataFlow = MutableStateFlow(mapToIOSModel())

    private fun mapToIOSModel(): IOSConsentData {
        return IOSConsentData(
            title = "Review agreements",
            description = "Some of our agreements have been updated. To continue, review and agree.",
            sections = uiState.data?.groupedConsents?.map { (type, consents) ->
                IOSConsentSection(
                    title = "Review and accept: $type",
                    documents = consents.map { consent ->
                        IOSConsentDocument(
                            id = consent.id,
                            title = consent.title,
                            path = consent.path,
                            isReviewed = consent.isReviewed
                        )
                    }
                )
            } ?: emptyList(),
            isCheckboxChecked = uiState.isCheckboxChecked
        )
    }

    fun onDocumentOpened(documentId: String) {
        uiState.data?.let {
            val updatedData = it.copy(
                groupedConsents = it.groupedConsents.mapValues { (_, consentList) ->
                    consentList.map { consent ->
                        if (consent.id == documentId) consent.copy(isReviewed = true) else consent
                    }
                }
            )

            updateState(updatedData)
        }
    }

    fun onCheckboxCheckedChange() {
        updateState(uiState.data, !uiState.isCheckboxChecked)
    }

    fun validateAndSubmit() {
        val hasPendingConsent = uiState.data?.groupedConsents?.values?.flatten()?.any { !it.isReviewed } ?: false

        if (!hasPendingConsent && uiState.isCheckboxChecked) {
            submitConsents()
        }
    }

    private fun updateState(updatedData: ConsentsData?, isCheckboxChecked: Boolean = uiState.isCheckboxChecked) {
        val newState = uiState.copy(data = updatedData, isCheckboxChecked = isCheckboxChecked)
        consentDataFlow.value = mapToIOSModel()
    }

    private fun submitConsents() {
        // API call to submit consents
    }
}
