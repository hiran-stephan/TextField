import Foundation
import SwiftUI
import Theme
import Koin
import Umbrella

/// A style struct to encapsulate padding and spacing options for `SectionDetailsView`
public struct SectionDetailsStyle {
    /// Top padding for the section header
    let paddingTop: CGFloat?
    /// Horizontal padding for the container around section items
    let horizontalContainerPadding: CGFloat?
    /// Vertical padding for the container around section items
    let verticalContainerPadding: CGFloat?
    /// Padding applied to the trailing icon within each list item
    let trailingListIconPadding: CGFloat?
    /// Padding applied to the leading icon within each list item
    let leadingListIconPadding: CGFloat?
    /// Horizontal spacing between elements in each list item
    let horizontalListSpacing: CGFloat?

    /// Initializes a new instance of `SectionDetailsStyle`
    /// - Parameters:
    ///   - paddingTop: Top padding for the section header
    ///   - horizontalContainerPadding: Horizontal padding for the section container
    ///   - verticalContainerPadding: Vertical padding for the section container
    ///   - trailingListIconPadding: Padding for the trailing icon within list items
    ///   - leadingListIconPadding: Padding for the leading icon within list items
    ///   - horizontalListSpacing: Spacing between elements in each list item
    public init(
        paddingTop: CGFloat? = nil,
        horizontalContainerPadding: CGFloat? = nil,
        verticalContainerPadding: CGFloat? = nil,
        trailingListIconPadding: CGFloat? = nil,
        leadingListIconPadding: CGFloat? = nil,
        horizontalListSpacing: CGFloat? = nil
    ) {
        self.paddingTop = paddingTop
        self.horizontalContainerPadding = horizontalContainerPadding
        self.verticalContainerPadding = verticalContainerPadding
        self.trailingListIconPadding = trailingListIconPadding
        self.leadingListIconPadding = leadingListIconPadding
        self.horizontalListSpacing = horizontalListSpacing
    }
}

/// A view for displaying section details, including a header and a list of items with actions
public struct SectionDetailsView: View {
    // MARK: - Properties
    
    /// Title or header of the section
    let header: String
    /// Data for each item in the section
    let sectionData: [ListCellItemData]
    /// Closure that handles the item click event, passing the action label
    let onClick: (String) -> Void
    /// Style configuration for padding and spacing in the view
    let style: SectionDetailsStyle

    // MARK: - Initializer
    
    /// Initializes a new instance of `SectionDetailsView`
    /// - Parameters:
    ///   - header: Title of the section
    ///   - sectionData: List of items to display in the section
    ///   - style: Style configuration for padding and spacing (default: `SectionDetailsStyle()`)
    ///   - onClick: Closure to handle item click events
    public init(
        header: String,
        sectionData: [ListCellItemData],
        style: SectionDetailsStyle = SectionDetailsStyle(),
        onClick: @escaping (String) -> Void
    ) {
        self.header = header
        self.sectionData = sectionData
        self.style = style
        self.onClick = onClick
    }
    
    // MARK: - Body
    
    /// The body of the `SectionDetailsView`
    public var body: some View {
        VStack(alignment: .leading, spacing: BankingTheme.spacing.noPadding) {
            SectionHeaderView(title: header, paddingTop: style.paddingTop)
            
            ListCardContainer(
                hasBorder: true,
                isRoundedShape: true,
                horizontalPadding: style.horizontalContainerPadding,
                verticalPadding: style.verticalContainerPadding
            ) {
                ForEach(sectionData, id: \.actionCellId) { listItem in
                    let isDividerVisible = listItem != sectionData.last
                    ListCellItemText(
                        listCellItemData: listItem,
                        showDivider: isDividerVisible,
                        dataTextStyle: BankingTheme.typography.body,
                        trailingIconPadding: style.trailingListIconPadding,
                        leadingIconPadding: style.leadingListIconPadding,
                        horizontalSpacing: style.horizontalListSpacing,
                        onClick: { selectedItem in
                            onClick(selectedItem.actionPrimaryLabel)
                        }
                    )
                }
            }
        }
        .padding(.horizontal, style.horizontalContainerPadding ?? BankingTheme.spacing.noPadding)
    }
}

// MARK: - ViewBuilders

private extension SectionDetailsView {
    
    /// A helper function to display a section header with customizable padding
    /// - Parameters:
    ///   - title: Title of the section header
    ///   - paddingTop: Optional top padding for the header
    @ViewBuilder
    func SectionHeaderView(title: String, paddingTop: CGFloat? = nil) -> some View {
        SectionHeadingView(title)
            .padding(.horizontal, BankingTheme.spacing.noPadding)
            .padding(.top, paddingTop ?? BankingTheme.spacing.smallMedium)
            .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}



// Define the style with the required padding values
let style = SectionDetailsStyle(
    paddingTop: BankingTheme.spacing.noPadding,
    horizontalContainerPadding: BankingTheme.dimensions.medium,
    verticalContainerPadding: BankingTheme.dimensions.medium,
    trailingListIconPadding: BankingTheme.spacing.noPadding,
    leadingListIconPadding: BankingTheme.dimensions.small,
    horizontalListSpacing: BankingTheme.dimensions.smallMedium
)

// Use the style in SectionDetailsView
SectionDetailsView(
    header: presenter.verificationHeader,
    sectionData: [
        ListCellItemData(
            actionCellId: presenter.biometricTitle,
            actionPrimaryLabel: presenter.biometricTitle,
            actionSecondaryLabel: presenter.biometricDescription,
            leadingIconName: ComponentConstants.Images.faceId,
            trailingIconName: ComponentConstants.Images.chevron,
            data: presenter.biometricStatus
        )
    ],
    style: style, // Pass the style object here
    onClick: { primaryText in
        // Handle the onClick action
    }
)
