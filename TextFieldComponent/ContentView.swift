import SwiftUI

struct ContentView: View {
    @StateObject var coordinator = BottomSheetCoordinator<ListCellBottomSheet>()
    @State private var bottomSheetData: ListCellBottomSheetData = ListCellBottomSheetData(
            title: "",
            titleAccessibilityText: "",
            menuActions: []
        )     // Define the locale for localization (can be dynamic)
    let locale = "en"
    
    var body: some View {
        VStack {
            Text("Main View")
                .font(.largeTitle)
                .padding()
            
//            // Use the SheetButton to present Sheet One
//            BottomSheetButton<ListCellBottomSheet>(title: "Show Sheet One") {
//                await coordinator.transitionToSheet(.sheetOne) // Reuse the transition logic
//            }
//            .bottomSheetManaging(coordinator: coordinator)
            Spacer()
            // Trigger SafeSpaceTile action
            SafeSpaceTile {
                showSheetOne()
            }
            .bottomSheetManaging(coordinator: coordinator, sheetData: $bottomSheetData) { selectedItem in
                // Handle row selection here
                print("Selected item: \(selectedItem.textPrimary)")
                // Perform any specific actions when an item is selected
            }
            
        }
        .ignoresSafeArea(.container, edges: .bottom) // Merge the button with the safe area at the bottom
        .onAppear {
            // Load the menu actions from JSON
//            let menuActionsFromJSON = ListMenuAction.loadMenuActionsFromJSON()
            
//            // Map the JSON-loaded ListMenuActions to ListCellItemData
//            listCellItemData = menuActionsFromJSON.map {
//                ListCellDataMapper.toListCellData(listMenuAction: $0, locale: locale)
//            }
        }
    }
    
    // Define the sheet presentation logic in a separate function
    private func showSheetOne() {
        Task {
            do {
                await coordinator.transitionToSheet(.sheetOne)
            } catch {
                // Handle any error that might occur during the transition
                print("Failed to present sheet: \(error)")
            }
        }
    }
    
    // Load MenuActions from JSON
    func loadMenuActionsFromJSON() -> [ListMenuAction] {
        let jsonData = """
            [
              {
                "id": "privacy_policy",
                "primary_text": {
                  "en": "Mobile Privacy Policy",
                  "fr": "Politique de confidentialité mobile"
                },
                "action_link": "app://privacy",
                "action_type": "webLink",
                "leading_icon": {
                  "en": "shield.png",
                  "fr": "bouclier.png"
                },
                "trailing_icon": {
                  "en": "chevron_right.png",
                  "fr": "chevron_droit.png"
                }
              },
              {
                "id": "online_security",
                "primary_text": {
                  "en": "Mobile Online Security",
                  "fr": "Sécurité en ligne mobile"
                },
                "action_link": "app://security",
                "action_type": "webLink",
                "leading_icon": {
                  "en": "lock_shield.png",
                  "fr": "verrou_bouclier.png"
                },
                "trailing_icon": {
                  "en": "chevron_right.png",
                  "fr": "chevron_droit.png"
                }
              },
              {
                "id": "terms_conditions",
                "primary_text": {
                  "en": "Mobile Terms",
                  "fr": "Conditions d'utilisation mobile"
                },
                "action_link": "app://terms",
                "action_type": "webLink",
                "leading_icon": {
                  "en": "doc_text.png",
                  "fr": "doc_texte.png"
                },
                "trailing_icon": {
                  "en": "chevron_right.png",
                  "fr": "chevron_droit.png"
                }
              }
            ]
            """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        do {
            let menuActions = try decoder.decode([ListMenuAction].self, from: jsonData)
            return menuActions
        } catch {
            print("Failed to decode JSON: \(error)")
            return []
        }
    }

}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func makeBody(configuration: Configuration) -> some View {
    configuration.label
        .frame(maxWidth: .infinity)
        .background(configuration.isPressed ? pressedBackgroundColor : backgroundColor)
        .if(showDivider) { view in
            view.overlay(
                Divider()
                    .frame(height: BankingTheme.spacing.stroke)
                    .background(BankingTheme.colors.borderDefault)
                    .padding(.horizontal, BankingTheme.dimens.medium),
                alignment: .bottom
            )
        }
}

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
/*
 struct ContentView: View {
     
     // Dummy data for demonstration
     let items: [ListCellItemData] = [
         ListCellItemData(
             actionCellId: "1",
             actionPrimaryLabel: "adfgsD DFsf",
             actionSecondaryLabel: "SDvdv SDF AG QERG QER",
             trailingIconName: "chevron",
             leadingIconAccessibilityText: "Leading Icon",
             trailingIconAccessibilityText: "Trailing Chevron",
             actionCount: "3"
         ),
         ListCellItemData(
             actionCellId: "2",
             actionPrimaryLabel: "ASDGF ARG QERG",
             actionSecondaryLabel: " EWGR QERH ERH ",
             leadingIconName: "location",
             leadingIconAccessibilityText: "Leading Icon",
             trailingIconAccessibilityText: "Trailing Chevron"
         ),
         ListCellItemData(
             actionCellId: "3",
             actionPrimaryLabel: "QERG   ERG  EWG l",
             actionSecondaryLabel: " WET G   QERH REH",
             leadingIconName: "location",
             trailingIconName: "chevron",
             leadingIconAccessibilityText: "Leading Icon",
             trailingIconAccessibilityText: "Trailing Chevron",
             data: "Text"
         )
     ]
     
     var body: some View {
         VStack {
             ListCardContainer(
                 hasBorder: true,
                 isRoundedShape: true,
                 backgroundColor: .white,
                 hasHorizontalPadding: true
             ) {
                 ForEach(items, id: \.actionCellId) { actionItem in
                     let isDividerVisible = actionItem != items.last

                     // Display ListCellItem for each actionItem
                     ListCellItemText(
                         backgroundColor: BankingTheme.colors.background,
                         pressedBackgroundColor: BankingTheme.colors.pressed,
                         listCellItemData: actionItem,
                         showDivider: isDividerVisible,
                         dataTextStyle: BankingTheme.typography.bodySmall,
                         onClick: { clickedItem in
                             // Handle cell click
                             print("ListCellItem clicked: \(clickedItem.actionPrimaryLabel)")
                             // Simulate onDismiss behavior
                         }
                     )
                 }
             }
         }
         .padding()
     }
 }
 */

