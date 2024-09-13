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
            VStack(alignment: .leading, spacing: BankingTheme.spacing.noPadding) {
                
                HStack(alignment: .center, spacing: BankingTheme.spacing.noPadding) {
                    Text("Need more help?")
                        .font(BankingTheme.typography.bodySemiBold.font)
                        .foregroundColor(BankingTheme.colors.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                .padding(.horizontal, BankingTheme.dimens.medium) // 16
                .padding(.top, BankingTheme.dimens.extraExtraLarge) // 40
                .padding(.bottom, BankingTheme.dimens.smallMedium)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
                // Using ListCellContainerView here with ListCellItemData
                ListCellContainerView(listCellItemData: [
                    ListCellItemData(textPrimary: "Locations",textSecondary: "please add", leftIconName: "mappin.and.ellipse", actionCount: "1"),
                    ListCellItemData(textPrimary: "Help", leftIconName: "questionmark.circle"),
                    ListCellItemData(textPrimary: "About", leftIconName: "info.circle"),
                    ListCellItemData(textPrimary: "Mobile Privacy Policy", leftIconName: "shield"),
                    ListCellItemData(textPrimary: "Mobile Online Security", leftIconName: "lock.shield"),
                    ListCellItemData(textPrimary: "Mobile Terms", leftIconName: "doc.text")
                ])
                .listStyle(PlainListStyle())
                
                Spacer() // Pushes the content to the top
            }
            .frame(maxHeight: .infinity, alignment: .top)
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
    public let actionCount: String?
    
    public init(textPrimary: String,
                textSecondary: String? = nil,
                showLeftIcon: String? = nil,
                rightIconName: String? = nil,
                leftIconName: String? = nil,
                rightIconAccessibilityText: String? = nil,
                leftIconAccessibilityText: String? = nil,
                actionCount: String? = nil) {
        self.textPrimary = textPrimary
        self.textSecondary = textSecondary
        self.showLeftIcon = showLeftIcon
        self.rightIconName = rightIconName
        self.leftIconName = leftIconName
        self.rightIconAccessibilityText = rightIconAccessibilityText
        self.leftIconAccessibilityText = leftIconAccessibilityText
        self.actionCount = actionCount
    }
}


public struct ListCellItemView: View {
    let listCellItemData: ListCellItemData
    
    public init(listCellItemData: ListCellItemData) {
        self.listCellItemData = listCellItemData
    }
    
    public var body: some View {
        Button {
            // TODO: button action
        } label: {
            VStack(spacing: BankingTheme.spacing.noPadding) {
                HStack(alignment: .center, spacing: BankingTheme.dimens.small) {
                    // Leading Image Placeholder
                    ListCellIconView(imageName: "chevron", padding: BankingTheme.dimens.small)
                    
                    // Primary and Secondary Text
                    listCellTextContent(listCellItemData: listCellItemData)
                    
                    Spacer()
                    
                    // Trailing Number View
                    listCellBadgeIndicatorView(listCellItemData: listCellItemData)

                    // Trailing Image Placeholder
                    ListCellIconView(imageName: "chevron")
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(BankingTheme.dimens.medium)
            }
        }
        .buttonStyle(ListCellButtonModifier())
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    private func listCellTextContent(listCellItemData: ListCellItemData) -> some View {
        VStack(alignment: .leading, spacing: BankingTheme.spacing.noPadding) {
            Text(listCellItemData.textPrimary)
                .typography(BankingTheme.typography.body)
                .foregroundColor(BankingTheme.colors.textPrimary)
                .frame(maxHeight: listCellItemData.textSecondary == nil ? .infinity : nil)
            
            if let textSecondary = listCellItemData.textSecondary {
                Text(textSecondary)
                    .typography(BankingTheme.typography.bodySmall)
                    .foregroundColor(BankingTheme.colors.textSecondary)
            }
        }
    }
    
    @ViewBuilder
    private func listCellBadgeIndicatorView(listCellItemData: ListCellItemData) -> some View {
        if let trailingNumber = listCellItemData.actionCount {
            HStack {
                Text(trailingNumber)
                    .font(BankingTheme.typography.caption.font)
                    .frame(width: BankingTheme.dimens.mediumLarge, height: BankingTheme.dimens.medium)
                    .foregroundColor(BankingTheme.colors.textPrimary)
                    .background(Color(hex: 0xFFFCCDDF2))
                    .cornerRadius(BankingTheme.dimens.mediumLarge)
            }
        }
    }
}

struct ListCellButtonModifier: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .frame(height: ListCellTheme.cellHeight)
            .overlay(
                Divider()
                    .frame(height: BankingTheme.spacing.stroke)
                    .background(BankingTheme.colors.borderDefault)
                    .padding(.horizontal, BankingTheme.dimens.medium), alignment: .bottom
            )
            .background(configuration.isPressed ? BankingTheme.colors.pressed : BankingTheme.colors.surfaceVariant)
    }
}


struct ListCellTheme {
    static let cellHeight = 76.0
}

public struct ListCellIconView: View {
    let imageName: String
    let padding: CGFloat
    
    public init(imageName: String, padding: CGFloat = BankingTheme.spacing.noPadding) {
        self.imageName = imageName
        self.padding = padding
    }
    
    public var body: some View {
        ZStack {
            ComponentImage(imageName, resizable: true)
                .frame(width: BankingTheme.dimens.large, height: BankingTheme.dimens.large)
                .padding(padding)
        }
    }
}


