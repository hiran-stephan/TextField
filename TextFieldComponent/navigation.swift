import SwiftUI

// MARK: - Custom Checkbox Toggle Style
struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle() // ✅ Corrected `isOn`
        }) {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square") // ✅ Fixed `isOn`
                    .foregroundColor(.primary)
                configuration.label
            }
        }
        .buttonStyle(PlainButtonStyle()) // ✅ Removes default button styling
    }
}

// MARK: - ConsentView
struct ConsentView: View {
    enum ConsentType {
        case normal, reviewed, error
        
        var alignment: Alignment {
            self == .reviewed ? .center : .topLeading
        }
    }

    struct Data {
        let text: String
        var isChecked: Bool
        let type: ConsentType
        let errorMessage: String?
    }

    @State private var data: Data
    let onClickCheckbox: (Bool) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Toggle(isOn: $data.isChecked) {
                Text(data.text)
                    .typography(data.type.typography)
                    .foregroundColor(BankingTheme.colors.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .multilineTextAlignment(.leading)
            }
            .toggleStyle(iOSCheckboxToggleStyle())
            .padding(BankingTheme.dimensions.medium)
            .frame(maxWidth: .infinity, alignment: data.type.alignment)
            .background(data.type.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: BankingTheme.dimensions.smallMedium))
            .overlay(borderOverlay)
            .onChange(of: data.isChecked) { newValue in
                onClickCheckbox(newValue)
            }

            if let errorMessage = data.errorMessage, data.isChecked {
                errorAlertView(message: errorMessage)
            }
        }
    }

    // MARK: - Error Alert View
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

    // MARK: - Border Overlay
    @ViewBuilder
    private var borderOverlay: some View {
        RoundedRectangle(cornerRadius: BankingTheme.dimensions.smallMedium)
            .stroke(data.type.borderColor ?? .clear, lineWidth: 1)
    }
}
