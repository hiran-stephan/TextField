// Ensure Dynamic Type Scaling & System Adaptation
let titleFont = UIFont.preferredFont(forTextStyle: .headline)
let titleColor = UIColor.label // Auto-adapts to Light/Dark Mode

let attributedTitle = NSAttributedString(string: title, attributes: [
    .font: titleFont,
    .foregroundColor: titleColor
])

if alertController.responds(to: Selector(("setAttributedTitle:"))) {
    alertController.setValue(attributedTitle, forKey: "attributedTitle")
} else {
    print("Warning: attributedTitle is not supported on this iOS version.")
}
