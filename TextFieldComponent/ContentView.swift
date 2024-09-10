import SwiftUI

// Usage Example
//struct ContentView: View {
//    @State private var text: String = ""
//    @State private var showError: Bool = false
//    // State variables to handle alerts
//    @State private var showAlert: Bool = false
//    @State private var alertMessage: String = ""
//
//    var body: some View {
//        VStack {
////            PlaceholderView()
//        }
//        .padding(.horizontal, 16)
//        .padding(.vertical, 16)
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

struct ContentView: View {
    @StateObject private var coordinator = SheetCoordinator<HelpSheet>()

    var body: some View {
        VStack {
            Button("Show Help Sheet") {
                coordinator.presentSheet(sheet: .help)
            }
        }
        .sheetCoordinating(coordinator: coordinator)
        .edgesIgnoringSafeArea(.bottom) // Ensures the sheet touches the bottom

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


// SwiftUI App structure
//@main
//struct SheetExampleApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}
