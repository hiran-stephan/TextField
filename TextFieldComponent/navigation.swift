@State private var didCheckFriendlyId = false

.task {
    guard !didCheckFriendlyId else { return }

    if let friendlyId = navigationItem.friendlyId, !friendlyId.isEmpty {
        loginForm.prefillUserNameWith(friendlyId: friendlyId)
    }

    didCheckFriendlyId = true
}
