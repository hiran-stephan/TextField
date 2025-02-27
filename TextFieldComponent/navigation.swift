let groupedConsents = self.model.state?.data?.groupedConsents ?? [:]

ForEach(groupedConsents.keys.sorted(), id: \.self) { key in
    if let values = groupedConsents[key] {
        let presenter = viewModel.createConsentSectionPresenter(documentList: values)
        let section = presenter.toSectionData()
        
        ConsentCaptureSectionView(
            data: section,
            onChangeConsent: { checked in
                print("checked: \(checked)")
            },
            onChangeDocumentReviewStatus: { type, isReviewed in
                print("type: \(type) - isReviewed: \(isReviewed)")
            }
        )
    }
}
