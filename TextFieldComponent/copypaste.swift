private var textField: some View {
    var v = TextField(placeholder, text: $text)
    if #available(iOS 17.0, *) {
        v = v.accessibilityLabeledPair(role: .content, id: a11y)
    }
    // Use explicit label if provided; otherwise pairing (iOS17+) will use titleView.
    if let explicit = accessibilityLabel?.trimmedNonEmpty {
        v = v.accessibilityLabel(Text(explicit))
    } else if #unavailable(iOS 17.0) {
        // pre-iOS 17 fallback: set label from titleText
        v = v.accessibilityLabel(Text(titleText ?? ""))
    }
    // HINT only on the field (prevents repetition)
    return v.accessibilityHint(Text((accessibilityHint?.trimmedNonEmpty) ?? placeholder))
}

private var secureTextField: some View {
    var v = SecureField(placeholder, text: $text)
    if #available(iOS 17.0, *) {
        v = v.accessibilityLabeledPair(role: .content, id: a11y)
    }
    if let explicit = accessibilityLabel?.trimmedNonEmpty {
        v = v.accessibilityLabel(Text(explicit))
    } else if #unavailable(iOS 17.0) {
        v = v.accessibilityLabel(Text(titleText ?? ""))
    }
    return v.accessibilityHint(Text((accessibilityHint?.trimmedNonEmpty) ?? placeholder))
}
