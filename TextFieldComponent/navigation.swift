fun ConsentsViewModel.onConsentReviewed(consentData: ConsentDocumentsData) {
    _consentUiState.update { previousState ->
        previousState.copy(
            data = previousState.data?.updateDocumentReviewStatus(consentData)
        )
    }
}

fun ConsentsData.updateDocumentReviewStatus(consentData: ConsentDocumentsData): ConsentsData = copy(
    sections = sections.map { section ->
        section.copy(
            consentDocuments = section.consentDocuments.map { document ->
                document.updateReviewStatusIfMatch(consentData)
            }
        )
    }
)

fun ConsentDocumentsData.updateReviewStatusIfMatch(consentData: ConsentDocumentsData): ConsentDocumentsData =
    if (this.consentName == consentData.consentName && this.consentVersion == consentData.consentVersion) {
        copy(isReviewed = !this.isReviewed)
    } else {
        this
    }
