import SwiftUI

struct DocumentData {
    let documents: [Document]
}

struct Document: Identifiable {
    let id = UUID()
    let title: String
    let type: String
    let path: String
    let badgeText: String
    let errorMessage: String?
}

struct ConsentCaptureListCardView: View {
    let data: DocumentData
    let onChangeDocumentReviewStatus: (String, Bool) -> Void

    var body: some View {
        LazyVStack(alignment: .leading, spacing: BankingTheme.spacing.noPadding) {
            if let firstDocument = data.documents.first {
                documentCell(for: firstDocument)
            }
            
            ForEach(data.documents.dropFirst()) { document in
                createDivider()
                documentCell(for: document)
            }
        }
        .cornerRadius(BankingTheme.dimensions.smallMedium)
        .modifier(TileViewModifier())
    }
    
    @ViewBuilder
    private func documentCell(for document: Document) -> some View {
        ConsentCaptureListCell(
            data: ConsentCaptureListCell.Data(
                title: document.title,
                badgeText: document.badgeText,
                errorMessage: document.errorMessage
            ),
            onReviewDocument: {
                onChangeDocumentReviewStatus(document.type, true)
            }
        )
    }

    @ViewBuilder
    private func createDivider() -> some View {
        Divider()
            .frame(height: BankingTheme.spacing.stroke)
            .background(BankingTheme.colors.borderDefault)
            .accessibilityHidden(true)
            .padding(.horizontal, BankingTheme.dimensions.medium)
    }
}
