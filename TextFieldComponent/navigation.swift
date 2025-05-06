import SwiftUI

public struct ListItemView<TrailingContent: View>: View {
    private let listItemData: ListItemData
    private let trailingContent: () -> TrailingContent

    public init(
        listItemData: ListItemData,
        @ViewBuilder trailingContent: @escaping () -> TrailingContent
    ) {
        self.listItemData = listItemData
        self.trailingContent = trailingContent
    }

    public init(listItemData: ListItemData) where TrailingContent == EmptyView {
        self.listItemData = listItemData
        self.trailingContent = { EmptyView() }
    }

    public var body: some View {
        HStack(alignment: .top, spacing: BankingTheme.spacing.medium) {
            // Leading content
            VStack(alignment: .leading, spacing: 4) {
                Text(listItemData.primaryText)
                    .typography(BankingTheme.typography.body)

                if let secondaryText = listItemData.secondaryText {
                    Text(secondaryText)
                        .typography(BankingTheme.typography.bodySmall)
                }
            }

            Spacer()

            // Trailing content
            VStack(alignment: .trailing, spacing: 4) {
                if let data = listItemData.data {
                    Text(data)
                        .multilineTextAlignment(.trailing)
                        .typography(BankingTheme.typography.bodySemiBold)
                }

                trailingContent()
            }
        }
        .padding(.horizontal, BankingTheme.dimens.medium)
        .padding(.vertical, BankingTheme.dimens.medium)
    }
}





import SwiftUI

public struct ListItemData: Identifiable {
    public var id: String { primaryText }

    public var primaryText: String
    public var secondaryText: String?
    public var data: String?

    public init(
        primaryText: String,
        secondaryText: String? = nil,
        data: String? = nil
    ) {
        self.primaryText = primaryText
        self.secondaryText = secondaryText
        self.data = data
    }
}


struct ProfilePage: View {
    private let profileItems: [ListItemData] = [
        .init(primaryText: "Primary email address", secondaryText: "primary_email@cibc.com"),
        .init(primaryText: "Secondary email address", secondaryText: "secondary_email@cibc.com"),
        .init(primaryText: "Home phone", secondaryText: "(647) 123-4567"),
        .init(primaryText: "Mobile phone", secondaryText: "(647) 123-4567"),
        .init(
            primaryText: "Home address",
            data: """
                  1600 Pennsylvania Avenue NW
                  Washington, DC
                  20500
                  United States
                  """
        )
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("My Profile")
                .font(.title2)
                .padding(.horizontal)

            ListCardView(listCellData: profileItems) { item in
                ListItemView(listItemData: item) {
                    Button(action: {
                        print("Edit tapped for \(item.primaryText)")
                    }) {
                        Image(systemName: "pencil")
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(.plain)
                }
            }

            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemGroupedBackground))
    }
}

