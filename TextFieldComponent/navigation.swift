import SwiftUI

struct ConsentCaptureListCell: View {
    let data: Document
    let onReviewDocument: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: BankingTheme.spacing.noPadding) {
            
            HStack(alignment: .center, spacing: BankingTheme.dimensions.smallMedium) {
                HStack(alignment: .center, spacing: BankingTheme.dimensions.small) {
                    ComponentImage(BankingTheme.icons.functional.pdf.rawValue)
                }
                
                titleTextView
            }
            .padding(.vertical, BankingTheme.dimensions.small)

            BadgeIndicator(BadgeIndicatorData(type: .passive, text: data.badgeText))
                .frame(maxWidth: .infinity, alignment: .leading)
                .onTapGesture {
                    onReviewDocument()
                }

            if let errorMessage = data.errorMessage {
                errorAlertView(message: errorMessage)
            }

            createDivider()
        }
        .padding(BankingTheme.dimensions.medium)
    }

    // MARK: - Extracted Subviews

    /// Title Text View
    @ViewBuilder
    private var titleTextView: some View {
        Text(data.title)
            .underline()
            .typography(BankingTheme.typography.body)
            .foregroundColor(BankingTheme.colors.textPrimary)
            .frame(maxWidth: .infinity, alignment: .topLeading)
    }

    /// Error Alert View
    @ViewBuilder
    private func errorAlertView(message: String) -> some View {
        HStack(alignment: .top, spacing: BankingTheme.dimensions.microSmall) {
            InlineAlert(
                statusMessage: message,
                alertType: .error,
                mode: .borderless(hasIcon: true)
            )
        }
        .padding(.top, BankingTheme.dimensions.small)
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }

    /// Divider View
    @ViewBuilder
    private func createDivider() -> some View {
        Divider()
            .frame(height: BankingTheme.spacing.stroke)
            .background(BankingTheme.colors.borderDefault)
            .accessibilityHidden(true)
            .padding(.horizontal, BankingTheme.dimensions.medium)
    }
}
