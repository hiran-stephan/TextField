import SwiftUI

struct ContentView: View {
    @StateObject var coordinator = BottomSheetCoordinator<ListCellBottomSheet>()

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
            SafeSpaceTile() {
                showSheetOne()
            }
            .bottomSheetManaging(coordinator: coordinator)
        }
        .ignoresSafeArea(.container, edges: .bottom) // Merge the button with the safe area at the bottom

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


