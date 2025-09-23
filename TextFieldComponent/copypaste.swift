private func shouldShow(for code: String?) -> Bool {
    let c = code ?? ""
    guard !c.isEmpty, c != lastShownErrorCode else { return false }
    lastShownErrorCode = c
    return true
}

    .task {
        if shouldShow(for: navigationItem.code) {
            showGlobalErrorDialog()
        }
    }


