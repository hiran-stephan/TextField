import SwiftUI

struct ConsentCaptureListCell: View {
    let link: String

    var body: some View {
        HStack {
            Image(systemName: "doc.text") // PDF Icon
            Text(link)
                .foregroundColor(.blue)
                .underline()
            Spacer()
            BadgeIndicator(BadgeIndicatorData(type: .passive, text: "Pending review"))
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
    }
}


struct ConsentCaptureListView: View {
    let pdfLinks = [
        "Electronic Disclosure Consent Agreement (PDF, 15 KB)",
        "CIBC Digital Banking Service Agreement (PDF, 15 KB)"
    ]
    
    var body: some View {
        VStack {
            ForEach(pdfLinks, id: \.self) { link in
                ConsentCaptureListCell(link: link)
            }
        }
        .padding()
    }
}

// Separator
            Divider()
                .frame(height: 1)
                .background(BankingTheme.colors.illustrationGrey)
                .padding(.horizontal, BankingTheme.dimens.medium)
