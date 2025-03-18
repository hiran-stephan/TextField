import SwiftUI
import Theme

// MARK: - CellCheckboxView
public struct CellCheckboxView: View {
    let primaryLabel: String
    let secondaryLabel: String?
    @Binding var state: CheckboxState
    let action: () -> Void
    
    public init(
        primaryLabel: String,
        secondaryLabel: String? = nil,
        state: Binding<CheckboxState> = .constant(.default),
        action: @escaping () -> Void
    ) {
        self.primaryLabel = primaryLabel
        self.secondaryLabel = secondaryLabel
        self._state = state
        self.action = action
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: BankingTheme.spacing.noPadding) {
            contentView
        }
        .padding(BankingTheme.dimensions.medium)
        .background(state.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: BankingTheme.dimensions.smallMedium))
        .overlay(borderOverlay)
    }

    @ViewBuilder
    private var contentView: some View {
        HStack(alignment: .top, spacing: BankingTheme.dimensions.smallMedium) {
            CheckboxView(isChecked: isChecked, state: $state, action: action)
            VStack(spacing: BankingTheme.dimensions.small) {
                Text(primaryLabel)
                    .modifier(LabelStyle(
                        typography: BankingTheme.typography.bodySemiBold,
                        color: BankingTheme.colors.textPrimary
                    ))

                secondaryLabel.map {
                    Text($0)
                        .modifier(LabelStyle(
                            typography: BankingTheme.typography.bodySmall,
                            color: BankingTheme.colors.textSecondary
                        ))
                }
            }
        }
    }
    
    private var isChecked: Bool {
        state == .default // Adjust based on business logic
    }

    @ViewBuilder
    private var borderOverlay: some View {
        RoundedRectangle(cornerRadius: BankingTheme.dimensions.smallMedium)
            .strokeBorder(
                isChecked ? state.borderColor : state.uncheckedBorderColor,
                lineWidth: isChecked ? BankingTheme.spacing.stroke * 2 : BankingTheme.spacing.stroke
            )
    }
}

// MARK: - CheckboxView
public struct CheckboxView: View {
    @Binding var isChecked: Bool
    @Binding var state: CheckboxState
    let action: (() -> Void)?

    public init(
        isChecked: Bool,
        state: Binding<CheckboxState> = .constant(.default),
        action: (() -> Void)? = nil
    ) {
        self._isChecked = .constant(isChecked)
        self._state = state
        self.action = action
    }

    public var body: some View {
        Button(action: action ?? {}, label: { componentImage() })
            .disabled(state == .disabled)
    }

    @ViewBuilder
    private func componentImage() -> some View {
        ComponentImage(isChecked ? state.checkedImageName : state.uncheckedImageName)
            .frame(width: BankingTheme.spacing.smallIconSize, height: BankingTheme.spacing.smallIconSize)
            .cornerRadius(BankingTheme.dimensions.microSmall)
    }
}

// MARK: - Extensions for CheckboxState
public enum CheckboxState {
    case `default`, disabled, error
}

extension CheckboxState {
    var borderColor: Color {
        switch self {
        case .default: BankingTheme.colors.textSecondary
        case .disabled: BankingTheme.colors.disabled
        case .error: BankingTheme.colors.error
        }
    }

    var uncheckedBorderColor: Color {
        switch self {
        case .default: BankingTheme.colors.textPrimary
        case .disabled: BankingTheme.colors.disabled
        case .error: BankingTheme.colors.error
        }
    }

    var backgroundColor: Color {
        switch self {
        case .default: BankingTheme.colors.surface
        case .disabled: BankingTheme.colors.surface
        case .error: BankingTheme.colors.errorContainer
        }
    }

    var checkedImageName: ComponentIcon {
        switch self {
        case .default: BankingTheme.icons.functional.checkedDefault
        case .disabled: BankingTheme.icons.functional.checkedDisabled
        case .error: BankingTheme.icons.functional.checkedError
        }
    }

    var uncheckedImageName: ComponentIcon {
        switch self {
        case .default: BankingTheme.icons.functional.uncheckedDefault
        case .disabled: BankingTheme.icons.functional.uncheckedDisabled
        case .error: BankingTheme.icons.functional.uncheckedError
        }
    }
}

// MARK: - View Modifier for Text Styling
struct LabelStyle: ViewModifier {
    var typography: Font
    var color: Color

    func body(content: Content) -> some View {
        content
            .font(typography)
            .foregroundColor(color)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}
