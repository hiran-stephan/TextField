//
//  MockData.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 10/10/24.
//

import Foundation

struct AccountHeaderMockData {
    let balanceLabelText: String
    let formattedBalance: String
    let dataList: [String: String]
    let hasCard: Bool
}

struct DepositAccountHeaderData {
    let availableBalanceLabelText: String
    let formattedAvailableBalance: String
    let formattedAccountNumber: String
}

struct CDAccountHeaderData {
    let interestRateLabelText: String
    let formattedInterestRate: String
    let interestYearToDateLabelText: String
    let formattedInterestYearToDate: String
    let maturityLabelText: String
    let formattedMaturityDate: String
}

struct LoanAccountHeaderData {
    let nextPaymentAmountLabelText: String
    let formattedNextPaymentAmount: String
    let nextPaymentDueLabelText: String
    let formattedNextPaymentDue: String
}

enum AccountType {
    case deposit(DepositAccountHeaderData)
    case cd(CDAccountHeaderData)
    case loan(LoanAccountHeaderData)
}

struct AccountHeaderPresenter {
    let commonData: AccountHeaderMockData
    let accountType: AccountType
}

// Example of combined mock data:

let depositData = DepositAccountHeaderData(
    availableBalanceLabelText: "Available Balance",
    formattedAvailableBalance: "$9,500.00",
    formattedAccountNumber: "****9876"
)

let cdData = CDAccountHeaderData(
    interestRateLabelText: "Interest Rate",
    formattedInterestRate: "2.50%",
    interestYearToDateLabelText: "Interest YTD",
    formattedInterestYearToDate: "$250.00",
    maturityLabelText: "Maturity Date",
    formattedMaturityDate: "Dec 31, 2025"
)

let loanData = LoanAccountHeaderData(
    nextPaymentAmountLabelText: "Next Payment",
    formattedNextPaymentAmount: "$1,200.00",
    nextPaymentDueLabelText: "Due Date",
    formattedNextPaymentDue: "Nov 15, 2024"
)

// Example for a deposit account:
let mockDepositAccountHeader = AccountHeaderPresenter(
    commonData: AccountHeaderMockData(
        balanceLabelText: "Deposit Account Balance",
        formattedBalance: "$10,000.00",
        dataList: ["Interest Rate": "1.25%", "Account Number": "****1234"],
        hasCard: true
    ),
    accountType: .deposit(depositData)
)

// Example for a CD account:
let mockCDAccountHeader = AccountHeaderPresenter(
    commonData: AccountHeaderMockData(
        balanceLabelText: "CD Account Balance",
        formattedBalance: "$15,000.00",
        dataList: ["Interest Rate": "2.50%", "Maturity Date": "2025-12-31"],
        hasCard: false
    ),
    accountType: .cd(cdData)
)

// Example for a loan account:
let mockLoanAccountHeader = AccountHeaderPresenter(
    commonData: AccountHeaderMockData(
        balanceLabelText: "Loan Balance",
        formattedBalance: "$50,000.00",
        dataList: ["Loan Type": "Mortgage", "Interest Rate": "3.75%"],
        hasCard: false
    ),
    accountType: .loan(loanData)
)


extension AccountInformationPresenter {

    func mapToAccountSectionsFieldData() -> [AccountSectionFieldData] {
        var combinedSections: [AccountSectionFieldData] = []
        
        // Assuming buildAccountSection() returns an AccountSectionData object
        if let accountSection = buildAccountSection() as? AccountSectionData {
            combinedSections.append(accountSection.toAccountSectionFieldData())
        }

        // Assuming buildSections() returns a list of optional AccountSectionData
        let buildSections = buildSections().compactMap { sectionData in
            if let sectionData = sectionData as? AccountSectionData {
                return sectionData.toAccountSectionFieldData()
            }
            return nil
        }
        combinedSections.append(contentsOf: buildSections)
        
        return combinedSections
    }
}


extension AccountSectionData {
    func toAccountSectionFieldData() -> AccountSectionFieldData {
        let mappedData = sectionItems.map { sectionItem in
            ListCellItemData(
                actionCellId: sectionItem.primaryText,
                actionPrimaryLabel: sectionItem.primaryText,
                actionSecondaryLabel: sectionItem.secondaryText,
                leadingIconName: nil,
                trailingIconName: nil,
                leadingIconAccessibilityText: nil,
                trailingIconAccessibilityText: nil,
                actionCount: nil,
                data: nil,
                route: nil,
                shouldToggleDataVisibility: false
            )
        }

        return AccountSectionFieldData(
            title: headerText,
            data: mappedData
        )
    }
}
