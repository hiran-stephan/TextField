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
