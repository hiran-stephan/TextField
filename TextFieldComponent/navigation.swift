let groupedConsents = self.model.state?.data?.groupedConsents ?? [:]

let sortedGroupedConsents = groupedConsents
    .map { ($0.key, $0.value) } // (String, [ConsentData])
    .sorted { lhs, rhs in
        let lhsType = lhs.1.first?.consentType ?? ""
        let rhsType = rhs.1.first?.consentType ?? ""
        return lhsType < rhsType
    }
