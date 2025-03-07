import UIKit

/// A custom UIAlertController that overrides the title view for better accessibility
class AccessibleAlertController: UIAlertController {
    
    private let customTitle: String

    init(title: String, message: String?, preferredStyle: UIAlertController.Style) {
        self.customTitle = title
        super.init(nibName: nil, bundle: nil)

        self.message = message
        setupCustomTitleView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCustomTitleView() {
        let titleLabel = UILabel()
        titleLabel.text = customTitle
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.accessibilityTraits = .header  // Set title as a header for VoiceOver
        
        // Create a container view
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

        // Set custom view as the title
        self.setValue(titleContainer, forKey: "contentViewController")
    }
}

import SwiftUI

struct AlertControllerWrapper: UIViewControllerRepresentable {
    var isPresented: Bool
    var title: String
    var message: String?
    var actions: [UIAlertAction]

    func makeUIViewController(context: Context) -> UIViewController {
        return UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresented {
            let alertController = AccessibleAlertController(title: title, message: message, preferredStyle: .alert)

            actions.forEach { alertController.addAction($0) }
            uiViewController.present(alertController, animated: true, completion: nil)
        }
    }
}

