import Foundation
import SwiftUI

// MARK: - Data Model

/// Represents an account with details such as balance, card information, payment information, and account type.
struct AccountDetailsCardData {
    /// Unique identifier for the account.
    let id: String
    
    /// The current balance of the account as a string.
    let currentBalance: String?
    
    /// The available balance of the account as a string.
    let availableBalance: String?
    
    /// Optional card details associated with the account.
    let cardDetails: CardDetails?
    
    /// Optional payment details for loan or installment accounts.
    let paymentDetails: PaymentDetails?
    
    /// Optional maturity date for accounts such as Certificate of Deposit.
    let maturityDate: Date?
    
    /// The type of account (deposit, loan, etc.).
    let accountType: AccountType

    /// Initializes an Account with default or provided values.
    init(id: String = UUID().uuidString,
         currentBalance: String? = nil,
         availableBalance: String? = nil,
         cardDetails: CardDetails? = nil,
         paymentDetails: PaymentDetails? = nil,
         maturityDate: Date? = nil,
         accountType: AccountType = .depositWithCard) {
        
        self.id = id
        self.currentBalance = currentBalance
        self.availableBalance = availableBalance
        self.cardDetails = cardDetails
        self.paymentDetails = paymentDetails
        self.maturityDate = maturityDate
        self.accountType = accountType
    }
}

/// Represents card details associated with an account.
struct CardDetails {
    /// The last four digits of the card number.
    let lastFourDigits: String

    /// Initializes card details with the last four digits.
    init(lastFourDigits: String = Constants.DefaultMaskedCardNumber) {
        self.lastFourDigits = lastFourDigits
    }
}

/// Represents payment details for loan or installment accounts.
struct PaymentDetails {
    /// The next payment amount due for the account, as a string.
    let nextPaymentAmount: String
    
    /// The next payment due date for the account.
    let nextPaymentDueDate: Date

    /// Initializes payment details with default values or provided values.
    init(nextPaymentAmount: String = Constants.DefaultBalance, nextPaymentDueDate: Date = Date()) {
        self.nextPaymentAmount = nextPaymentAmount
        self.nextPaymentDueDate = nextPaymentDueDate
    }
}

/// Enum representing the type of account (e.g., deposit, loan, certificate deposit).
enum AccountType {
    case depositWithCard
    case depositWithoutCard
    case loan
    case certificateDeposit
    case revolvingCredit
    case installment
}

// MARK: - ViewModel

/// ViewModel that manages and formats account data for display in a card view.
class AccountDetailsCardViewModel: ObservableObject {
    private let accountDetailsCardData: AccountDetailsCardData

    /// Initializes the ViewModel with an `Account`.
    init(accountDetailsCardData: AccountDetailsCardData) {
        self.accountDetailsCardData = accountDetailsCardData
    }

    /// The current balance formatted as a string for display.
    var formattedCurrentBalance: String? {
        return accountDetailsCardData.currentBalance
    }

    /// The available balance formatted as a string for display.
    var formattedAvailableBalance: String? {
        return accountDetailsCardData.availableBalance
    }

    /// The card number formatted as "**** XXXX" where `XXXX` is the last four digits of the card number.
    var formattedCardNumber: String? {
        if let card = accountDetailsCardData.cardDetails {
            return "**** \(card.lastFourDigits)"
        }
        return nil
    }

    /// The next payment details (amount and due date) formatted as a tuple.
    var formattedNextPaymentDetails: (String, String)? {
        if let payment = accountDetailsCardData.paymentDetails {
            let amount = payment.nextPaymentAmount
            let dueDate = AccountDetailsCardViewModel.dateFormatter.string(from: payment.nextPaymentDueDate)
            return (amount, dueDate)
        }
        return nil
    }

    /// The maturity date formatted as a string for display.
    var formattedMaturityDate: String? {
        if let maturityDate = accountDetailsCardData.maturityDate {
            return AccountDetailsCardViewModel.dateFormatter.string(from: maturityDate)
        }
        return nil
    }

