fun ConsentsViewModel.onConsentMethodErrorChanged() {
    _consentUiState.value = _consentUiState.value.copy(
        data = _consentUiState.value.data?.let { consentsData ->
            consentsData.copy(
                sections = consentsData.sections.map { section ->
                    section.copy(
                        consentData = section.consentData.copy(
                            consentError = if (section.consentData.isConsentProvided) null
                            else "Error message from presenter {#000}"
                        )
                    )
                }
            )
        }
    )
}
