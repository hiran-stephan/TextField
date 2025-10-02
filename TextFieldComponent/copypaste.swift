// MARK: - Pure Destination

struct DestinationView<Content: View>: View {
    let item: NavigationItem
    @ObservedObject var viewModel: SharedStateViewModel

    // Build the concrete screen (e.g., your switch/mapper)
    let makeScreen: (NavigationItem) -> Content

    // Freeze the routing decision so it's not recomputed during body reloads
    private let hasBottomNav: Bool

    init(
        item: NavigationItem,
        viewModel: SharedStateViewModel,
        makeScreen: @escaping (NavigationItem) -> Content
    ) {
        self.item = item
        self.viewModel = viewModel
        self.makeScreen = makeScreen
        // 👇 Compute once; keeps body idempotent
        self.hasBottomNav = KoinApplication.findRouter(domain: item.domain()).hasBottomNavigation
    }

    var body: some View {
        Group {
            if hasBottomNav {
                BottomNavBarView(viewModel: viewModel)
            } else {
                makeScreen(item)
                    .dismissKeyboardOnTap()
            }
        }
        // Keep a stable identity per pushed item to avoid view reuse mishaps
        .id(item.navigationId) // use your stable id property here
    }
}


NavigationStack(path: $navigator.path) {
    // ... your root content ...

    .navigationDestination(for: NavigationItem.self) { item in
        DestinationView(
            item: item,
            viewModel: viewModel,                    // <-- passes your existing VM
            makeScreen: { selected in
                // Reuse your existing screen factory
                makeScreen(selectedPath: selected)
            }
        )
    }
}
