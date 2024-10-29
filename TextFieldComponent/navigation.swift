

import Foundation
import SwiftUI
import Theme
import Koin
import Umbrella

/// View struct for displaying section details, including a list of items and their actions
public struct SectionDetailsView: View {
    // MARK: - Properties
    
    let header: String
    let sectionData: [ListCellItemData]
    let onClick: (String) -> Void

    // Optional padding values for customization
    let paddingTop: CGFloat?
    let horizontalContainerPadding: CGFloat?
    let verticalContainerPadding: CGFloat?
    let trailingListIconPadding: CGFloat?
    let leadingListIconPadding: CGFloat?
    let horizontalListSpacing: CGFloat?

    // MARK: - Initializer
    
    public init(
        header: String,
        sectionData: [ListCellItemData],
        paddingTop: CGFloat? = nil,
        horizontalContainerPadding: CGFloat? = nil,
        verticalContainerPadding: CGFloat? = nil,
        trailingListIconPadding: CGFloat? = nil,
        leadingListIconPadding: CGFloat? = nil,
        horizontalListSpacing: CGFloat? = nil,
        onClick: @escaping (String) -> Void
    ) {
        self.header = header
        self.sectionData = sectionData
        self.paddingTop = paddingTop
        self.horizontalContainerPadding = horizontalContainerPadding
        self.verticalContainerPadding = verticalContainerPadding
        self.trailingListIconPadding = trailingListIconPadding
        self.leadingListIconPadding = leadingListIconPadding
        self.horizontalListSpacing = horizontalListSpacing
        self.onClick = onClick
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(alignment: .leading, spacing: BankingTheme.spacing.noPadding) {
            SectionHeaderView(title: header, paddingTop: paddingTop)
            
            ListCardContainer(
                hasBorder: true,
                isRoundedShape: true,
                horizontalPadding: horizontalContainerPadding,
                verticalPadding: verticalContainerPadding
            ) {
                ForEach(sectionData, id: \.actionCellId) { listItem in
                    let isDividerVisible = listItem != sectionData.last
                    ListCellItemText(
                        listCellItemData: listItem,
                        showDivider: isDividerVisible,
                        dataTextStyle: BankingTheme.typography.body,
                        trailingIconPadding: trailingListIconPadding,
                        leadingIconPadding: leadingListIconPadding,
                        horizontalSpacing: horizontalListSpacing,
                        onClick: { selectedItem in
                            onClick(selectedItem.actionPrimaryLabel)
                        }
                    )
                }
            }
        }
        .padding(.horizontal, horizontalContainerPadding ?? BankingTheme.spacing.noPadding)
    }
}

// MARK: - ViewBuilders

private extension SectionDetailsView {
    
    /// ViewBuilder function to display a section header
    @ViewBuilder
    func SectionHeaderView(title: String, paddingTop: CGFloat? = nil) -> some View {
        SectionHeadingView(title)
            .padding(.horizontal, BankingTheme.spacing.noPadding)
            .padding(.top, paddingTop ?? BankingTheme.spacing.smallMedium)
            .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

