let titleLabel = UILabel()
titleLabel.text = title
titleLabel.font = UIFont.preferredFont(forTextStyle: .headline) // Matches system font
titleLabel.textAlignment = .center
titleLabel.numberOfLines = 0
titleLabel.textColor = UIColor.label // Auto-adapts to Light/Dark Mode
titleLabel.accessibilityTraits = .header

let titleContainer = UIView()
titleContainer.addSubview(titleLabel)

titleLabel.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
    titleLabel.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor),
    titleLabel.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor),
    titleLabel.topAnchor.constraint(equalTo: titleContainer.topAnchor),
    titleLabel.bottomAnchor.constraint(equalTo: titleContainer.bottomAnchor)
])

alertController.setValue(titleContainer, forKey: "contentViewController") // Safe & Native Look