/*
 struct ContentView: View {
     
 let sampleData: [AccountSectionFieldData] = [
     AccountSectionFieldData(
         title: "Account Details",
         data: [
             ListCellItemData(actionCellId: "1", actionPrimaryLabel: "Account number", trailingIconName: "quick-look", data: "1234567"),
             ListCellItemData(actionCellId: "2", actionPrimaryLabel: "ABA routing number", trailingIconName: "quick-look", data: "1234567"),
             ListCellItemData(actionCellId: "3", actionPrimaryLabel: "ATM withdrawal limit", trailingIconName: "quick-look", data: "<Data>"),
             ListCellItemData(actionCellId: "4", actionPrimaryLabel: "POS purchase limit", trailingIconName: "quick-look", data: "<Data>")
         ]
     ),
     AccountSectionFieldData(
         title: "Balance Details",
         data: [
             ListCellItemData(actionCellId: "5", actionPrimaryLabel: "Starting balance", data: "$<Data>"),
             ListCellItemData(actionCellId: "6", actionPrimaryLabel: "Holds", data: "$<Data>")
         ]
     ),
     AccountSectionFieldData(
         title: "Interest Details",
         data: [
             ListCellItemData(actionCellId: "7", actionPrimaryLabel: "Interest rate", data: "<Data>%"),
             ListCellItemData(actionCellId: "8", actionPrimaryLabel: "Interest YTD", data: "$<Data>"),
             ListCellItemData(actionCellId: "9", actionPrimaryLabel: "Interest last year", data: "$<Data>")
         ]
     ),
     AccountSectionFieldData(
         title: "Statement Details",
         data: [
             ListCellItemData(actionCellId: "10", actionPrimaryLabel: "Last statement date", data: "<Data>"),
             ListCellItemData(actionCellId: "11", actionPrimaryLabel: "Last statement balance", data: "$<Data>"),
             ListCellItemData(actionCellId: "12", actionPrimaryLabel: "Last statement APY earned", data: "<Data>%")
         ]
     )
 ]

     
     var body: some View {
         VStack(spacing: 0) {
             AccountSectionListView(accountSections: sampleData)
         }
         .padding()
     }
 }

 struct ContentView_Previews: PreviewProvider {
     static var previews: some View {
         ContentView()
     }
 }

 struct AccountSectionFieldData {
     let title: String
     let data: [ListCellItemData]
 }

 struct SectionHeaderView: View {
     let title: String

     var body: some View {
         HStack(alignment: .top, spacing: BankingTheme.spacing.noPadding) {
             Text(title)
                 .font(
                     BankingTheme.typography.allCapsHeading.font
                 )
                 .foregroundColor(BankingTheme.colors.textPrimary)
                 .frame(maxWidth: .infinity, alignment: .topLeading)
         }
         .padding(.horizontal, BankingTheme.spacing.noPadding)
         .padding(.top, Constants.Padding4XI)
         .padding(.bottom, BankingTheme.dimens.smallMedium)
         .frame(maxWidth: .infinity, alignment: .topLeading)
     }
 }

 // Constants used in the view
 struct Constants {
     static let Padding4XI: CGFloat = 48
 }

 struct AccountSectionListView: View {
     let accountSections: [AccountSectionFieldData] // List of section data
     
     var body: some View {
         List {
             ForEach(accountSections, id: \.title) { section in
                 VStack(alignment: .leading, spacing: 0) {
                     // Non-sticky section header
                     SectionHeaderView(title: section.title)
                     
                     // Card-like container for each section
                     ListCardContainer(
                         hasBorder: true,
                         isRoundedShape: true,
                         backgroundColor: .white,
                         hasHorizontalPadding: true
                     ) {
                         ForEach(section.data, id: \.actionCellId) { listItem in
                             let isDividerVisible = listItem != section.data.last
                             ListCellItemText(
                                 backgroundColor: .white, // Customize the background
                                 pressedBackgroundColor: .gray, // Customize the pressed color
                                 listCellItemData: listItem,
                                 showDivider: isDividerVisible, // Show divider between cells
                                 dataTextStyle: BankingTheme.typography.body, // Customize the text style for trailing text
                                 onClick: { selectedItem in
                                     print("Clicked on: \(selectedItem)")
                                 }
                             )
                         }
                     }
                 }
                 .listRowInsets(EdgeInsets()) // Removes default padding
                 .listRowSeparator(.hidden) // Removes default separator lines
             }
         }
         .listStyle(PlainListStyle()) // Removes default list style
     }
 }
 */

