import SwiftUI
import Theme

public struct CellCheckboxView: View {
    let primaryLabel: String
    let secondaryLabel: String?
    @Binding var state: CheckboxState
    let action: () -> Void
    let style: CheckboxStyle  // New property for boxed vs compact

    public init(
        primaryLabel: String,
        secondaryLabel: String? = nil,
        state: Binding<CheckboxState> = .constant(.default),
        style: CheckboxStyle = .compact,  // Default to compact
        action: @escaping () -> Void
    ) {
        self.primaryLabel = primaryLabel
        self.secondaryLabel = secondaryLabel
        self._state = state
        self.style = style
        self.action = action
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: BankingTheme.spacing.noPadding) {
            contentView
        }
        .padding(BankingTheme.dimensions.medium)
        .background(style == .boxed ? state.backgroundColor : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: BankingTheme.dimensions.smallMedium))
        .overlay(style == .boxed ? borderOverlay : nil)
    }

    @ViewBuilder
    private var contentView: some View {
        HStack(alignment: .top, spacing: BankingTheme.dimensions.smallMedium) {
            CheckboxView(isChecked: isChecked, state: $state, action: action)
            
            VStack(spacing: BankingTheme.dimensions.small) {
                Text(primaryLabel)
                    .modifier(LabelStyle(
                        typography: BankingTheme.typography.bodySemiBold,
                        color: state == .disabled ? BankingTheme.colors.textSecondary.opacity(0.5) : BankingTheme.colors.textPrimary
                    ))

                secondaryLabel.map {
                    Text($0)
                        .modifier(LabelStyle(
                            typography: BankingTheme.typography.bodySmall,
                            color: state == .disabled ? BankingTheme.colors.textSecondary.opacity(0.5) : BankingTheme.colors.textSecondary
                        ))
                }
            }
        }
    }

    private var isChecked: Bool {
        state == .default
    }

    @ViewBuilder
    private var borderOverlay: some View {
        if style == .boxed {
            RoundedRectangle(cornerRadius: BankingTheme.dimensions.smallMedium)
                .strokeBorder(
                    isChecked ? state.borderColor : state.uncheckedBorderColor,
                    lineWidth: isChecked ? BankingTheme.spacing.stroke * 2 : BankingTheme.spacing.stroke
                )
        }
    }
}


enum CheckboxStyle {
    case compact
    case boxed
}
