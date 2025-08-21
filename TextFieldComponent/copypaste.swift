@MainActor
private func trimAtBoundary(_ idx: Int) {
    // keep everything up to and including idx
    let newPath = Array(navigator.path.prefix(idx + 1))

    // Avoid no-op assigns; iOS 18 sometimes ignores them
    guard newPath != navigator.path else { return }

    // Do it in a transaction so iOS 18 reliably pops
    withTransaction(Transaction(animation: .default)) {
        navigator.path = newPath
    }
}

if idx + 1 < self.navigator.path.count {
    // old:
    // self.navigator.path.removeSubrange(idx + 1..<self.navigator.path.count)

    // new:
    trimAtBoundary(idx)
}
