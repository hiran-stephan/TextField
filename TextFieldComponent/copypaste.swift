override fun fetchConsents(): Flow<NetworkResultState<List<ConsentData>>> = flow {
    emit(NetworkResultState.Loading)
    val mockResponse = listOf(
        ConsentData(
            consentName = "Digital Banking Service Agreement",
            consentType = "14",
            consentVersion = "November 2024",
            consentPath = "/content/dam/us-public-assets/documents/legal/notice/cibc-bank-usa-digital-services-agreement.pdf"
        ),
        ConsentData(
            consentName = "Electronic Disclosure Consent Agreement",
            consentType = "13",
            consentVersion = "December 2023",
            consentPath = "/content/dam/us-public-assets/documents/legal/notice/electronic-disclosure-consent-agreement.pdf"
        ),
        ConsentData(
            consentName = "Electronic Documents Agreement and Disclosure",
            consentType = "19",
            consentVersion = "December 2023",
            consentPath = "/content/dam/us-public-assets/documents/legal/notice/cibc-bank-usa-electronic-documents-agreement-disclosure.pdf"
        )
    )
    emit(NetworkResultState.Success(mockResponse))
}
