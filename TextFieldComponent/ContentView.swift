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

//struct ContentView: View {
//    @State private var isSheetOpen: Bool = false
//
//    var body: some View {
//        ZStack {
//            VStack {
//                Text("Main Content")
//                Button(action: {
//                    self.isSheetOpen.toggle()
//                }) {
//                    Text("Show Custom Sheet")
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
//            }
//
//            CustomSheet(isOpen: $isSheetOpen, maxHeight: 600, minHeight: 300, sheetWidth: 400) {  // Fixed width of 400 points
//                VStack {
//                    Text("This is a custom sheet with adjustable width")
//                        .font(.headline)
//                        .padding()
//
//                    Button(action: {
//                        self.isSheetOpen = false
//                    }) {
//                        Text("Close Sheet")
//                            .padding()
//                            .background(Color.red)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
//                }
//            }
//        }
//    }
//}








struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