/*
 /// `AccountSectionListView` is a SwiftUI view that displays a list of account sections.
 /// Each section includes a header and a list of data items, styled as a card-like container.
 struct AccountSectionListView: View {
     
     /// The list of account sections to display.
     let accountSections: [AccountSectionFieldData]

     /// Initializes the view with a given list of account sections.
     /// - Parameter accountSections: The account sections to display in the list.
     init(accountSections: [AccountSectionFieldData]) {
         self.accountSections = accountSections
     }

     /// The body of the view.
     var body: some View {
         List {
             // Loop through each section in the list of account sections.
             ForEach(accountSections, id: \.title) { section in
                 VStack(alignment: .leading, spacing: BankingTheme.spacing.noPadding) {
                     // Section header displaying the title of the section.
                     SectionHeaderView(title: section.title)

                     // Card-like container for each section.
                     ListCardContainer(
                         hasBorder: true,
                         isRoundedShape: true,
                         horizontalPadding: BankingTheme.dimens.smallMedium + BankingTheme.dimens.medium,
                         verticalPadding: BankingTheme.dimens.microSmall
                     ) {
                         // Loop through each data item in the section.
                         ForEach(section.data, id: \.actionCellId) { listItem in
                             let isDividerVisible = listItem != section.data.last
                             ListCellItemText(
                                 pressedBackgroundColor: BankingTheme.colors.surfaceVariant,
                                 listCellItemData: listItem,
                                 showDivider: isDividerVisible,
                                 dataTextStyle: BankingTheme.typography.body,
                                 onClick: { selectedItem in
                                     print("Clicked on: \(selectedItem)")
                                 }
                             )
                         }
                     }
                 }
                 // Set padding for each section's content.
                 .padding(.horizontal, BankingTheme.dimens.smallMedium)
                 .padding(.vertical, BankingTheme.dimens.microSmall)
             }
         }
         .listRowInsets(EdgeInsets())  // Removes extra padding around list rows.
         .listRowSeparator(.hidden)    // Hides row separators in the list.
         .listStyle(PlainListStyle())  // Applies a plain list style.
     }
 }

 /// `SectionHeaderView` is a SwiftUI view that displays the title of a section in the list.
 struct SectionHeaderView: View {
     
     /// The title of the section to display.
     let title: String

     /// The body of the view.
     var body: some View {
         HStack(alignment: .top, spacing: BankingTheme.spacing.noPadding) {
             // Displays the section title in uppercase with styling.
             Text(title.uppercased())
                 .font(BankingTheme.typography.allCapsHeading.font)
                 .foregroundColor(BankingTheme.colors.textPrimary)
                 .frame(maxWidth: .infinity, alignment: .topLeading) // Aligns title to the top left.
         }
         // Set padding around the header.
         .padding(.horizontal, BankingTheme.spacing.noPadding)
         .padding(.top, Constants.paddingTopSectionHeaderView)
         .padding(.bottom, BankingTheme.dimens.smallMedium)
         .frame(maxWidth: .infinity, alignment: .topLeading)
     }

     /// Constants for the header view layout.
     private enum Constants {
         static let paddingTopSectionHeaderView: CGFloat = 48.0
     }
 }

 */
