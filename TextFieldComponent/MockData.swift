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

/// Extension for AccountSectionData to map its data to AccountSectionFieldData
extension AccountSectionData {
    
    /// Maps the section items to `AccountSectionFieldData`
    ///
    /// - Returns: An `AccountSectionFieldData` object containing the title and mapped data for each section item.
    func toAccountSectionFieldData() -> AccountSectionFieldData {
        // Map section items to ListCellItemData
        let mappedData = sectionItems.map { sectionItem in
            ListCellItemData(
                actionCellId: sectionItem.primaryText,
                actionPrimaryLabel: sectionItem.primaryText,
                actionSecondaryLabel: nil,
                leadingIconName: nil,
                trailingIconName: sectionItem.primaryText == "Account number" || sectionItem.primaryText == "ABA routing number" ? ComponentConstants.Images.passwordShownIcon : nil,
                leadingIconAccessibilityText: nil,
                trailingIconAccessibilityText: nil,
                actionCount: nil,
                data: sectionItem.secondaryText,
                role: nil,
                shouldToggleDataVisibility: sectionItem.primaryText == "Account number" || sectionItem.primaryText == "ABA routing number" ? true : false
            )
        }
        
        // Return AccountSectionFieldData with the mapped data and header text
        return AccountSectionFieldData(
            title: headerText,
            data: mappedData
        )
    }
}


/// View struct for displaying the account details screen
public struct AccountDetailsScreen: View {
    
    /// The view model for managing the account details view
    @State private var viewModel: AccountDetailsViewModel
    
    /// Observable model state for tracking resource and UI state
    @ObservedObject private var model: ObservableModelState<AccountDetailsResourceUiState, AccountDetailsUiState>
    
    /// The currently selected tab index for the secondary tab bar
    @State private var selectedTabIndex: Int = 0

    let sectionMarginSm: CGFloat = 32.0

    /// Initializes the view with the provided view model, defaulting to dependency injection via Koin.
    public init(viewModel: AccountDetailsViewModel = KoinApplication.inject()) {
        self.viewModel = viewModel
        self.model = ObservableModelState(
            resourcePublisher: asPublisher(viewModel.resourceStateWrapped),
            statePublisher: asPublisher(viewModel.accountDetailsStateWrapped)
        )
    }

    /// The body of the view containing the account details content and loading layout.
    public var body: some View {
        ResourceLoadingLayout(
            resource: model.resource,
            state: model.state
        ) {
            contentView()
        }
        .onAppear {
            viewModel.attachViewModel(navigator: AccountDetailsPageNavigatorImpl())
            viewModel.getAccountDetails()
            viewModel.fetchAccountDetailsPageContent()
        }
    }
}

// MARK: - Subviews
extension AccountDetailsScreen {
    
    /// ViewBuilder function to render the main content view.
    @ViewBuilder
    private func contentView() -> some View {
        VStack(spacing: BankingTheme.spacing.noPadding) {
            // Render the account header if available
            if let accountHeaderData = getAccountHeaderData() {
                renderAccountHeaderView(accountHeaderData: accountHeaderData)
                    .padding(.bottom, sectionMarginSm)
            }

            // Secondary tab bar for switching between sections
            SecondaryTabBar(
                tabs: ["Account Info"],
                selectedTabIndex: $selectedTabIndex,
                isScrollable: false,
                hasBorder: false,
                isRoundedShape: true
            ) { index in
                // Handle tab switching if needed
            }

            // Render the account sections if available
            if let accountSections = getAccountSections() {
                AccountSectionListView(accountSections: accountSections)
            }
            .padding(.horizontal, BankingTheme.dimens.medium)
            .padding(.top, sectionMarginSm)
            .padding(.bottom, sectionMarginSm)
        }
    }
}

// MARK: - Helpers
extension AccountDetailsScreen {
    
    /// Helper function to retrieve the account sections.
    ///
    /// - Returns: An array of `AccountSectionFieldData` containing the account sections data.
    private func getAccountSections() -> [AccountSectionFieldData]? {
        return model.state?.accountDetailsData.flatMap {
            let accountInformationPresenter = viewModel.createAccountInformationPresenter(account: $0.accountDetails)
            return accountInformationPresenter.mapToAccountSectionsFieldData()
        }
    }

    /// Helper function to retrieve the account header data.
    ///
    /// - Returns: The header data for the account, if available.
    private func getAccountHeaderData() -> Any? {
        return model.state?.accountDetailsData.flatMap {
            let accountDetailsHeaderPresenter = viewModel.createAccountDetailsHeaderPresenter(account: $0.accountDetails)
            if let depositAccountHeaderPresenter = accountDetailsHeaderPresenter as? DepositAccountHeaderPresenter {
                return depositAccountHeaderPresenter.toDebitBalanceAccountHeaderData()
            } else if let certificateDepositAccountHeaderPresenter = accountDetailsHeaderPresenter as? CertificateDepositAccountHeaderPresenter {
                return certificateDepositAccountHeaderPresenter.toAccountHeaderData()
            } else if let loanAccountHeaderPresenter = accountDetailsHeaderPresenter as? LoanAccountHeaderPresenter {
                return loanAccountHeaderPresenter.toAccountHeaderData()
            }
            return nil
        }
    }
}

