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

enum PasswordStrengthState {
    case notApplicable
    case notAcceptable
    case moderate
    case good

    var description: String {
        switch self {
        case .notApplicable: return "N/A"
        case .notAcceptable: return "Not acceptable"
        case .moderate: return "Moderate"
        case .good: return "Good"
        }
    }

    var color: Color {
        switch self {
        case .notAcceptable: return .red
        case .moderate: return .orange
        case .good: return .green
        default: return .gray
        }
    }
}

struct StandardCheck: View {
    let checks: [CriteriaCheckModel]
    let strengthState: PasswordStrengthState?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(checks) { check in
                CriteriaCheck(model: check)
            }

            if let strength = strengthState {
                Text("Strength: \(strength.description)")
                    .font(.body.weight(.semibold))
                    .foregroundColor(strength.color)
                    .padding(.top, 8)
            }
        }
        .padding(.vertical, 8)
    }
}


StandardCheck(
    checks: passwordRulesMapped,
    strengthState: .notAcceptable
)
