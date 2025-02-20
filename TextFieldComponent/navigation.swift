struct ConsentStyle: Identifiable, Equatable {
    let id = UUID()
    let uncheckedIcon: (any ComponentIcon)?
    let checkedIcon: (any ComponentIcon)?
    let typography: TypographyFont
    let backgroundColor: Color
    let borderColor: Color?
    let alignment: Alignment

    init(
        uncheckedIcon: (any ComponentIcon)? = nil,
        checkedIcon: (any ComponentIcon)? = nil,
        typography: TypographyFont,
        backgroundColor: Color,
        borderColor: Color? = nil,
        alignment: Alignment
    ) {
        self.uncheckedIcon = uncheckedIcon
        self.checkedIcon = checkedIcon
        self.typography = typography
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.alignment = alignment
    }

    static let checkbox = ConsentStyle(
        uncheckedIcon: BankingTheme.icons.functional.checkboxBlack,
        checkedIcon: BankingTheme.icons.functional.checked,
        typography: BankingTheme.typography.bodySemiBold,
        backgroundColor: BankingTheme.colors.illustrationGrey,
        borderColor: BankingTheme.colors.textSecondary,
        alignment: .topLeading
    )

    static let readOnly = ConsentStyle(
        typography: BankingTheme.typography.body,
        backgroundColor: BankingTheme.colors.illustrationGrey,
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

    // ✅ Implement Equatable conformance
    static func == (lhs: ConsentStyle, rhs: ConsentStyle) -> Bool {
        return lhs.uncheckedIcon === rhs.uncheckedIcon &&
               lhs.checkedIcon === rhs.checkedIcon &&
               lhs.typography == rhs.typography &&
               lhs.backgroundColor == rhs.backgroundColor &&
               lhs.borderColor == rhs.borderColor &&
               lhs.alignment == rhs.alignment
    }
}