    /// DateFormatter used to format dates for display.
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}

// MARK: - Views

/// A view representing the account details, displayed in either card or text style.
struct AccountDetailsCard: View {
    enum ViewType {
        case card
        case normal
    }

    /// The type of view to display (card or normal).
    var viewType: ViewType
    
    /// The ViewModel providing the account data.
    var viewModel: AccountDetailsCardViewModel
    
    /// Indicates whether the view should display an error state.
    var isError: Bool = false

    var body: some View {
        VStack {
            if viewType == .card {
                AccountDetailsCardStyleView(viewModel: viewModel)
            } else {
                AccountDetailsTextStyleView(viewModel: viewModel)
            }
        }
    }
}

/// A card-style view for displaying account details.
struct AccountDetailsCardStyleView: View {
    @ObservedObject var viewModel: AccountDetailsCardViewModel
    var isError: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: BankingTheme.dimens.smallMedium) {
            balanceSection
            availableBalanceSection
            cardNumberSection
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: BankingTheme.dimens.smallMedium)
                .fill(Constants.DefaultBackgroundColor)
        )
        .frame(width: Constants.DefaultCardWidth, height: Constants.DefaultCardHeight)
    }

    // MARK: - Sections

    /// Displays the balance section of the card.
    private var balanceSection: some View {
        VStack(alignment: .leading) {
            Text(isError ? Constants.DefaultBalanceLabel : Constants.DefaultBalanceLabel)
                .font(BankingTheme.typography.bodySmall.font)
                .foregroundColor(BankingTheme.colors.textReversed)
                .frame(maxWidth: .infinity, alignment: .topLeading)

            Text(isError ? Constants.DefaultBalance : viewModel.formattedCurrentBalance ?? Constants.DefaultBalance)
                .font(BankingTheme.typography.display.medium.font)
                .foregroundColor(BankingTheme.colors.textReversed)
                .frame(maxWidth: .infinity, alignment: .topLeading)
        }
    }

    /// Displays the available balance section of the card.
    private var availableBalanceSection: some View {
        HStack(alignment: .top, spacing: BankingTheme.dimens.microSmall) {
            VStack(alignment: .leading, spacing: BankingTheme.dimens.microSmall) {
                Text(isError ? Constants.DefaultAvailableBalanceLabel : Constants.DefaultAvailableBalanceLabel)
                    .font(BankingTheme.typography.bodySmall.font)
                    .foregroundColor(BankingTheme.colors.textReversed)

                Text(isError ? Constants.DefaultAvailableBalance : viewModel.formattedAvailableBalance ?? Constants.DefaultAvailableBalance)
                    .font(BankingTheme.typography.bodySemiBold.font)
                    .foregroundColor(BankingTheme.colors.textReversed)
            }
        }
    }

    /// Displays the card number section of the card.
    private var cardNumberSection: some View {
        HStack {
            Spacer()
            Text(isError ? Constants.DefaultMaskedCardNumber : viewModel.formattedCardNumber ?? Constants.DefaultMaskedCardNumber)
                .font(BankingTheme.typography.headingSmall.small.font)
                .foregroundColor(BankingTheme.colors.textReversed)
        }
    }
}

/// A text-style view for displaying account details.
struct AccountDetailsTextStyleView: View {
    @ObservedObject var viewModel: AccountDetailsCardViewModel

    var body: some View {
        VStack(alignment: .center, spacing: BankingTheme.dimens.smallMedium) {
            if let currentBalance = viewModel.formattedCurrentBalance {
                balanceView(label: Constants.DefaultBalanceLabel, value: currentBalance )
            }
            
            if let availableBalance = viewModel.formattedAvailableBalance {
                detailView(label: Constants.DefaultAvailableBalanceLabel, value: availableBalance)
            }

            if let maturityDate = viewModel.formattedMaturityDate {
                detailView(label: Constants.DefaultMaturityDateLabel, value: maturityDate)
            }

            if let paymentDetails = viewModel.formattedNextPaymentDetails {
                detailView(label: Constants.DefaultNextPaymentLabel, value: paymentDetails.0)
                detailView(label: Constants.DefaultNextPaymentDueDateLabel, value: paymentDetails.1)
            }
        }
        .padding(.horizontal, BankingTheme.dimens.large)
        .background(BankingTheme.colors.background)
        .cornerRadius(BankingTheme.dimens.smallMedium)
        .padding()
    }
    
