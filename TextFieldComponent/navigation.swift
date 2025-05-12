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
