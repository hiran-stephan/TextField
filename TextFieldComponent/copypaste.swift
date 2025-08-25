.backport.navigationDestination(for: NavigationItem.self) { value in
    if RouterLookup.find(value.domain())?.hasBottomNavigation == true {
        // seed BottomNavBarView with the boundary item’s domain
        BottomNavBarView(viewModel: viewModel, initialSelectedDomain: value.domain())
    } else {
        makeScreen(selectedPath: value)
    }
}

struct BottomNavBarView: View {
    var viewModel: SharedStateViewModel

    // ⬇️ receive initial value from parent
    private let initialSelectedDomain: String

    // ⬇️ initialize @State from the injected value
    @State private var tabSelected: String

    init(viewModel: SharedStateViewModel, initialSelectedDomain: String) {
        self.viewModel = viewModel
        self.initialSelectedDomain = initialSelectedDomain
        _tabSelected = State(initialValue: initialSelectedDomain)
        self.sharedState = ObservableState(statePublisher: viewModel.sharedStateWrapped)
    }

    // ... TabView(selection: $tabSelected) ...
}

