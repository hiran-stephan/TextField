struct ConsentCaptureSectionView: View {
    let data: ConsentSectionData
    let onChangeConsent: (Bool) -> Void
    let onChangeDocumentReviewStatus: (String, Bool) -> Void

    private var consentStyle: ConsentStyle {
        if let errorMessage = data.consentData.errorMessage, !errorMessage.isEmpty {
            return ConsentStyle.error
        } else if data.consentData.isChecked {
            return ConsentStyle.checkbox
        } else {
            return ConsentStyle.readOnly
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: BankingTheme.dimens.smallMedium) {
            // Section Title
            Text(data.title)
                .typography(BankingTheme.typography.body)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .topLeading)

            // List of PDF Links
            ConsentCaptureListCardView(
                data: data.captureListCardData,
                onChangeDocumentReviewStatus: onChangeDocumentReviewStatus
            )

            // Consent View
            ConsentView(
                data: data.consentData,
                style: consentStyle,
                onClickCheckbox: onChangeConsent
            )
        }
    }
}
