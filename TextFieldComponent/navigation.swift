struct UserIdRuleItem: Identifiable {
    let id: Int
    let message: String
    let status: ValidationStatus
}

enum ValidationStatus {
    case initial
    case valid
    case invalid
}


import SwiftUI

struct UserIdRuleRow: View {
    let rule: UserIdRuleItem

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: iconName)
                .foregroundColor(iconColor)
            Text(rule.message)
                .font(.body)
                .foregroundColor(.primary)
        }
    }

    private var iconName: String {
        switch rule.status {
        case .valid: return "checkmark.circle.fill"
        case .invalid: return "xmark.octagon.fill"
        case .initial: return "circle"
        }
    }

    private var iconColor: Color {
        switch rule.status {
        case .valid: return .green
        case .invalid: return .red
        case .initial: return .gray
        }
    }
}

struct UserIdRulesSection: View {
    let rules: [UserIdRuleItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(rules) { rule in
                UserIdRuleRow(rule: rule)
            }
        }
    }
}


UserIdRulesSection(rules: [
    UserIdRuleItem(id: 1, message: "Between 8 and 32 characters", status: .valid),
    UserIdRuleItem(id: 2, message: "At least 2 letters and 2 numbers", status: .initial),
    UserIdRuleItem(id: 3, message: "No invalid characters (',\\,>,<)", status: .invalid)
])

func mapToUserIdRuleItems(_ results: [ValidationResult]) -> [UserIdRuleItem] {
    return results.map {
        UserIdRuleItem(
            id: Int($0.ruleId),
            message: $0.message,
            status: mapStatus($0.status)
        )
    }
}

private func mapStatus(_ sharedStatus: ValidationStatus) -> ValidationStatus {
    switch sharedStatus {
    case .initial: return .initial
    case .valid: return .valid
    case .invalid: return .invalid
    @unknown default: return .initial // safe fallback
    }
}

let uiRules = mapToUserIdRuleItems(presenter.validationChecks)
UserIdRulesSection(rules: uiRules)
