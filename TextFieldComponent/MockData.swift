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


extension AccountDetailsHeaderPresenter {
    func toAccountHeaderData() -> Any {
        if hasCard() {
            // Map to DebitBalanceAccountHeaderData
            return DebitBalanceAccountHeaderData(
                balanceLabelText: balanceLabelText(),
                formattedBalance: formatBalance(),
                availableBalanceLabel: "Available Balance", // Adjust based on your data structure
                formattedAvailableBalance: formatAvailableBalance(),
                maskedAccountNumber: formatAccountNumber()
            )
        } else {
            // Map to AccountHeaderData
            return AccountHeaderData(
                balanceLabelText: balanceLabelText(),
                formattedBalance: formatBalance(),
                dataList: dataList()?.map { (key, value) in
                    return "\(key): \(value)"
                } ?? []
            )
        }
    }
}


let presenter: AccountDetailsHeaderPresenter = // Get your presenter
let accountHeaderData = presenter.toAccountHeaderData()

if let debitHeader = accountHeaderData as? DebitBalanceAccountHeaderData {
    // Handle DebitBalanceAccountHeaderData
} else if let accountHeader = accountHeaderData as? AccountHeaderData {
    // Handle AccountHeaderData
}



protocol AccountHeaderMappable {
    func toAccountHeaderData() -> AccountHeaderData
}

protocol DebitBalanceAccountHeaderMappable: AccountHeaderMappable {
    func toDebitBalanceAccountHeaderData() -> DebitBalanceAccountHeaderData
}


extension DepositAccountHeaderPresenter: DebitBalanceAccountHeaderMappable {
    func toDebitBalanceAccountHeaderData() -> DebitBalanceAccountHeaderData {
        return DebitBalanceAccountHeaderData(
            balanceLabelText: balanceLabelText(),
            formattedBalance: formatBalance(),
            availableBalanceText: availableBalanceText(),
            formattedAvailableBalance: formatAvailableBalance(),
            maskedAccountNumber: formatAccountNumber()
        )
    }
    
    func toAccountHeaderData() -> AccountHeaderData {
        return AccountHeaderData(
            balanceLabelText: balanceLabelText(),
            formattedBalance: formatBalance(),
            dataList: dataList() ?? [:]
        )
    }
}

extension CertificateDepositAccountHeaderPresenter: AccountHeaderMappable {
    func toAccountHeaderData() -> AccountHeaderData {
        return AccountHeaderData(
            balanceLabelText: balanceLabelText(),
            formattedBalance: formatBalance(),
            dataList: dataList() ?? [:]
        )
    }
}

extension LoanAccountHeaderPresenter: AccountHeaderMappable {
    func toAccountHeaderData() -> AccountHeaderData {
        return AccountHeaderData(
            balanceLabelText: balanceLabelText(),
            formattedBalance: formatBalance(),
            dataList: dataList() ?? [:]
        )
    }
}

func configureUI(with presenter: AccountDetailsHeaderPresenter) {
    if let debitMappable = presenter as? DebitBalanceAccountHeaderMappable {
        let uiModel = debitMappable.toDebitBalanceAccountHeaderData()
        // Use `uiModel` for DebitBalanceAccountHeaderData
    } else if let mappable = presenter as? AccountHeaderMappable {
        let uiModel = mappable.toAccountHeaderData()
        // Use `uiModel` for AccountHeaderData
    }
}



extension AccountDetailsScreen {
    
    private func contentView() -> some View {
        VStack(spacing: BankingTheme.spacing.noPadding) {
            
            // Render the account header if available
            if let accountHeaderData = getAccountHeaderData() {
                renderAccountHeaderView(accountHeaderData: accountHeaderData)
                    .padding(.bottom, sectionMarginSm)
            }
            
            // Secondary tab bar
            SecondaryTabBar(
                tabs: ["Account Info"],
                selectedTabIndex: $selectedTabIndex,
                isScrollable: false,
                hasBorder: false,
                isRoundedShape: true
            )
            
            // Render account section view if available
            if let accountSections = getAccountSections() {
                AccountSectionListView(accountSections: accountSections)
                    .padding(.horizontal, BankingTheme.dimens.medium)
                    .padding(.top, sectionMarginSm)
                    .padding(.bottom, sectionMarginSm)
            } else {
                // Placeholder view for missing sections (optional improvement)
                Text("No account sections available.")
                    .foregroundColor(.gray)
                    .padding()
            }
        }
    }
    
