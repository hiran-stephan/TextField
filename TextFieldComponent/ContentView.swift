import SwiftUI

struct ContentView: View {
    @StateObject var coordinator = SheetCoordinator<AppSheet>() // Initialize the sheet coordinator

    var body: some View {
        VStack {
            Text("Main View")
                .font(.largeTitle)
                .padding()

            // Button to present the first sheet
            Button(action: {
                coordinator.presentSheet(sheet: .sheetOne) // Present Sheet One asynchronously
            }) {
                Text("Show Sheet One")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .sheetCoordinating(coordinator: coordinator) // Apply the sheet coordinating modifier
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
