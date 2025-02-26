fun ConsentsViewModel.onConsentsErrorStateChanged() {
    _consentUiState.value = _consentUiState.value.copy(
        data = _consentUiState.value.data?.let { consentsData ->
            consentsData.copy(
                sections = consentsData.sections.map { section ->
                    section.copy(
                        consentDocuments = section.consentDocuments.map { document ->
                            document.copy(
                                error = if (document.isReviewed) null
                                else "Error message will come from presenter {#000}"
                            )
                        }
                    )
                }
            )
        }
    )
}
