private var tabSelected: Binding<String> {
    Binding(
        get: {
            sharedState.value.bottomNavSelectedDomain   // or sharedState.state?.bottomNavSelectedDomain ?? ...
        },
        set: { newValue in
            // 1) If the tab is already selected, do nothing
            let current = sharedState.value.bottomNavSelectedDomain
            guard current != newValue else { return }

            // 2) Convert to item and forward
            guard let item = getNavigationItemFromDomain(domain: newValue) else { return }
            viewModel.onBottomNavNavigationItemClick(selectedItem: item)
        }
    )
}

fun updateBottomNavSelection(domain: String) {
    _sharedState.update { state ->
        if (state.bottomNavSelectedDomain == domain) state
        else state.copy(bottomNavSelectedDomain = domain)
    }
}
