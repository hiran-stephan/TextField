fun ConsentsViewModel.onConsentReviewed(consentData: ConsentDocumentsData) {
    _consentUiState.update { previousState ->
        previousState.copy(
            data = previousState.data?.updateReviewStatus(consentData)
        )
    }
}

fun ConsentsViewModel.onConsentsErrorStateChanged() {
    _consentUiState.value = _consentUiState.value.copy(
        data = _consentUiState.value.data?.let { consentsData ->
            consentsData.copy(
                sections = consentsData.sections.map { section ->
                    section.copy(
                        consentData = section.consentData.copy(
                            consentError = if (section.consentData.isConsentProvided) null
                            else "Error message will come from presenter {#000}"
                        )
                    )
                }
            )
        }
    )
}

fun ConsentsViewModel.onCheckboxCheckedChange() {
    _consentUiState.value = _consentUiState.value.copy(
        isCheckboxChecked = !_consentUiState.value.isCheckboxChecked
    )
}

fun ConsentsViewModel.onConsentMethodErrorChanged() {
    val errorText = if (_consentUiState.value.isCheckboxChecked) null
    else "Error message from presenter {#000}"

    _consentUiState.value = _consentUiState.value.copy(
        consentMethodError = errorText
    )
}


fun ConsentsData.updateReviewStatus(consentData: ConsentData): ConsentsData = copy(
    sections = sections.map { section ->
        section.copy(
            consentData = section.consentData.updateReviewStatusIfMatch(consentData)
        )
    }
)

fun ConsentData.updateReviewStatusIfMatch(consentData: ConsentData): ConsentData =
    if (this.consentText == consentData.consentText) {
        copy(isConsentProvided = !this.isConsentProvided)
    } else {
        this
    }

fun ConsentsData.determineConsentError(): String? {
    return sections.firstOrNull { !it.consentData.isConsentProvided }?.let {
        "You must review consent for ${it.title}."
    }
}
