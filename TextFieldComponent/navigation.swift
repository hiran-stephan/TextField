func errorInlineListView(
    alertType: String,
    alertMessage: String,
    alertCode: String,
    actionString: String = "",
    applyPadding: Bool = false,
    retryAction: @escaping () -> Void = {}
) -> AnyView {
    let alertEnumType = AlertType.find(key: alertType)

    guard alertEnumType != .none else {
        return AnyView(EmptyView()) // Avoid rendering anything if alertType is .none
    }

    return AnyView(
        Section {
            VStack(spacing: BankingTheme.spacing.noPadding) {
                AlertGlobal(
                    alertType: alertEnumType,
                    alertGlobalData: AlertGlobalData(
                        alertMessage: alertMessage,
                        actionString: actionString,
                        resultText: alertCode
                    ),
                    retryAction: retryAction
                )
            }
            .padding(.horizontal, applyPadding ? BankingTheme.dimens.medium : BankingTheme.spacing.noPadding)
        }
        .listRowSeparator(.hidden)
    )
}
