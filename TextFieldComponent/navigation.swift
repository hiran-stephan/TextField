fun ConsentsViewModel.onCheckboxCheckedChange(consentType: String) {
    _consentUiState.value = _consentUiState.value.copy(
        data = _consentUiState.value.data?.let { consentsData ->
            consentsData.copy(
                sections = consentsData.sections.map { section ->
                    if (section.consentData.consentText == consentType) {
                        // Toggle isConsentProvided only for the matching section
                        section.copy(
                            consentData = section.consentData.copy(
                                isConsentProvided = !section.consentData.isConsentProvided
                            )
                        )
                    } else {
                        section
                    }
                }
            )
        }
    )
}
