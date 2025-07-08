struct ManageAlertsAlertSettingsScreen: View {
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: BankingTheme.dimens.mediumLarge) {
                    LoadingErrorLayout(
                        isLoading: isLoading,
                        hasData: hasData,
                        hasFullError: hasFullError,
                        hasInlineError: hasInlineError,
                        inlineError: { errorInlineView() },
                        fullError: { errorFullView() },
                        content: {
                            VStack(spacing: BankingTheme.dimens.mediumLarge) {
                                contentView()

                                Spacer(minLength: 0)

                                buildButtonView()
                                    .padding(.top, BankingTheme.dimens.medium)
                                    .padding(.bottom, BankingTheme.dimens.large)
                            }
                        }
                    )
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, BankingTheme.dimens.medium)
                .background(GeometryReader {
                    Color.clear.preference(key: ViewHeightKey.self,
                                            value: $0.size.height)
                })
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}
