enum ValidationStatus {
    case initial
    case valid
    case invalid
}

struct CriteriaCheckModel: Identifiable {
    let id: Int
    let message: String
    let status: ValidationStatus
}

struct CriteriaCheck: View {
    let model: CriteriaCheckModel

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: iconName)
                .resizable()
                .frame(width: 16, height: 16)
                .foregroundColor(iconColor)

            Text(model.message)
                .font(.body)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 4)
    }

    private var iconName: String {
        switch model.status {
        case .valid: return "checkmark.circle.fill"
        case .invalid: return "xmark.octagon.fill"
        case .initial: return "circle"
        }
    }

    private var iconColor: Color {
        switch model.status {
        case .valid: return .green
        case .invalid: return .red
        case .initial: return .gray
        }
    }
}


struct StandardCheck: View {
    let checks: [CriteriaCheckModel]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(checks) { check in
                CriteriaCheck(model: check)
            }
        }
        .padding(.vertical, 8) // corresponds to "Padding/2xs" or "4xs"
    }
}


func mapValidationResultsToChecks(_ results: [ValidationResult]) -> [CriteriaCheckModel] {
    return results.map {
        CriteriaCheckModel(
            id: Int($0.ruleId),
            message: $0.message,
            status: mapStatus($0.status)
        )
    }
}

func mapStatus(_ status: ValidationStatus) -> ValidationStatus {
    switch status {
    case .initial: return .initial
    case .valid: return .valid
    case .invalid: return .invalid
    }
}


StandardCheck(checks: mapValidationResultsToChecks(viewModel.validationChecks))



struct StandardCheck: View {
    let checks: [CriteriaCheckModel]
    let strengthState: PasswordStrengthState?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(checks) { check in
                CriteriaCheck(model: check)
            }

            if let strength = strengthState {
                PasswordStrengthView(strength: strength)
            }
        }
        .padding(.vertical, 8)
    }
}

struct PasswordStrengthView: View {
    let strength: PasswordStrengthState

    var body: some View {
        if !strength.description.isEmpty {
            Text("Strength: \(strength.description)")
                .font(.body.weight(.semibold))
                .foregroundColor(strength.color)
                .padding(.top, 8)
        }
    }
}

enum PasswordStrengthState {
    case blank
    case notAccepted
    case moderate
    case strong

    var description: String {
        switch self {
        case .blank: return ""
        case .notAccepted: return "Not acceptable"
        case .moderate: return "Moderate"
        case .strong: return "Strong"
        }
    }

    var color: Color {
        switch self {
        case .notAccepted: return .red
        case .moderate: return .orange
        case .strong: return .green
        case .blank: return .clear
        }
    }
}



Group {
    ForEach(checks) { check in
        CriteriaCheckView(model: check)
    }
}
.accessibilityElement(children: .contain)
.accessibilityLabel(accessibilityText ?? "")


fun ValidationStatus.toAccessibilityText(): String {
    return when (this) {
        ValidationStatus.VALID -> "Met"
        ValidationStatus.INVALID -> "Not met"
        ValidationStatus.INITIAL -> "Not yet met"
    }
}

ValidationResult(
    ruleId = it.id,
    status = ValidationStatus.INITIAL,
    message = it.message,
    accessibilityText = ValidationStatus.INITIAL.toAccessibilityText()
)


ValidationResult(
    ruleId = rule.id,
    status = status,
    message = rule.message,
    accessibilityText = status.toAccessibilityText()
)




