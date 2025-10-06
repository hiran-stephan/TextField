/// Otherwise returns an inert placeholder (no layout, no work).
struct DestinationGate<Content: View>: View {
    @EnvironmentObject private var navigator: Navigator
    let item: NavigationItem
    let content: () -> Content

    init(item: NavigationItem, @ViewBuilder content: @escaping () -> Content) {
        self.item = item
        self.content = content
    }

    var body: some View {
        if navigator.path.last?.navKey == item.navKey {
            content()                // ✅ heavy view is built ONLY for top item
        } else {
            Color.clear
                .frame(width: 0, height: 0)
                .accessibilityHidden(true)
                .allowsHitTesting(false)
        }
    }
}


NavigationStack(path: $navigator.path) {
    splashScene()
        .navigationDestination(for: NavigationItem.self) { item in
            DestinationGate(item: item) {
                makeScreen(selectedPath: item)
                    .id(item.navKey)     // keep this for stable identity
            }
        }
}

extension NavigationItem {
    public override var hash: Int { navKey.hashValue }
    public override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? NavigationItem else { return false }
        return navKey == other.navKey
    }
}