    // Helper function to get AccountHeaderData
    private func getAccountHeaderData() -> AccountHeaderData? {
        return model.state?.accountDetailsData.flatMap {
            let accountDetailsHeaderPresenter = viewModel.createAccountDetailsHeaderPresenter(account: $0.accountDetails)
            
            // Check the presenter type and return the appropriate header data
            if let debitMappable = accountDetailsHeaderPresenter as? DebitBalanceAccountHeaderMappable {
                return debitMappable.toDebitBalanceAccountHeaderData()
            } else if let mappable = accountDetailsHeaderPresenter as? AccountHeaderMappable {
                return mappable.toAccountHeaderData()
            }
            return nil
        }
    }
    
    // Helper function to get AccountSections
    private func getAccountSections() -> [AccountSectionFieldData]? {
        return model.state?.accountDetailsData.flatMap {
            let accountInformationPresenter = viewModel.createAccountInformationPresenter(account: $0.accountDetails)
            return accountInformationPresenter.mapToAccountSectionsFieldData()
        }
    }
    
    // Helper function to render the appropriate header view
    @ViewBuilder
    private func renderAccountHeaderView(accountHeaderData: AccountHeaderData) -> some View {
        // Check for specific account header data type and render the correct view
        if let debitBalanceHeaderData = accountHeaderData as? DebitBalanceAccountHeaderData {
            CardAccountHeader(accountHeaderData: debitBalanceHeaderData)
        } else if let dataListHeaderData = accountHeaderData as? DataListAccountHeaderData {
            DataListAccountHeader(accountHeaderData: dataListHeaderData)
        } else {
            // Placeholder for unknown data types (optional improvement)
            Text("Unsupported header type.")
                .foregroundColor(.red)
                .padding()
        }
    }
}

/// Extension for DepositAccountHeaderPresenter to handle Debit Balance Account Header Data
extension DepositAccountHeaderPresenter {
    
    /// Converts the current presenter data to `DebitBalanceAccountHeaderData`
    ///
    /// - Returns: A `DebitBalanceAccountHeaderData` object containing formatted balance, available balance, and masked account number.
    func toDebitBalanceAccountHeaderData() -> DebitBalanceAccountHeaderData {
        return DebitBalanceAccountHeaderData(
            balanceLabelText: balanceLabelText(),
            formattedBalance: formatBalance(),
            availableBalanceText: availableBalanceText(),
            formattedAvailableBalance: formatAvailableBalance(),
            maskedAccountNumber: formatAccountNumber()
        )
    }
}

/// Extension for CertificateDepositAccountHeaderPresenter to handle Certificate Deposit Account Header Data
extension CertificateDepositAccountHeaderPresenter {
    
    /// Converts the current presenter data to `AccountHeaderData`
    ///
    /// - Returns: An `AccountHeaderData` object containing formatted balance and a list of data items.
    func toAccountHeaderData() -> AccountHeaderData {
        return AccountHeaderData(
            balanceLabelText: balanceLabelText(),
            formattedBalance: formatBalance(),
            dataList: dataList()
        )
    }
}

/// Extension for LoanAccountHeaderPresenter to handle Loan Account Header Data
extension LoanAccountHeaderPresenter {
    
    /// Converts the current presenter data to `AccountHeaderData`
    ///
    /// - Returns: An `AccountHeaderData` object containing formatted balance and a list of data items.
    func toAccountHeaderData() -> AccountHeaderData {
        return AccountHeaderData(
            balanceLabelText: balanceLabelText(),
            formattedBalance: formatBalance(),
            dataList: dataList()
        )
    }
}

/// Extension for AccountInformationPresenter to map account sections
extension AccountInformationPresenter {
    
    /// Maps the account sections to `AccountSectionFieldData`
    ///
    /// - Returns: An array of `AccountSectionFieldData` representing the combined sections of the account information.
    func mapToAccountSectionsFieldData() -> [AccountSectionFieldData] {
        var combinedSections: [AccountSectionFieldData] = []
        
        // Build and append the primary account section
        let accountSection = buildAccountSection()
        combinedSections.append(accountSection.toAccountSectionFieldData())
        
        // Build additional sections and map them to AccountSectionFieldData
        let buildSections = buildSections().compactMap { sectionData in
            if let sectionData = sectionData as? AccountSectionData {
                return sectionData.toAccountSectionFieldData()
            }
            return nil
        }
        
        // Append all the built sections to combinedSections
        combinedSections.append(contentsOf: buildSections)
        
        return combinedSections
    }
}
