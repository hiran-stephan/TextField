struct ConsentCaptureListCell: View {
    struct Data: Hashable {
        let title: String
        let badgeText: String
    }

    let data: Data

    @Environment(\.isLastRow) private var isLastRow: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: BankingTheme.spacing.noPadding) {
            HStack(alignment: .center, spacing: BankingTheme.dimens.smallMedium) {
                HStack(alignment: .center, spacing: BankingTheme.dimens.small) {
                    ComponentImage(BankingTheme.icons.functional.pdf.rawValue)
                }

                Text(data.title)
                    .underline()
                    .typography(BankingTheme.typography.body)
                    .foregroundColor(BankingTheme.colors.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            .padding(.vertical, BankingTheme.dimens.small)
            .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()

            BadgeIndicator(BadgeIndicatorData(type: .passive, text: data.badgeText))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(BankingTheme.dimens.medium)

            // Automatically hide the divider for the last row
            if !isLastRow {
                Divider()
                    .frame(height: 1)
                    .background(BankingTheme.colors.illustrationGrey)
                    .padding(.horizontal, BankingTheme.dimens.medium)
            }
        }
    }
}




private struct IsLastRowKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    var isLastRow: Bool {
        get { self[IsLastRowKey.self] }
        set { self[IsLastRowKey.self] = newValue }
    }
}


List(dataArray.indices, id: \.self) { index in
    ConsentCaptureListCell(data: dataArray[index])
        .environment(\.isLastRow, index == dataArray.count - 1)
}
