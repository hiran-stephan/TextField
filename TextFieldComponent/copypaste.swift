struct ConsentCaptureListCardView: View {
    let documents: [ConsentDocument]
    let onChangeDocumentReviewStatus: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: BankingTheme.dimens.smallMedium) {
            ForEach(documents) { document in
                documentCell(for: document)
                    .modifier(TileViewModifier()) // ✅ each doc is its own card
            }
        }
        .padding(.horizontal, BankingTheme.dimens.medium)
    }

    @ViewBuilder
    private func documentCell(for document: ConsentDocument) -> some View {
        ConsentCaptureListCell(
            data: document,
            onReviewDocument: {
                onChangeDocumentReviewStatus(document.type)
            }
        )
    }
}

@ViewBuilder
private func createDivider() -> some View { EmptyView() } // or delete
