public struct AlertControllerWrapper: UIViewControllerRepresentable {
    @Binding public var isPresented: Bool
    public var title: String?
    public var message: String?
    public var actions: [AlertAction]?
    public var titleProvider: (() -> String)?
    public var messageProvider: (() -> String)?
    public var actionsProvider: (() -> [AlertAction])?
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
            let title = parent.titleProvider?() ?? parent.title ?? ""
            let message = parent.messageProvider?() ?? parent.message ?? ""
            let actions = parent.actionsProvider?() ?? parent.actions ?? []

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
    public func presentAlert(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        imageName: String? = nil,
        actions: [AlertAction]
    ) -> some View {
        self.background(
            AlertControllerWrapper(
                isPresented: isPresented,
                title: title,
                message: message,
                actions: actions,
                imageName: imageName
            )
        )
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
                "Dynamic Title at \(Date())"
            },
            messageProvider: {
                "This is a dynamic message generated at \(Date())."
            },
            actionsProvider: {
                [
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
            }
        )
    }
}
