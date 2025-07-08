
struct ManageAlertsAlertSettingsScreen: View {
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
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

                                Spacer(minLength: 0) // Ensures we can grow if needed

                                buildButtonView()
                                    .padding(.top, BankingTheme.dimens.medium)
                                    .padding(.bottom, BankingTheme.dimens.large)
                            }
                            .frame(minHeight: geometry.size.height) // <- Key part
                            .padding(.horizontal, BankingTheme.dimens.medium)
                        }
                    )
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}

