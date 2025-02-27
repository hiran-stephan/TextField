extension ConsentSectionPresenter {
    func toSectionData() -> SectionData {
        return SectionData(
            id: UUID(),
            title: title, // Directly assigning the title from ConsentSectionPresenter
            documents: consentData.flatMap { consent in
                consent.documents.map { document in
                    ConsentDocument(
                        id: UUID(),
                        title: document.consentName,
                        type: document.consentType,
                        path: document.consentPath,
                        badgeText: document.isReviewed ? reviewedStatusPillText : pendingReviewStatusPillText,
                        errorMessage: document.error
                    )
                }
            },
            consent: ConsentData(
                text: getConsentText(consentType: consentData.firstOrNull()?.consentType ?? "Unknown"),
                isChecked: isCheckboxChecked,
                errorMessage: isConsentError ? "Check the box to confirm you've read and accepted all the presented terms." : nil
            )
        )
    }
}
