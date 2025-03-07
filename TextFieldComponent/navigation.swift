func createAlertController() -> UIAlertController {
    let title = parent.titleProvider()
    let message = parent.messageProvider()
    let actions = parent.actionsProvider()

    let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)

    // Custom title label
    let titleLabel = UILabel()
    titleLabel.text = title
    titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
    titleLabel.textAlignment = .center
    titleLabel.numberOfLines = 0
    titleLabel.accessibilityTraits = .header // Ensures VoiceOver reads it as a header

    // Create a container view to replace default title
    let titleContainer = UIView()
    titleContainer.translatesAutoresizingMaskIntoConstraints = false
    titleContainer.addSubview(titleLabel)

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        titleLabel.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor, constant: 16),
        titleLabel.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor, constant: -16),
        titleLabel.topAnchor.constraint(equalTo: titleContainer.topAnchor, constant: 10),
        titleLabel.bottomAnchor.constraint(equalTo: titleContainer.bottomAnchor, constant: -10)
    ])

    // Inject the custom title into UIAlertController
    alertController.setValue(titleContainer, forKey: "contentViewController")

    // Add actions
    actions.forEach { action in
        alertController.addAction(action)
    }

    return alertController
}
