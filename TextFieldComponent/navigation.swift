struct AccountType: DropdownItem, Hashable, Equatable {
    let id: UUID
    let displayTitle: String

    init(displayTitle: String) {
        self.id = UUID()
        self.displayTitle = displayTitle
    }
}
