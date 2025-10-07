private var tabSelectionBinding: Binding<String> {
    Binding<String>(
        get: {
            // current selection from KMP state
            sharedState.state?.bottomNavSelectedDomain
            ?? HomeNavigationItems.Main.shared.domain()
        },
        set: { newValue in
            guard let navItem = getNavigationItemFromDomain(domain: newValue) else { return }

            // If user changed tab -> notify click
            if newValue != sharedState.state?.bottomNavSelectedDomain {
                viewModel.onBottomNavigationItemClick(selectedItem: navItem)
            } else {
                // Same tab tapped again -> your reselect behavior
                viewModel.navigationToRDCForiOS(navigationItem: navItem)
            }

            // Persist new selection into KMP shared state
            viewModel.onBottomNavigationItemChanged(selectedItem: navItem)
            // or: viewModel.updateBottomNavigationItem(selectedItem: navItem)
        }
    )
}

