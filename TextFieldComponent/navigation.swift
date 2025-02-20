protocol ConsentStyle {
    var uncheckedIcon: (any ComponentIcon)? { get }
    var checkedIcon: (any ComponentIcon)? { get }
    var typography: TypographyFont { get }
    var backgroundColor: Color { get }
    var borderColor: Color? { get }
    var alignment: Alignment { get }
}


struct CheckboxConsentStyle: ConsentStyle {
    var uncheckedIcon: (any ComponentIcon)? { BankingTheme.icons.functional.checkboxBlack }
    var checkedIcon: (any ComponentIcon)? { BankingTheme.icons.functional.checked }
    var typography: TypographyFont { BankingTheme.typography.bodySemiBold }
    var backgroundColor: Color { BankingTheme.colors.illustrationGrey }
    var borderColor: Color? { BankingTheme.colors.textSecondary }
    var alignment: Alignment { .topLeading }
}

struct PlainConsentStyle: ConsentStyle {
    var uncheckedIcon: (any ComponentIcon)? { nil }
    var checkedIcon: (any ComponentIcon)? { nil }
    var typography: TypographyFont { BankingTheme.typography.body }
    var backgroundColor: Color { BankingTheme.colors.illustrationGrey }
    var borderColor: Color? { nil }
    var alignment: Alignment { .center }
}


struct ErrorConsentStyle: ConsentStyle {
    var uncheckedIcon: (any ComponentIcon)? { BankingTheme.icons.functional.checkboxRed }
    var checkedIcon: (any ComponentIcon)? { BankingTheme.icons.functional.checked }
    var typography: TypographyFont { BankingTheme.typography.bodySemiBold }
    var backgroundColor: Color { BankingTheme.colors.errorContainer }
    var borderColor: Color? { BankingTheme.colors.errorBorder }
    var alignment: Alignment { .topLeading }
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
            if !(style is PlainConsentStyle) {
                toggleCheckbox
            }
            if style is PlainConsentStyle {
                plainView
            }
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
        Button(action: { configuration.isOn.toggle() }) {
            HStack {
                if let icon = configuration.isOn ? style.checkedIcon : style.uncheckedIcon {
                    ComponentImage(icon)
                }
                configuration.label
            }
        }
        .buttonStyle(.borderless)
        .tint(.primary)
    }
}

struct ContentView: View {
    @State private var consentData = ConsentData(
        text: "I agree to the terms and conditions",
        isChecked: false
    )

    var body: some View {
        VStack {
            ConsentView(data: consentData, style: CheckboxConsentStyle()) { newValue in
                consentData.isChecked = newValue
            }
            
            ConsentView(data: consentData, style: PlainConsentStyle()) { newValue in
                consentData.isChecked = newValue
            }

            ConsentView(data: consentData, style: ErrorConsentStyle()) { newValue in
                consentData.isChecked = newValue
            }
        }
        .padding()
    }
}
