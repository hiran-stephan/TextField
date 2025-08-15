if let firstAuthIndex = navigator.path.firstIndex(where: { item in
    item.domain() == NavigationItems.shared.authentication.DOMAIN_SIGNON
}) {
    // Remove all items after the firstAuthIndex
    navigator.path.removeSubrange((firstAuthIndex + 1)..<navigator.path.count)
}
