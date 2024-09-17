import SwiftUI

struct ContentView: View {
    @StateObject var coordinator = BottomSheetCoordinator<ListCellBottomSheet>()

    var body: some View {
        VStack {
            Text("Main View")
                .font(.largeTitle)
                .padding()
            
            // Use the SheetButton to present Sheet One
            BottomSheetButton<ListCellBottomSheet>(title: "Show Sheet One") {
                await coordinator.transitionToSheet(.sheetOne) // Reuse the transition logic
            }
            .bottomSheetManaging(coordinator: coordinator)
            Spacer() 
//            SafeSpaceTile {
//                // Action when the button is tapped
//                print("Help button tapped!")
//            }
        }
        .ignoresSafeArea(.container, edges: .bottom) // Merge the button with the safe area at the bottom

    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
