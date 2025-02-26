extension ConsentSectionPresenter {
    func toConsentSectionData() -> [ConsentSectionData] {
        return sections.map { section in
            ConsentSectionData(
                title: getSectionTitle(consentType: section.consentData.consentType),
                captureListCardData: DocumentData(documents: section.consentDocuments.map { consentDocument in
                    ConsentDocument(
                        id: UUID(),
                        title: consentDocument.consentName,
                        type: consentDocument.consentType,
                        path: consentDocument.consentPath,
                        badgeText: "", // Placeholder for badge text if needed
                        errorMessage: consentDocument.error
                    )
                }),
                consentData: ConsentData(
                    text: getConsentText(consentType: section.consentData.consentType),
                    isChecked: isConsentRequired(consentType: section.consentData.consentType),
                    errorMessage: section.consentData.consentError
                )
            )
        }
    }
}
