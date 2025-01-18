public struct AlertControllerWrapper: UIViewControllerRepresentable {
    @Binding public var isPresented: Bool
    public var titleProvider: () -> String
    public var messageProvider: () -> String
    public var actionsProvider: () -> [AlertAction]
    public let imageName: String?

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }

    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresented {
            let alertController = context.coordinator.createAlertController()
            DispatchQueue.main.async {
                uiViewController.present(alertController, animated: true)
                isPresented = false // Automatically dismiss the flag after presenting
            }
        }
    }

    public class Coordinator: NSObject {
        var parent: AlertControllerWrapper

        init(_ parent: AlertControllerWrapper) {
            self.parent = parent
        }

        func createAlertController() -> UIAlertController {
            let title = parent.titleProvider()
            let message = parent.messageProvider()
            let actions = parent.actionsProvider()

            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

            if let imageName = parent.imageName {
                let image = UIImage(named: imageName)
                let imageView = UIImageView(image: image)
                imageView.translatesAutoresizingMaskIntoConstraints = false
                alertController.view.addSubview(imageView)

                // Add constraints for imageView as per your design
            }

            actions.forEach { actionConfig in
                let action = UIAlertAction(title: actionConfig.title, style: actionConfig.style) { _ in
                    actionConfig.handler?()
                }
                alertController.addAction(action)
            }

            return alertController
        }
    }
}

extension View {
    public func presentDynamicAlert(
        isPresented: Binding<Bool>,
        titleProvider: @escaping () -> String,
        messageProvider: @escaping () -> String,
        actionsProvider: @escaping () -> [AlertAction],
        imageName: String? = nil
    ) -> some View {
        self.background(
            AlertControllerWrapper(
                isPresented: isPresented,
                titleProvider: titleProvider,
                messageProvider: messageProvider,
                actionsProvider: actionsProvider,
                imageName: imageName
            )
        )
    }
}

struct ContentView: View {
    @State private var isAlertPresented: Bool = false

    var body: some View {
        VStack {
            Button("Show Dynamic Alert") {
                isAlertPresented = true
            }
        }
        .presentDynamicAlert(
            isPresented: $isAlertPresented,
            titleProvider: {
                // Dynamically provide the title
                return "Dynamic Title at \(Date())"
            },
            messageProvider: {
                // Dynamically provide the message
                return "This is a dynamic message generated at \(Date())."
            },
            actionsProvider: {
                // Dynamically provide actions
                return [
                    AlertAction(
                        title: "OK",
                        style: .default,
                        handler: { print("OK Tapped") }
                    ),
                    AlertAction(
                        title: "Cancel",
                        style: .cancel,
                        handler: { print("Cancel Tapped") }
                    )
                ]
            },
            imageName: "yourImageName"
        )
    }
}
