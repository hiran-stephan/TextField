import SwiftUI

struct ConsentStyle: Equatable, Identifiable {
    let id = UUID()
    let uncheckedIcon: (any ComponentIcon)?
    let checkedIcon: (any ComponentIcon)?
    let typography: TypographyFont
    let backgroundColor: Color
    let borderColor: Color?
    let alignment: Alignment

    static let checkbox = ConsentStyle(
        uncheckedIcon: BankingTheme.icons.functional.checkboxBlack,
        checkedIcon: BankingTheme.icons.functional.checked,
        typography: BankingTheme.typography.bodySemiBold,
        backgroundColor: BankingTheme.colors.illustrationGrey,
        borderColor: BankingTheme.colors.textSecondary,
        alignment: .topLeading
    )
    
    static let plain = ConsentStyle(
        uncheckedIcon: nil,
        checkedIcon: nil,
        typography: BankingTheme.typography.body,
        backgroundColor: BankingTheme.colors.illustrationGrey,
        borderColor: nil,
        alignment: .center
    )
    
    static let error = ConsentStyle(
        uncheckedIcon: BankingTheme.icons.functional.checkboxRed,
        checkedIcon: BankingTheme.icons.functional.checked,
        typography: BankingTheme.typography.bodySemiBold,
        backgroundColor: BankingTheme.colors.errorContainer,
        borderColor: BankingTheme.colors.errorBorder,
        alignment: .topLeading
    )
}


struct ConsentView: View {
    let data: ConsentData
    let style: ConsentStyle
    let onClickCheckbox: (Bool) -> Void

    private var isChecked: Binding<Bool> {
        Binding(
            get: { data.isChecked },
            set: { newValue in onClickCheckbox(newValue) }
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            contentView
        }
    }

    @ViewBuilder
    private var contentView: some View {
        if style == .plain {
            plainView
        } else {
            toggleCheckbox
        }
    }

    private var toggleCheckbox: some View {
        Toggle(isOn: isChecked) {
            Text(data.text)
                .typography(style.typography)
                .foregroundColor(BankingTheme.colors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .multilineTextAlignment(.leading)
        }
        .toggleStyle(CheckboxToggleStyle(style: style))
        .padding(BankingTheme.dimens.medium)
        .frame(maxWidth: .infinity, alignment: style.alignment)
        .background(style.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: BankingTheme.dimens.smallMedium))
        .overlay(borderOverlay)
    }

    private var plainView: some View {
        HStack(alignment: .top, spacing: BankingTheme.dimens.smallMedium) {
            if let icon = isChecked.wrappedValue ? style.checkedIcon : style.uncheckedIcon {
                ComponentImage(icon)
            }
            Text(data.text)
                .typography(style.typography)
                .foregroundColor(BankingTheme.colors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .multilineTextAlignment(.leading)
        }
        .padding(BankingTheme.dimens.medium)
        .frame(maxWidth: .infinity, alignment: style.alignment)
    }

    @ViewBuilder
    private var borderOverlay: some View {
        if let borderColor = style.borderColor {
            RoundedRectangle(cornerRadius: BankingTheme.dimens.smallMedium)
                .strokeBorder(borderColor, lineWidth: 1)
        }
    }
}



struct CheckboxToggleStyle: ToggleStyle {
    let style: ConsentStyle

    func makeBody(configuration: Configuration) -> some View {
        Button(
            action: { configuration.isOn.toggle() },
            label: {
                HStack {
                    if let icon = configuration.isOn ? style.checkedIcon : style.uncheckedIcon {
                        ComponentImage(icon)
                    }
                    configuration.label
                }
            }
        )
        .buttonStyle(.borderless)
        .tint(.primary)
        .accessibility(label: Text(configuration.isOn ? "Checked" : "Unchecked"))
        .accessibility(addTraits: .isButton)
    }
}



