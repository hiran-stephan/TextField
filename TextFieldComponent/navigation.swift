import SwiftUI

struct ConsentCaptureListCard: View {
    struct ConsentCaptureCardData: Hashable {
        let pdfLinks: [String]
        let icon: String
        let badgeText: String
    }

    let data: ConsentCaptureCardData

    var body: some View {
        VStack(alignment: .leading, spacing: BankingTheme.spacing.noPadding) {
            ForEach(data.pdfLinks, id: \.self) { link in
                ConsentCaptureListCell(
                    data: ConsentCaptureListCell.ConsentCaptureData(
                        link: link,
                        icon: data.icon,
                        badgeText: data.badgeText
                    )
                )
            }
        }
        .cornerRadius(BankingTheme.dimens.smallMedium)
        .overlay(
            RoundedRectangle(cornerRadius: BankingTheme.dimens.smallMedium)
                .inset(by: 0.5)
                .stroke(BankingTheme.colors.borderDefault, lineWidth: BankingTheme.spacing.stroke)
        )
    }
}

struct ConsentCaptureListCard_Previews: PreviewProvider {
    static var previews: some View {
        ConsentCaptureListCard(
            data: ConsentCaptureListCard.ConsentCaptureCardData(
                pdfLinks: [
                    "Electronic Disclosure Consent Agreement.pdf",
                    "Banking Terms & Conditions.pdf",
                    "Privacy Policy.pdf"
                ],
                icon: BankingTheme.icons.functional.pdf.rawValue,
                badgeText: "Pending review"
            )
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
