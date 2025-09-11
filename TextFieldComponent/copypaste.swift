public extension Button {
    init(@ViewBuilder _ label: () -> Label) {
        self.init(action: {}, label: label)
    }
}
