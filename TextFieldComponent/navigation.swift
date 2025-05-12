extension CriteriaCheckStatus {
    init(status: ValidationStatus) {
        switch status.name {
        case "VALID": self = .valid
        case "INVALID": self = .invalid
        case "UNKNOWN": self = .unknown
        default: self = .unknown
        }
    }
}

extension ChangeUserIdValidationPresenter {
    func toCriteriaCheckModels() -> [CriteriaCheckModel] {
        return validationResults.map { result in
            CriteriaCheckModel(
                id: Int(result.ruleId),
                message: result.message,
                status: CriteriaCheckStatus(status: result.status),
                accessibilityText: result.accessibilityText
            )
        }
    }
}

val validationResults: List<ValidationResult>
    get() {
        val trimmedUserId = userId.trim()
        return validationRules.map { rule ->
            val status = when {
                trimmedUserId.isEmpty() -> ValidationStatus.UNKNOWN
                rule.isValid(trimmedUserId) == true -> ValidationStatus.VALID
                else -> ValidationStatus.INVALID
            }

            ValidationResult(
                ruleId = rule.id,
                status = status,
                message = rule.message,
                accessibilityText = getAccessibilityTextFor(status)
            )
        }
    }

import SwiftUI

struct AccessibleListContainer<Content: View>: View {
    let accessibilityLabel: String
    let content: () -> Content

    var body: some View {
        Group {
            content()
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(accessibilityLabel)
    }
}

AccessibleListContainer(accessibilityLabel: accessibilityText ?? "") {
    ForEach(checks) { check in
        CriteriaCheckView(model: check)
    }
}
