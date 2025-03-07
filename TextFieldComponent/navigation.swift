// Create a custom UIViewController to wrap the title container
class AlertTitleViewController: UIViewController {
    private let titleText: String

    init(title: String) {
        self.titleText = title
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Title Label (Matches Native Style)
        let titleLabel = UILabel()
        titleLabel.text = titleText
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline) // Uses system font
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.textColor = UIColor.label // Adapts to Light/Dark mode
        titleLabel.accessibilityTraits = .header // Ensure VoiceOver treats it as a header
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Container View
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
    }
}

// Usage: Assign Custom Title View Controller to UIAlertController
let titleViewController = AlertTitleViewController(title: title)
alertController.setValue(titleViewController, forKey: "contentViewController") // ✅ Now it won't crash!
