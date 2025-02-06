func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    // If we *want* to be showing an alert but haven't shown one yet, do it:
    if isPresented && context.coordinator.alertController == nil {
        let alert = context.coordinator.createAlertController()
        context.coordinator.alertController = alert
        uiViewController.present(alert, animated: true)
    }
    // If we no longer want an alert, but one is still up, dismiss it:
    else if !isPresented, let alert = context.coordinator.alertController {
        alert.dismiss(animated: true)
        context.coordinator.alertController = nil
    }
}
