let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)

          // Create a custom UILabel for the title
          let titleLabel = UILabel()
          titleLabel.text = title
          titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
          titleLabel.textAlignment = .center
          titleLabel.accessibilityTraits = .header

          // Apply NSAttributedString for custom title styling
          let attributedTitle = NSAttributedString(string: title, attributes: [
              .font: UIFont.boldSystemFont(ofSize: 17),
              .foregroundColor: UIColor.black
          ])
          alertController.setValue(attributedTitle, forKey: "attributedTitle")
