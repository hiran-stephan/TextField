import SwiftUI

struct ContentView: View {
    @StateObject var coordinator = BottomSheetCoordinator<ListCellBottomSheet>()

    var body: some View {
        VStack {
            Text("Main View")
                .font(.largeTitle)
                .padding()
            
            // Use the SheetButton to present Sheet One
            BottomSheetButton(coordinator: coordinator, nextSheet: .sheetOne, title: "Show Sheet One")
                .bottomSheetManaging(coordinator: coordinator) // Apply the sheet manager to handle sheet presentation
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
