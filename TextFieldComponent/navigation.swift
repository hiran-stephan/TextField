import SwiftUI

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
        if style == ConsentStyle.readOnly {
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
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .toggleStyle(CheckboxToggleStyle(style: style))
        .modifier(ConsentStyleModifier(style: style)) // ✅ Extracted common styles
    }

    private var plainView: some View {
        HStack(alignment: .top, spacing: BankingTheme.dimens.smallMedium) {
            if let icon = isChecked.wrappedValue ? style.checkedIcon : style.uncheckedIcon {
                ComponentImage(icon)
            }

            Text(data.text)
                .typography(style.typography)
                .foregroundColor(BankingTheme.colors.textPrimary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .modifier(ConsentStyleModifier(style: style)) // ✅ Extracted common styles
    }
}





struct ConsentStyleModifier: ViewModifier {
    let style: ConsentStyle

    func body(content: Content) -> some View {
        content
            .padding(BankingTheme.dimens.medium)
            .frame(maxWidth: .infinity, alignment: style.alignment)
            .background(style.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: BankingTheme.dimens.smallMedium))
            .overlay(borderOverlay)
    }

    @ViewBuilder
    private var borderOverlay: some View {
        if let borderColor = style.borderColor {
            RoundedRectangle(cornerRadius: BankingTheme.dimens.smallMedium)
                .strokeBorder(borderColor, lineWidth: 1)
        }
    }
}
