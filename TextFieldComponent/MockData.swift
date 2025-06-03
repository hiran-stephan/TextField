struct ManageAlertCardView: View {
    let id: UUID = UUID()
    let label: String
    let secondaryLabel: String?
    let tertiaryLabel: String?
    let backgroundColor: Color
    let trailingView: TrailingView?
    let action: (() -> Void)?

    init(
        label: String,
        secondaryLabel: String? = nil,
        tertiaryLabel: String? = nil,
        backgroundColor: Color = BankingTheme.colors.surfaceVariant,
        trailingView: TrailingView? = nil,
        action: (() -> Void)? = nil
    ) {
        self.label = label
        self.secondaryLabel = secondaryLabel
        self.tertiaryLabel = tertiaryLabel
        self.backgroundColor = backgroundColor
        self.trailingView = trailingView
        self.action = action
    }

    var body: some View {
        Group {
            if let action = action {
                Button(action: action) {
                    cardBody
                }
                .buttonStyle(ManageAlertCardViewButtonModifier())
            } else {
                cardBody
                    .accessibilityElement(children: .combine)
            }
        }
        .background(backgroundColor)
        .cornerRadius(BankingTheme.spacing.medium)
    }

    private var cardBody: some View {
        VStack(alignment: .leading, spacing: BankingTheme.dimens.small) {
            HStack(alignment: .top, spacing: BankingTheme.dimens.smallMedium) {
                labelSection
                    .layoutPriority(1) // Prioritize label section for space

                trailingIcon
                    .fixedSize() // Prevent icon from stretching
            }

            if let tertiaryLabel = tertiaryLabel {
                Divider()
                    .frame(height: BankingTheme.spacing.stroke)
                    .background(BankingTheme.colors.borderDefault)
                    .accessibilityHidden(true)

                Text(tertiaryLabel)
                    .typography(BankingTheme.typography.bodySmall)
                    .foregroundColor(BankingTheme.colors.textSecondary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
        }
        .padding(BankingTheme.dimens.medium)
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }

    private var labelSection: some View {
        VStack(alignment: .leading, spacing: BankingTheme.spacing.noPadding) {
            Text(label)
                .typography(BankingTheme.typography.bodySemiBold)
                .foregroundColor(BankingTheme.colors.textPrimary)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)

            if let secondaryLabel = secondaryLabel {
                Text(secondaryLabel)
                    .typography(BankingTheme.typography.bodySmall)
                    .foregroundColor(BankingTheme.colors.textSecondary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }

    private var trailingIcon: some View {
        switch trailingView {
        case .disclosure(let image):
            return AnyView(
                image
                    .resizable()
                    .frame(
                        width: BankingTheme.spacing.actionIconSize,
                        height: BankingTheme.spacing.actionIconSize
                    )
            )
        case .none:
            return AnyView(EmptyView())
        }
    }

    enum TrailingView {
        case disclosure(Image)
    }
}


private fun ConsentsViewModel.getConsentValidationErrorCount(): Int {
    var errorCount = 0

    // Count how many grouped consents are not reviewed
    val unreviewedCount = consentUiState.value.data
        ?.groupedConsents
        ?.values
        ?.flatten()
        ?.count { !it.isReviewed } ?: 0
    errorCount += unreviewedCount

    // Count checkbox unchecked (1 error if unchecked)
    val isCheckboxUnchecked = consentUiState.value
        .findConsentByType(EDCA_TYPE)
        ?.let { !consentUiState.value.isCheckboxChecked } ?: false
    if (isCheckboxUnchecked) {
        errorCount += 1
    }

    return errorCount
}


[*/src/commonTest/**/*.kt]
max_line_length = off
