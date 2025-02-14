import SwiftUI

struct ReviewAgreementsView: View {
    struct AgreementSectionData: Hashable {
        let title: String
        let pdfLinks: [String]
        let icon: String
        let badgeText: String
        let consentText: String
        let consentType: ConsentView.ConsentType
    }

    @State private var agreementSections: [AgreementSectionData] = [
        AgreementSectionData(
            title: "1. Review and accept the following agreement:",
            pdfLinks: ["Electronic Disclosure Consent Agreement (PDF, 15 KB)"],
            icon: BankingTheme.icons.functional.pdf.rawValue,
            badgeText: "Pending review",
            consentText: "I/we read and agree to the Electronic Disclosure Consent Agreement.",
            consentType: .normal
        ),
        AgreementSectionData(
            title: "2. Review and accept the following agreement:",
            pdfLinks: ["CIBC Digital Banking Service Agreement (PDF, 15 KB)"],
            icon: BankingTheme.icons.functional.pdf.rawValue,
            badgeText: "Pending review",
            consentText: "By clicking ‘Continue’, I confirm I have received, reviewed, and agreed to the CIBC Digital Banking Service Agreement.",
            consentType: .confirmed
        )
    ]

    var body: some View {
        VStack(alignment: .center, spacing: BankingTheme.dimens.extraLarge) {
            // Heading
            Text("Review agreements")
                .typography(BankingTheme.typography.heading.medium)
                .multilineTextAlignment(.center)
                .foregroundColor(BankingTheme.colors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .top)
            
            // Body Description
            Text("Some of our agreements have been updated. To continue with your online banking, review and agree to the document provided.")
                .typography(BankingTheme.typography.body)
                .foregroundColor(BankingTheme.colors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            
            // List of Agreement Sections
            ForEach(agreementSections, id: \.self) { section in
                ConsentCaptureSectionView(
                    data: ConsentCaptureSectionView.ConsentCaptureSectionData(
                        title: section.title,
                        pdfLinks: section.pdfLinks,
                        icon: section.icon,
                        badgeText: section.badgeText,
                        consentText: section.consentText,
                        consentType: section.consentType
                    )
                )
            }

            // Action Buttons
            buildButtonView()
        }
        .padding(BankingTheme.dimens.medium)
    }

    private func buildButtonView() -> some View {
        ActionBar(
            primaryButton: PrimaryButton(
                content: { Text("Submit") },
                buttonPaddingLeading: .zero,
                buttonPaddingTrailing: .zero,
                action: {
                    // viewModel.sendCode()
                }
            ),
            secondaryButton: SecondaryButton(
                content: { Text("Cancel") },
                buttonPaddingLeading: .zero,
                buttonPaddingTrailing: .zero,
                action: {
                    // viewModel.clickCancel()
                }
            )
        )
        .padding(.horizontal, BankingTheme.dimens.medium)
        .padding(.top, BankingTheme.dimens.smallMedium)
        .padding(.bottom, BankingTheme.dimens.extraLarge)
        .frame(maxWidth: .infinity, alignment: .top)
    }
}

struct ReviewAgreementsView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewAgreementsView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
