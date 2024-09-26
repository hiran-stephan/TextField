import SwiftUI
import UIKit

/// Defines an action for `UIAlertController`, including the title, style, and an optional handler.
///
/// Use this struct to configure an action for a UIKit alert presented in SwiftUI.
struct AlertAction {
    let title: String
    let style: UIAlertAction.Style
    let handler: (() -> Void)?
    
    /// Initializes an `AlertAction` with a title, style, and an optional handler.
    ///
    /// - Parameters:
    ///   - title: The text to display on the alert button.
    ///   - style: The style of the action button. Defaults to `.default`.
    ///   - handler: The closure to execute when the button is tapped. Defaults to `nil`.
    init(title: String, style: UIAlertAction.Style = .default, handler: (() -> Void)? = nil) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}

/// A wrapper to present a UIKit `UIAlertController` in SwiftUI.
///
/// This struct conforms to `UIViewControllerRepresentable`, allowing it to be used within SwiftUI.
/// It is responsible for creating and presenting a UIKit alert.
struct AlertControllerWrapper: UIViewControllerRepresentable {
    /// A binding to track whether the alert is presented.
    @Binding var isPresented: Bool
    /// The title of the alert.
    let title: String
    /// The message body of the alert.
    let message: String
    /// The actions (buttons) for the alert.
    let actions: [AlertAction]
    
    /// Creates a coordinator to manage the presentation of the `UIAlertController`.
    ///
    /// The coordinator ensures that UIKit components can interact with SwiftUI.
    /// - Returns: A new instance of `Coordinator`.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    /// Creates a placeholder `UIViewController` for the alert to be presented on.
    ///
    /// - Parameter context: The context of the `UIViewControllerRepresentable`.
    /// - Returns: A placeholder `UIViewController`.
    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }
    
    /// Updates the `UIViewController` when the `isPresented` state changes.
    ///
    /// If `isPresented` is `true`, an alert will be created and presented.
    ///
    /// - Parameters:
    ///   - uiViewController: The placeholder `UIViewController` for presenting the alert.
    ///   - context: The context of the `UIViewControllerRepresentable`.
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
    
    /// A coordinator to manage the presentation of the alert.
    class Coordinator: NSObject {
        var parent: AlertControllerWrapper
        
        /// Initializes a coordinator for `AlertControllerWrapper`.
        ///
        /// - Parameter parent: The parent `AlertControllerWrapper`.
        init(_ parent: AlertControllerWrapper) {
            self.parent = parent
        }
        
        /// Creates a configured `UIAlertController` based on the parent's properties.
        ///
        /// - Returns: A fully configured `UIAlertController`.
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

// MARK: - View Extension

/// An extension to present a UIKit `UIAlertController` in SwiftUI.
///
/// This extension allows you to easily present an alert by calling the `presentAlert` method on any SwiftUI `View`.
extension View {
    /// Presents a UIKit `UIAlertController` within SwiftUI.
    ///
    /// - Parameters:
    ///   - isPresented: A binding that determines whether the alert is shown.
    ///   - title: The title of the alert.
    ///   - message: The message body of the alert.
    ///   - actions: The actions (buttons) to display in the alert.
    /// - Returns: A modified view that presents the alert.
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
