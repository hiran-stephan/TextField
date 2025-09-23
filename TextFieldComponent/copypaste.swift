@State private var globalErrorCode: String = ""
/// Tracks the last error code shown in order to avoid showing the same alert repeatedly.


    .task {
        checkFriendlyId()
        // Only show dialog if code is non-empty AND different from the last shown code
        if shouldShowGlobalErrorDialog(for: navigationItem.code) {
            showGlobalErrorDialog(for: navigationItem.code)
        }
    }

func showGlobalErrorDialog(for code: String) {
    /// Presents a global error dialog for the given code.
    /// - Parameter code: The error code to display (must be non-empty).
    if !code.isEmpty {
        viewModel.showGlobalErrorDialog(
            errorList: [ProblemData(code: navigationItem.code)]
        )
    }
}

private func shouldShowGlobalErrorDialog(for code: String) -> Bool {
    /// Checks whether a global error dialog should be shown.
    /// Returns `true` only if:
    ///   1. The code is non-empty, AND
    ///   2. The code is different from the last shown (`globalErrorCode`).
    guard !code.isEmpty, code != globalErrorCode else { return false }
    globalErrorCode = code
    return true
}
