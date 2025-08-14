else {
    if let targetIndex = navigator.path.firstIndex(where: { $0.route() == item?.route() }) {
        // Remove everything after targetIndex
        navigator.path.removeLast(navigator.path.count - targetIndex - 1)
    } else {
        // If not found, just remove last as before
        navigator.path.removeLast()
    }
}
