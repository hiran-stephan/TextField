//
//  ListCellBottomSheet.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 12/09/24.
//

import Foundation
import SwiftUI

enum ListCellBottomSheet: String, Identifiable, BottomSheetEnum {
    case sheetOne
    case sheetTwo

    var id: String { rawValue }

    @ViewBuilder
    func view(coordinator: BottomSheetCoordinator<ListCellBottomSheet>) -> some View {
        switch self {
        case .sheetOne:
            VStack {
                Text("Need more help?")
                    .font(.headline)
                    .padding(.top, 20)
                

                // Using ListCellContainerView here with ListCellItemData
                ListCellContainerView(listCellItemData: [
                    ListCellItemData(textPrimary: "Locations", leftIconName: "mappin.and.ellipse"),
                    ListCellItemData(textPrimary: "Help", leftIconName: "questionmark.circle"),
                    ListCellItemData(textPrimary: "About", leftIconName: "info.circle"),
                    ListCellItemData(textPrimary: "Mobile Privacy Policy", leftIconName: "shield"),
                    ListCellItemData(textPrimary: "Mobile Online Security", leftIconName: "lock.shield"),
                    ListCellItemData(textPrimary: "Mobile Terms", leftIconName: "doc.text")
                ])
                .listStyle(PlainListStyle())
            }
        case .sheetTwo:
            VStack {
                Text("This is Sheet Two")
                    .padding()

                BottomSheetButton(coordinator: coordinator, nextSheet: .sheetOne, title: "Go back to Sheet One")
            }
        }
    }
}



public struct ListCellContainerView: View {
    let listCellItemData: [ListCellItemData]

    public init(listCellItemData: [ListCellItemData]) {
        self.listCellItemData = listCellItemData
    }

    public var body: some View {
        ForEach(listCellItemData) { itemData in
            ListCellItemView(listCellItemData: itemData)
        }
    }
}


public struct ListCellItemData: Identifiable {
    public let id = UUID()
    public let textPrimary: String
    public let textSecondary: String?
    public let showLeftIcon: String?
    public let rightIconName: String?
    public let leftIconName: String?
    public let rightIconAccessibilityText: String?
    public let leftIconAccessibilityText: String?

    public init(textPrimary: String,
                textSecondary: String? = nil,
                showLeftIcon: String? = nil,
                rightIconName: String? = nil,
                leftIconName: String? = nil,
                rightIconAccessibilityText: String? = nil,
                leftIconAccessibilityText: String? = nil) {
        self.textPrimary = textPrimary
        self.textSecondary = textSecondary
        self.showLeftIcon = showLeftIcon
        self.rightIconName = rightIconName
        self.leftIconName = leftIconName
        self.rightIconAccessibilityText = rightIconAccessibilityText
        self.leftIconAccessibilityText = leftIconAccessibilityText
    }
}


public struct ListCellItemView: View {
    let listCellItemData: ListCellItemData

    public init(listCellItemData: ListCellItemData) {
        self.listCellItemData = listCellItemData
    }

    public var body: some View {
        Button {
            // TODO: Add button action here if needed
        } label: {
            HStack(alignment: .top, spacing: BankingTheme.dimens.small) {
                if let leftIcon = listCellItemData.leftIconName {
                    Image(systemName: leftIcon)
                        .foregroundColor(.red) // Customize color as needed
                }

                VStack(alignment: .leading, spacing: 0) {
                    Text(listCellItemData.textPrimary)
                        .typography(BankingTheme.typography.body)
                        .foregroundColor(BankingTheme.colors.textPrimary)

                    if let textSecondary = listCellItemData.textSecondary {
                        Text(textSecondary)
                            .typography(BankingTheme.typography.bodySmall)
                            .foregroundColor(BankingTheme.colors.textSecondary)
                    }
                }

                Spacer()

                if let rightIcon = listCellItemData.rightIconName {
                    Image(systemName: rightIcon)
                        .foregroundColor(.gray)
                } else {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal, BankingTheme.dimens.extraExtraLarge)
    }
}
