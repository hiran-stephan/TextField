import SwiftUI
import UIKit

// Defines an action for UIAlertController
struct AlertAction {
    let title: String
    let style: UIAlertAction.Style
    let handler: (() -> Void)?
    
    init(title: String, style: UIAlertAction.Style = .default, handler: (() -> Void)? = nil) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}

// Wrapper to present a UIKit UIAlertController in SwiftUI
struct AlertControllerWrapper: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let title: String
    let message: String
    let actions: [AlertAction]
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresented {
            let alertController = context.coordinator.createAlertController()
            DispatchQueue.main.async {
                uiViewController.present(alertController, animated: true) {
                    isPresented = false
                }
            }
        }
    }
    
    class Coordinator: NSObject {
        var parent: AlertControllerWrapper
        
        init(_ parent: AlertControllerWrapper) {
            self.parent = parent
        }
        
        func createAlertController() -> UIAlertController {
            let alertController = UIAlertController(title: parent.title, message: parent.message, preferredStyle: .alert)
            parent.actions.forEach { actionConfig in
                let action = UIAlertAction(title: actionConfig.title, style: actionConfig.style) { _ in
                    actionConfig.handler?()
                }
                alertController.addAction(action)
            }
            return alertController
        }
    }
}

// Extension to easily present a UIKit UIAlertController
extension View {
    func presentAlert(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        actions: [AlertAction]
    ) -> some View {
        self.background(AlertControllerWrapper(isPresented: isPresented, title: title, message: message, actions: actions))
    }
}

// Example usage in SwiftUI view
struct ContentView: View {
    @State private var showAlert = false
    
    var body: some View {
        VStack(spacing: 20) {
            Button("Show UIKit Alert") {
                showAlert = true
            }
            .presentAlert(
                isPresented: $showAlert,
                title: "UIKit Alert",
                message: "This is a UIKit UIAlertController in SwiftUI.",
                actions: [
                    AlertAction(title: "OK", style: .default, handler: { print("OK Pressed") }),
                    AlertAction(title: "Cancel", style: .cancel, handler: { print("Cancel Pressed") }),
                    AlertAction(title: "Delete", style: .destructive, handler: { print("Delete Pressed") })
                ]
            )
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
