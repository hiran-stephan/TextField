import SwiftUI

struct ConsentCaptureSectionView: View {
    struct ConsentCaptureSectionData: Hashable {
        let title: String
        let pdfLinks: [String]
        let icon: String
        let badgeText: String
        let consentText: String
        let consentType: ConsentView.ConsentType
    }

    let data: ConsentCaptureSectionData

    var body: some View {
        VStack(alignment: .leading, spacing: BankingTheme.dimens.smallMedium) {
            // Section Title
            Text(data.title)
                .typography(BankingTheme.typography.body)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            
            // List of PDF Links
            ConsentCaptureListCard(
                data: ConsentCaptureListCard.ConsentCaptureCardData(
                    pdfLinks: data.pdfLinks,
                    icon: data.icon,
                    badgeText: data.badgeText
                )
            )

            // Consent Agreement View with dynamic consent type
            ConsentView(
                isChecked: .constant(false),
                data: ConsentView.ConsentData(
                    text: data.consentText,
                    type: data.consentType
                )
            )
        }
        .padding(BankingTheme.dimens.medium)
    }
}

struct ConsentCaptureSectionView_Previews: PreviewProvider {
    static var previews: some View {
        ConsentCaptureSectionView(
            data: ConsentCaptureSectionView.ConsentCaptureSectionData(
                title: "Agreement Documents",
                pdfLinks: [
                    "Electronic Disclosure Consent Agreement.pdf",
                    "Banking Terms & Conditions.pdf",
                    "Privacy Policy.pdf"
                ],
                icon: BankingTheme.icons.functional.pdf.rawValue,
                badgeText: "Pending review",
                consentText: "We read and agree to the Electronic Disclosure Consent Agreement.",
                consentType: .normal // Pass different types (.error, .confirmed) dynamically
            )
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
