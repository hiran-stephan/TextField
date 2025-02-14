import SwiftUI

struct ConsentView: View {
    enum ConsentType {
        case normal, confirmed, error

        var icon: String {
            switch self {
            case .normal, .confirmed:
                return BankingTheme.icons.functional.checkboxBlack.rawValue
            case .error:
                return BankingTheme.icons.functional.checkboxRed.rawValue
            }
        }

        var typography: Font {
            switch self {
            case .normal, .error:
                return BankingTheme.typography.bodySemiBold
            case .confirmed:
                return BankingTheme.typography.body
            }
        }

        var backgroundColor: Color {
            switch self {
            case .normal, .confirmed:
                return BankingTheme.colors.illustrationGrey
            case .error:
                return BankingTheme.colors.errorContainer
            }
        }

        var borderColor: Color? {
            switch self {
            case .error:
                return BankingTheme.colors.errorBorder
            default:
                return nil
            }
        }

        var alignment: Alignment {
            return self == .confirmed ? .center : .topLeading
        }
    }

    struct ConsentData {
        let text: String
        let type: ConsentType
    }

    @Binding var isChecked: Bool
    let data: ConsentData

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: BankingTheme.dimens.smallMedium) {
                ComponentImage(data.type.icon)

                Text(data.text)
                    .font(data.type.typography)
                    .foregroundColor(BankingTheme.colors.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .multilineTextAlignment(.leading)
            }
            .padding(BankingTheme.dimens.medium)
            .frame(maxWidth: .infinity, alignment: data.type.alignment)
            .background(data.type.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: BankingTheme.dimens.smallMedium))
            .overlay(borderOverlay)
            .onTapGesture {
                isChecked.toggle()
            }
        }
    }

    @ViewBuilder
    private var borderOverlay: some View {
        if let borderColor = data.type.borderColor {
            RoundedRectangle(cornerRadius: BankingTheme.dimens.smallMedium)
                .strokeBorder(borderColor, lineWidth: 1)
        }
    }
}

struct ConsentView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ConsentView(isChecked: .constant(false), data: ConsentView.ConsentData(
                text: "We read and agree to the Electronic Disclosure Consent Agreement.",
                type: .normal
            ))

            ConsentView(isChecked: .constant(false), data: ConsentView.ConsentData(
                text: "By clicking ‘Continue’, I confirm I have received, reviewed, and agreed to the CIBC Digital Banking Service Agreement.",
                type: .confirmed
            ))

            ConsentView(isChecked: .constant(false), data: ConsentView.ConsentData(
                text: "We read and agree to the Electronic Disclosure Consent Agreement.",
                type: .error
            ))
        }
        .padding()
    }
}


ConsentView(isChecked: .constant(false), data: ConsentView.ConsentData(
                text: "We read and agree to the Electronic Disclosure Consent Agreement.",
                type: .normal
            ))

            ConsentView(isChecked: .constant(false), data: ConsentView.ConsentData(
                text: "By clicking ‘Continue’, I confirm I have received, reviewed, and agreed to the CIBC Digital Banking Service Agreement.",
                type: .confirmed
            ))

            ConsentView(isChecked: .constant(false), data: ConsentView.ConsentData(
                text: "We read and agree to the Electronic Disclosure Consent Agreement.",
                type: .error
            ))
