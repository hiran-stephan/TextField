public class Coordinator: NSObject {
    var parent: AlertControllerWrapper
    var alertController: UIAlertController? // <-- Add this property

    init(_ parent: AlertControllerWrapper) {
        self.parent = parent
    }

    func createAlertController() -> UIAlertController {
        let title = parent.titleProvider?() ?? parent.title ?? ""
        let message = parent.messageProvider?() ?? parent.message ?? ""
        let actions = parent.actionsProvider?() ?? parent.actions ?? []

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        // Add image to the alert if available
        if let imageName = parent.imageName {
            let image = UIImage(named: imageName)
            let imageView = UIImageView(image: image)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            alertController.view.addSubview(imageView)
            // Add layout constraints for imageView here if needed
        }

        // Add actions
        actions.forEach { actionConfig in
            let action = UIAlertAction(title: actionConfig.title, style: actionConfig.style) { _ in
                actionConfig.handler?()
                self.parent.isPresented = false  // <-- Dismiss alert when action is tapped
                self.alertController = nil       // <-- Reset the stored alert reference
            }
            alertController.addAction(action)
        }

        return alertController
    }
}


public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    if parent.isPresented, context.coordinator.alertController == nil {
        let alertController = context.coordinator.createAlertController()
        context.coordinator.alertController = alertController  // <-- Store reference

        DispatchQueue.main.async {
            uiViewController.present(alertController, animated: true)
        }
    }
    else if !parent.isPresented, let alertController = context.coordinator.alertController {
        alertController.dismiss(animated: true) {
            context.coordinator.alertController = nil  // <-- Reset reference when dismissed
        }
    }
}
