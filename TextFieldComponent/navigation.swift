public struct ProfileItemData: Identifiable {
    public let id: String

    public var primaryLabel: String
    public var primaryText: String
    public var secondaryLabel: String?
    public var secondaryText: String?
    public var showsEditIcon: Bool

    public init(
        id: String = UUID().uuidString,
        primaryLabel: String,
        primaryText: String,
        secondaryLabel: String? = nil,
        secondaryText: String? = nil,
        showsEditIcon: Bool = true
    ) {
        self.id = id
        self.primaryLabel = primaryLabel
        self.primaryText = primaryText
        self.secondaryLabel = secondaryLabel
        self.secondaryText = secondaryText
        self.showsEditIcon = showsEditIcon
    }
}

import SwiftUI

public struct ProfileItemView: View {
    let data: ProfileItemData
    let onEditTapped: (() -> Void)?

    public init(data: ProfileItemData, onEditTapped: (() -> Void)? = nil) {
        self.data = data
        self.onEditTapped = onEditTapped
    }

    public var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                labelBlock(label: data.primaryLabel, value: data.primaryText)

                if let secondaryLabel = data.secondaryLabel,
                   let secondaryText = data.secondaryText {
                    labelBlock(label: secondaryLabel, value: secondaryText)
                }
            }

            Spacer()

            if data.showsEditIcon, let onEditTapped {
                Button(action: onEditTapped) {
                    Image(systemName: "pencil")
                        .foregroundColor(BankingTheme.colors.iconPrimary)
                }
                .buttonStyle(.plain)
                .padding(.top, 4)
            }
        }
        .padding(.horizontal, BankingTheme.dimens.medium)
        .padding(.vertical, BankingTheme.dimens.medium)
    }

    @ViewBuilder
    private func labelBlock(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .typography(BankingTheme.typography.bodySmall)

            Text(value)
                .typography(BankingTheme.typography.bodySemiBold)
                .multilineTextAlignment(.leading)
        }
    }
}

let items: [ProfileItemData] = [
    .init(
        primaryLabel: "Primary email address",
        primaryText: "primary_email@cibc.com",
        secondaryLabel: "Secondary email address",
        secondaryText: "secondary_email@cibc.com"
    ),
    .init(
        primaryLabel: "Home phone",
        primaryText: "(647) 123-4567",
        secondaryLabel: "Mobile phone",
        secondaryText: "(647) 123-4567"
    ),
    .init(
        primaryLabel: "Home address",
        primaryText: "1600 Pennsylvania Avenue NW\nWashington, DC\n20500\nUnited States"
    )
]

VStack(spacing: 0) {
    ForEach(items.indices, id: \.self) { index in
        ProfileItemView(data: items[index]) {
            print("Edit tapped for \(items[index].primaryLabel)")
        }

        if index < items.count - 1 {
            Divider().padding(.leading, BankingTheme.dimens.medium)
        }
    }
}
.background(Color.white)
.clipShape(RoundedRectangle(cornerRadius: 12))


public struct ProfileItemCardView: View {
    let items: [ProfileItemData]
    let onEditTapped: (ProfileItemData) -> Void

    public var body: some View {
        VStack(spacing: 0) {
            ForEach(items.indices, id: \.self) { index in
                ProfileItemView(data: items[index]) {
                    onEditTapped(items[index])
                }

                if index < items.count - 1 {
                    Divider()
                        .padding(.leading, BankingTheme.dimens.medium)
                }
            }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.1))
        )
    }
}

ProfileItemCardView(items: items) { item in
    print("Edit tapped for \(item.primaryLabel)")
}
.padding()
.background(Color(UIColor.systemGroupedBackground))