// MARK: - ViewBuilders
extension AccountDetailsScreen {
    
    /// ViewBuilder function to render the appropriate account header view.
    ///
    /// - Parameter accountHeaderData: The data used to render the header view.
    /// - Returns: A view displaying the account header, based on the data type.
    @ViewBuilder
    private func renderAccountHeaderView(accountHeaderData: Any) -> some View {
        // Check for specific account header data type and render the correct view
        if let debitBalanceHeaderData = accountHeaderData as? DebitBalanceAccountHeaderData {
            CardAccountHeader(debitBalanceAccountHeaderData: debitBalanceHeaderData)
        } else if let dataListHeaderData = accountHeaderData as? AccountHeaderData {
            DataListAccountHeader(accountHeaderData: dataListHeaderData)
        }
    }
}


/// View struct for displaying account information and managing section details
struct AccountInformation: View {
    let tabs: [String] // The tabs for the secondary tab bar
    let presenter: AccountInformationPresenter // Presenter managing account information

    /// State to track the currently selected tab in the tab bar
    @State private var selectedTabIndex: Int = 0

    /// State to hold the list of account section items
    @State private var accountSectionList: [AccountSectionItemData] = []

    /// Initializes the view with the given tabs and presenter
    init(tabs: [String], presenter: AccountInformationPresenter) {
        self.tabs = tabs
        self.presenter = presenter
    }

    /// The body of the view containing the tab bar and account sections
    var body: some View {
        VStack(spacing: BankingTheme.spacing.noPadding) {
            // Secondary tab bar for switching between sections
            SecondaryTabBar(
                tabs: tabs,
                selectedTabIndex: $selectedTabIndex,
                isScrollable: false,
                hasBorder: false,
                isRoundedShape: true
            ) { index in
                // Handle tab switching if needed
            }

            // If the account section is available, render the section details
            if let accountSection = presenter.mapToAccountSection() {
                SectionDetails(
                    header: accountSection.title,
                    sectionData: accountSectionList.isEmpty ? accountSection.data : AccountSectionItemData.toListCellItemDataList(from: accountSectionList),
                    onClick: { primaryText in
                        handleOnClick(primaryText: primaryText)
                    }
                )
            }

            // Build and render any additional sections
            let buildSections = presenter.mapToBuildSections()
            ForEach(buildSections, id: \.title) { buildSection in
                SectionDetails(
                    header: buildSection.title,
                    sectionData: buildSection.data
                )
            }
        }
        .onAppear {
            // Set the account section list when the view appears
            accountSectionList = presenter.buildAccountSection().sectionItems
        }
    }
}

// MARK: - Helpers
extension AccountInformation {
    
    /// Handles the onClick action for a section item
    ///
    /// - Parameter primaryText: The primary text of the clicked section item
    private func handleOnClick(primaryText: String) {
        // Update accountSectionList based on the presenter's toggle state
        if let depositAccountPresenter = presenter as? DepositAccountInformationPresenter {
            accountSectionList = depositAccountPresenter.toggleMaskStateAccountDetails(
                primaryText: primaryText,
                data: accountSectionList
            ) ?? []
        }
    }
}


// Extension for AccountSectionItemData for mapping functionality
extension AccountSectionItemData {
    
    /// Maps an array of `AccountSectionItemData` to an array of `ListCellItemData`
    ///
    /// - Parameter items: The array of `AccountSectionItemData` to be mapped
    /// - Returns: An array of `ListCellItemData`, or an empty array if no data is present
    static func toListCellItemDataList(from items: [AccountSectionItemData]) -> [ListCellItemData] {
        return items.map { sectionItem in
            ListCellItemData(
                actionCellId: sectionItem.primaryText,
                actionPrimaryLabel: sectionItem.primaryText,
                actionSecondaryLabel: sectionItem.secondaryText,
                trailingIconName: sectionItem.showIcon ?
                    (sectionItem.isMasked ? ComponentConstants.Images.passwordHiddenIcon : ComponentConstants.Images.passwordShownIcon)
                    : nil,
                data: sectionItem.secondaryText
            )
        }
    }
}


/// View struct for displaying section details, including a list of items and their actions
struct SectionDetails: View {
    let header: String // The header/title of the section
    let sectionData: [ListCellItemData] // The data for each item in the section
    let onClick: (String) -> Void // The action to be performed when an item is clicked

    /// Initializes the view with the given header, section data, and onClick action
    init(
        header: String,
        sectionData: [ListCellItemData],
        onClick: @escaping (String) -> Void = { _ in }
    ) {
        self.header = header
        self.sectionData = sectionData
        self.onClick = onClick
    }

