public struct CellCheckboxView: View {
    let primaryLabel: String
    let secondaryLabel: String?
    @Binding var isChecked: Bool  // Tracks checked state
    @Binding var state: CheckboxState  // Tracks disabled/error/default state
    let action: () -> Void
    let style: CheckboxStyle

    public init(
        primaryLabel: String,
        secondaryLabel: String? = nil,
        isChecked: Binding<Bool>,
        state: Binding<CheckboxState> = .constant(.default),
        style: CheckboxStyle = .compact,
        action: @escaping () -> Void
    ) {
        self.primaryLabel = primaryLabel
        self.secondaryLabel = secondaryLabel
        self._isChecked = isChecked
        self._state = state
        self.style = style
        self.action = action
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: BankingTheme.spacing.noPadding) {
            contentView
        }
        .padding(BankingTheme.dimensions.medium)
        .background(style == .boxed ? state.backgroundColor(isChecked: isChecked) : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: BankingTheme.dimensions.smallMedium))
        .overlay(style == .boxed ? borderOverlay : nil)
    }

    @ViewBuilder
    private var contentView: some View {
        HStack(alignment: .top, spacing: BankingTheme.dimensions.smallMedium) {
            CheckboxView(isChecked: $isChecked, state: $state, action: action)
            
            VStack(spacing: BankingTheme.dimensions.small) {
                Text(primaryLabel)
                    .modifier(LabelStyle(
                        typography: BankingTheme.typography.bodySemiBold,
                        color: state.textColor(isChecked: isChecked)
                    ))

                secondaryLabel.map {
                    Text($0)
                        .modifier(LabelStyle(
                            typography: BankingTheme.typography.bodySmall,
                            color: state.textColor(isChecked: isChecked)
                        ))
                }
            }
        }
    }

    @ViewBuilder
    private var borderOverlay: some View {
        if style == .boxed {
            RoundedRectangle(cornerRadius: BankingTheme.dimensions.smallMedium)
                .strokeBorder(
                    state.borderColor(isChecked: isChecked),
                    lineWidth: isChecked ? BankingTheme.spacing.stroke * 2 : BankingTheme.spacing.stroke
                )
        }
    }
}


public struct CheckboxView: View {
    @Binding var isChecked: Bool
    @Binding var state: CheckboxState
    let action: () -> Void

    public var body: some View {
        Button {
            if state != .disabled {  // Prevent interaction when disabled
                isChecked.toggle()
                action()
            }
        } label: {
            componentImage()
        }
        .disabled(state == .disabled)
        .opacity(state == .disabled ? 0.5 : 1.0)
    }

    @ViewBuilder
    private func componentImage() -> some View {
        ComponentImage(state.icon(isChecked: isChecked))
            .frame(width: BankingTheme.spacing.smallIconSize, height: BankingTheme.spacing.smallIconSize)
            .cornerRadius(BankingTheme.dimensions.microSmall)
    }
}


public enum CheckboxState {
    case `default`, disabled, error
}

extension CheckboxState {
    
    /// Returns the correct border color based on `isChecked` state.
    func borderColor(isChecked: Bool) -> Color {
        switch self {
        case .default: return isChecked ? BankingTheme.colors.textPrimary : BankingTheme.colors.textSecondary
        case .disabled: return BankingTheme.colors.disabled
        case .error: return BankingTheme.colors.error
        }
    }
    
    /// Returns the correct background color based on `isChecked` state.
    func backgroundColor(isChecked: Bool) -> Color {
        switch self {
        case .default: return isChecked ? BankingTheme.colors.surface : Color.clear
        case .disabled: return BankingTheme.colors.surface.opacity(0.5)
        case .error: return isChecked ? BankingTheme.colors.errorContainer : Color.clear
        }
    }
    
    /// Returns the correct text color based on `isChecked` state.
    func textColor(isChecked: Bool) -> Color {
        switch self {
        case .default: return BankingTheme.colors.textPrimary
        case .disabled: return BankingTheme.colors.textSecondary.opacity(0.5)
        case .error: return BankingTheme.colors.error
        }
    }
    
    /// Returns the correct icon for checked/unchecked states.
    func icon(isChecked: Bool) -> ComponentIcon {
        switch self {
        case .default:
            return isChecked ? BankingTheme.icons.functional.checkedDefault : BankingTheme.icons.functional.uncheckedDefault
        case .disabled:
            return isChecked ? BankingTheme.icons.functional.checkedDisabled : BankingTheme.icons.functional.uncheckedDisabled
        case .error:
            return isChecked ? BankingTheme.icons.functional.checkedError : BankingTheme.icons.functional.uncheckedError
        }
    }
}
