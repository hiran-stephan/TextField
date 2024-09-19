import SwiftUI

struct ContentView: View {
    @StateObject var coordinator = BottomSheetCoordinator<ListCellBottomSheet>()
    @State private var listCellItemData: [ListCellItemData] = [] // Initialize data here if needed

    // Example menu actions to be mapped
    let menuActions: [ListMenuAction] = [
        ListMenuAction(
            id: "privacy_policy",
            primaryText: [
                "en": "Mobile Privacy Policy",
                "fr": "Politique de confidentialité mobile"
            ],
            secondaryText: nil,
            actionLink: "app://privacy",
            actionType: .deeplink,
            leadingIcon: LocalizedText(text: ["en": "shield.png", "fr": "bouclier.png"]),
            trailingIcon: LocalizedText(text: ["en": "chevron_right.png", "fr": "chevron_droit.png"])
        ),
        ListMenuAction(
            id: "online_security",
            primaryText: [
                "en": "Mobile Online Security",
                "fr": "Sécurité en ligne mobile"
            ],
            secondaryText: nil,
            actionLink: "app://security",
            actionType: .deeplink,
            leadingIcon: LocalizedText(text: ["en": "lock_shield.png", "fr": "verrou_bouclier.png"]),
            trailingIcon: LocalizedText(text: ["en": "chevron_right.png", "fr": "chevron_droit.png"])
        ),
        ListMenuAction(
            id: "terms_conditions",
            primaryText: [
                "en": "Mobile Terms",
                "fr": "Conditions d'utilisation mobile"
            ],
            secondaryText: nil,
            actionLink: "app://terms",
            actionType: .deeplink,
            leadingIcon: LocalizedText(text: ["en": "doc_text.png", "fr": "doc_texte.png"]),
            trailingIcon: LocalizedText(text: ["en": "chevron_right.png", "fr": "chevron_droit.png"])
        )
    ]

    
    // Define the locale for localization (can be dynamic)
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
            .bottomSheetManaging(coordinator: coordinator, listCellItemData: $listCellItemData) // Pass the mapped data to the sheet
            
        }
        .ignoresSafeArea(.container, edges: .bottom) // Merge the button with the safe area at the bottom
        .onAppear {
            // Map ListMenuActions to ListCellItemData on appear
            listCellItemData = menuActions.map {
                ListCellDataMapper.toListCellData(listMenuAction: $0, locale: locale)
            }
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

}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