    /// The body of the view, displaying the section header and its items
    var body: some View {
        VStack(alignment: .leading, spacing: BankingTheme.spacing.noPadding) {
            // Section header displaying the title of the section
            SectionHeaderView(title: header)

            // Card-like container for each section
            ListCardContainer(
                hasBorder: true,
                isRoundedShape: true,
                horizontalPadding: BankingTheme.dimens.smallMedium + BankingTheme.dimens.medium,
                verticalPadding: BankingTheme.dimens.microSmall
            ) {
                // Loop through each data item in the section
                ForEach(sectionData, id: \.actionCellId) { listItem in
                    let isDividerVisible = listItem != sectionData.last
                    ListCellItemText(
                        pressedBackgroundColor: BankingTheme.colors.surfaceVariant,
                        listCellItemData: listItem,
                        showDivider: isDividerVisible,
                        dataTextStyle: BankingTheme.typography.body,
                        onClick: { selectedItem in
                            // Call the onClick action when an item is clicked
                            onClick(selectedItem.actionPrimaryLabel)
                        }
                    )
                }
            }
        }
    }
}

/// ViewBuilder function to display a section header
///
/// - Parameter title: The title of the section
@ViewBuilder
private func SectionHeaderView(title: String) -> some View {
    HStack(alignment: .top, spacing: BankingTheme.spacing.noPadding) {
        // Uppercase title with custom styling
        Text(title.uppercased())
            .font(BankingTheme.typography.allCapsHeading.font)
            .foregroundColor(BankingTheme.colors.textPrimary)
            .frame(maxWidth: .infinity, alignment: .topLeading)
    }
    // Set padding around the header
    .padding(.horizontal, BankingTheme.spacing.noPadding)
    .padding(.top, Constants.paddingLg)
    .padding(.bottom, BankingTheme.dimens.smallMedium)
    .frame(maxWidth: .infinity, alignment: .topLeading)
}

// Constants for the header view layout
private enum Constants {
    static let paddingLg: CGFloat = 32.0
}


// MARK: - Helpers
extension AccountDetailsScreen {

    /// Creates an instance of `AccountInformationPresenter` if available
    ///
    /// - Returns: An optional `AccountInformationPresenter`
    private func createAccountInformationPresenter() -> AccountInformationPresenter? {
        return model.state?.accountDetailsData.flatMap {
            let accountInformationPresenter = viewModel.createAccountInformationPresenter(account: $0.accountDetails)
            return accountInformationPresenter
        }
    }

    /// Creates an instance of `AccountDetailsPresenter` if available
    ///
    /// - Returns: An optional `AccountDetailsPresenter`
    private func createAccountDetailsPresenter() -> AccountDetailsPresenter? {
        return model.state?.accountDetailsData.flatMap {
            let accountDetailsPresenter = viewModel.createAccountDetailsPresenter(account: $0.accountDetails)
            return accountDetailsPresenter
        }
    }

    /// Creates an instance of `AccountDetailsHeaderPresenter` if available
    ///
    /// - Returns: An optional `AccountDetailsHeaderPresenter`
    private func createAccountDetailsHeaderPresenter() -> AccountDetailsHeaderPresenter? {
        return model.state?.accountDetailsData.flatMap {
            let accountDetailsHeaderPresenter = viewModel.createAccountDetailsHeaderPresenter(account: $0.accountDetails)
            return accountDetailsHeaderPresenter
        }
    }
}


// MARK: - ViewBuilders
extension AccountDetailsScreen {

    /// A ViewBuilder function that renders the appropriate account header based on the presenter type
    ///
    /// - Parameter presenter: The presenter used to generate the account header view
    /// - Returns: A view displaying the account header for the appropriate account type
    @ViewBuilder
    private func AccountDetailsHeader(presenter: AccountDetailsHeaderPresenter) -> some View {
        // If the presenter is for a deposit account, render the card account header
        if let depositAccountHeaderPresenter = presenter as? DepositAccountHeaderPresenter {
            CardAccountHeader(
                debitBalanceAccountHeaderData: depositAccountHeaderPresenter.toDebitBalanceAccountHeaderData()
            )
        // If the presenter is for a certificate deposit account, render the data list account header
        } else if let certificateDepositAccountHeaderPresenter = presenter as? CertificateDepositAccountHeaderPresenter {
            DataListAccountHeader(
                accountHeaderData: certificateDepositAccountHeaderPresenter.toAccountHeaderData()
            )
        // If the presenter is for a loan account, render the data list account header
        } else if let loanAccountHeaderPresenter = presenter as? LoanAccountHeaderPresenter {
            DataListAccountHeader(
                accountHeaderData: loanAccountHeaderPresenter.toAccountHeaderData()
            )
        }
    }
}
