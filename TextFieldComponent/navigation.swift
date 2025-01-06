public struct AccountPreferenceCardContainerView<Content: View>: View {
    let headerText: String
    let infoIconAccessibilityText: String?
    let infoIconDialogBodyText: String?
    let infoIconDialogCancelButtonText: String?
    let showHeaderTrailingIcon: Bool?
    let trailingIconAction: (() -> Void)?
    @ViewBuilder let content: Content
    
    @State private var showTooltipAlert = false
    
    public init(
        headerText: String,
        infoIconAccessibilityText: String? = nil,
        infoIconDialogBodyText: String? = nil,
        infoIconDialogCancelButtonText: String? = nil,
        showHeaderTrailingIcon: Bool? = nil,
        trailingIconAction: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.headerText = headerText
        self.infoIconAccessibilityText = infoIconAccessibilityText
        self.infoIconDialogBodyText = infoIconDialogBodyText
        self.infoIconDialogCancelButtonText = infoIconDialogCancelButtonText
        self.showHeaderTrailingIcon = showHeaderTrailingIcon
        self.trailingIconAction = trailingIconAction
        self.content = content()
    }
}