    /// Displays the balance view in a text-style layout.
    private func balanceView(label: String, value: String) -> some View {
        VStack(alignment: .center, spacing: BankingTheme.dimens.microSmall) {
            Text(label)
                .font(BankingTheme.typography.bodySmall.font)
                .foregroundColor(BankingTheme.colors.textPrimary)

            Text(value)
                .font(BankingTheme.typography.display.medium.font)
                .foregroundColor(BankingTheme.colors.textPrimary)
        }
    }
    
    /// Displays a detail view with a label and value in a text-style layout.
    @ViewBuilder
    private func detailView(label: String, value: String) -> some View {
        VStack(alignment: .center, spacing: BankingTheme.dimens.microSmall) {
            Text(label)
                .font(BankingTheme.typography.bodySmall.font)
                .foregroundColor(BankingTheme.colors.textPrimary)

            Text(value)
                .font(BankingTheme.typography.bodySemiBold.font)
                .foregroundColor(BankingTheme.colors.textPrimary)
        }
    }
}

struct Constants {
    static let DefaultBackgroundColor: Color = .red
    
    static let DefaultCardWidth: CGFloat = 343
    static let DefaultCardHeight: CGFloat = 214

    // Labels and Default Strings
    static let DefaultBalanceLabel: String = "Balance"
    static let DefaultAvailableBalanceLabel: String = "Available balance"
    static let DefaultBalance: String = "-"
    static let DefaultAvailableBalance: String = "-"
    static let DefaultMaskedCardNumber: String = "*####"
    static let DefaultNextPaymentLabel: String = "Next Payment Amount"
    static let DefaultNextPaymentDueDateLabel: String = "Next Payment Due Date"
    static let DefaultDatePlaceholder: String = "-"
    static let DefaultMaturityDateLabel: String = "Maturity Date"
}

// Usage Example

/*
 
 // Deposit Account with Card
 let depositAccount = AccountDetailsCardData(
     id: "1",
     currentBalance: "2500.75",
     availableBalance: "2000.50",
     cardDetails: CardDetails(lastFourDigits: "5678"),
     accountType: .depositWithCard
 )
 let depositViewModel = AccountDetailsCardViewModel(accountDetailsCardData: depositAccount)
 AccountDetailsCard(viewType: .card, viewModel: depositViewModel)
 
 // Loan Account
 let loanAccount = AccountDetailsCardData(
     id: "2",
     currentBalance: "10000.00",
     availableBalance: "9800.00",
     paymentDetails: PaymentDetails(nextPaymentAmount: "500.00", nextPaymentDueDate: Date().addingTimeInterval(60*60*24*7)), // Next week
     accountType: .loan
 )
 let loanViewModel = AccountDetailsCardViewModel(accountDetailsCardData: loanAccount)
 AccountDetailsCard(viewType: .normal, viewModel: loanViewModel)
 
 // Certificate of Deposit Account
 let cdAccount = AccountDetailsCardData(
     id: "3",
     currentBalance: "15000.00",
     maturityDate: Calendar.current.date(byAdding: .year, value: 1, to: Date()),
     accountType: .certificateDeposit
 )
 let cdViewModel = AccountDetailsCardViewModel(accountDetailsCardData: cdAccount)
 AccountDetailsCard(viewType: .normal, viewModel: cdViewModel)
 
 // Partial Error Account
 let errorAccount = AccountDetailsCardData(
     id: "4",
     accountType: .depositWithCard
 )
 let errorViewModel = AccountDetailsCardViewModel(accountDetailsCardData: errorAccount)
 AccountDetailsCard(viewType: .card, viewModel: errorViewModel, isError: true)
 
 */
