import SwiftUI

struct ContentView: View {
    @StateObject var coordinator = SheetCoordinator<AppSheet>()

    var body: some View {
        VStack {
            Text("Main View")
                .font(.largeTitle)
                .padding()
            sheetButton(coordinator: coordinator, nextSheet: .sheetOne, title: "Show sheet one")
                .sheetCoordinating(coordinator: coordinator)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
