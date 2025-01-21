public extension View {
    // MARK: - Error Content View
    func errorContentView(
        imageName: String,
        title: String,
        subtitle: String? = nil,
        message: String,
        actionLabel: String? = nil,
        callback: @escaping () -> Void
    ) -> some View {
        EmptyState(
            style: DefaultEmptyStateStyle(),
            imageView: {
                emptyStateImage(imageName: imageName)
            },
            contentView: {
                errorContentText(title: title, subtitle: subtitle, message: message)
            },
            actionView: {
                if let actionLabel = actionLabel {
                    emptyStateActionButton(actionLabel: actionLabel, callback: callback)
                }
            }
        )
    }

    // MARK: - Empty State View
    func emptyStateView(
        imageName: String,
        title: String,
        message: String,
        actionLabel: String? = nil,
        callback: @escaping () -> Void
    ) -> some View {
        EmptyState(
            style: PlainEmptyStateStyle(),
            imageView: {
                emptyStateImage(imageName: imageName)
            },
            contentView: {
                emptyStateText(title: title, message: message)
            },
            actionView: {
                if let actionLabel = actionLabel {
                    emptyStateActionButton(actionLabel: actionLabel, callback: callback)
                }
            }
        )
    }
}

private extension View {
    // MARK: - Helper Methods

    /// Creates the image for the empty state
    func emptyStateImage(imageName: String) -> some View {
        StyledImageView<PlainImageViewStyle>(
            image: ComponentImage(imageName),
            style: PlainImageViewStyle()
        )
        .padding(.vertical, BankingTheme.dimens.large)
    }

    /// Creates the text content for the error state
    func errorContentText(title: String, subtitle: String?, message: String) -> some View {
        VStack(alignment: .center, spacing: BankingTheme.spacing.noPadding) {
            Text(title)
                .typography(BankingTheme.typography.headingLarge)
                .multilineTextAlignment(.center)
                .foregroundColor(BankingTheme.colors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .top)

            if let subtitle = subtitle {
                Text(subtitle)
                    .typography(BankingTheme.typography.caption)
                    .multilineTextAlignment(.center)
                    .foregroundColor(BankingTheme.colors.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .top)
            }

            Text(message)
                .typography(BankingTheme.typography.bodySmall)
                .multilineTextAlignment(.center)
                .foregroundColor(BankingTheme.colors.textSecondary)
                .frame(maxWidth: .infinity, alignment: .top)
        }
    }

    /// Creates the text content for a simple empty state
    func emptyStateText(title: String, message: String) -> some View {
        VStack(alignment: .center, spacing: BankingTheme.spacing.noPadding) {
            Text(title)
                .typography(BankingTheme.typography.headingLarge)
                .multilineTextAlignment(.center)
                .foregroundColor(BankingTheme.colors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .top)

            Text(message)
                .typography(BankingTheme.typography.bodySmall)
                .multilineTextAlignment(.center)
                .foregroundColor(BankingTheme.colors.textSecondary)
                .frame(maxWidth: .infinity, alignment: .top)
        }
    }

    /// Creates the action button for the empty state
    func emptyStateActionButton(actionLabel: String, callback: @escaping () -> Void) -> some View {
        PrimaryButton(
            content: { Text(actionLabel) },
            callback: callback
        )
        .frame(maxWidth: .infinity, alignment: .top)
        .padding(.top, BankingTheme.dimens.mediumLarge)
    }
}
