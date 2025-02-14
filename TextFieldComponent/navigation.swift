import SwiftUI

struct ConsentCaptureListCell: View {
    struct ConsentCaptureData: Hashable {
        let link: String
        let icon: String
        let badgeText: String
    }

    let data: ConsentCaptureData

    var body: some View {
        VStack(alignment: .leading, spacing: BankingTheme.spacing.noPadding) {
            HStack(alignment: .center, spacing: BankingTheme.dimens.smallMedium) {
                HStack(alignment: .center, spacing: BankingTheme.dimens.small) {
                    ComponentImage(data.icon)
                    
                    Text(data.link)
                        .underline()
                        .typography(BankingTheme.typography.body)
                        .foregroundColor(BankingTheme.colors.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                .padding(.vertical, BankingTheme.dimens.small)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                BadgeIndicator(BadgeIndicatorData(type: .passive, text: data.badgeText))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(BankingTheme.dimens.medium)
            
            Divider()
                .frame(height: 1)
                .background(BankingTheme.colors.illustrationGrey)
                .padding(.horizontal, BankingTheme.dimens.medium)
        }
    }
}

struct ConsentCaptureListCell_Previews: PreviewProvider {
    static var previews: some View {
        ConsentCaptureListCell(
            data: ConsentCaptureListCell.ConsentCaptureData(
                link: "Electronic Disclosure Consent Agreement.pdf",
                icon: BankingTheme.icons.functional.pdf.rawValue,
                badgeText: "Pending review"
            )
        )
        .previewLayout(.sizeThatFits)
    }
}
