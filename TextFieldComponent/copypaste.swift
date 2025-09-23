// Local helper to build the ProblemData for the global error dialog.
// Keeps KMP models unchanged and avoids leaking a convenience init app-wide.
private func makeGlobalProblemData(code: String) -> ProblemData {
    ProblemData(
        type: "",          // explicit values for clarity
        field: "",
        code: code,
        index: nil,
        subcode: nil,
        details: nil
    )
}


func showGlobalErrorDialog(for code: String) {
    guard !code.isEmpty else { return }
    viewModel.showGlobalErrorDialog(
        errorList: [ makeGlobalProblemData(code: code) ]   // or write the full initializer inline
    )
}
