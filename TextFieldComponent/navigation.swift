// 1️⃣ Ensure Dynamic Type Scaling (Matches Native iOS Alert)
let titleFont = UIFont.preferredFont(forTextStyle: .headline) // ✅ Uses iOS system font
let titleColor = UIColor.label // ✅ Auto-adapts to Light/Dark Mode

// 2️⃣ Create an NSAttributedString for the title (Matches Native iOS Styling)
let attributedTitle = NSAttributedString(string: title, attributes: [
    .font: titleFont, // ✅ Uses system font size and weight
    .foregroundColor: titleColor // ✅ Uses system adaptive color
])

// 3️⃣ Set the attributed title (Only if iOS allows it)
if alertController.responds(to: Selector(("setAttributedTitle:"))) {
    alertController.setValue(attributedTitle, forKey: "attributedTitle") // ✅ Ensures native iOS look
} else {
    print("Warning: attributedTitle is not supported on this iOS version.")
}

// 4️⃣ Create a Hidden Accessibility Label to Ensure VoiceOver Reads Title as a Header
let accessibilityTitleLabel = UILabel()
accessibilityTitleLabel.text = title
accessibilityTitleLabel.font = titleFont // ✅ Uses preferred system font
accessibilityTitleLabel.textAlignment = .center
accessibilityTitleLabel.numberOfLines = 0
accessibilityTitleLabel.isAccessibilityElement = true
accessibilityTitleLabel.accessibilityTraits = .header // ✅ VoiceOver treats it as a header

// 5️⃣ Attach the accessibility label to alertController’s view
alertController.view.addSubview(accessibilityTitleLabel)

// 6️⃣ Auto-layout to position it properly (Hidden but accessible to VoiceOver)
accessibilityTitleLabel.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
    accessibilityTitleLabel.centerXAnchor.constraint(equalTo: alertController.view.centerXAnchor),
    accessibilityTitleLabel.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 20),
    accessibilityTitleLabel.widthAnchor.constraint(equalTo: alertController.view.widthAnchor, multiplier: 0.8),
    accessibilityTitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20)
])

// 7️⃣ Hide it from UI (But VoiceOver can still read it)
accessibilityTitleLabel.isHidden = true
