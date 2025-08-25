fun onBottomNavTabSelected(domain: String) {
        _sharedState.update {
            it.copy(bottomNavSelectedDomain = domain)
        }
    }

fun onBottomNavTabSelected(item: NavigationItem) =
    onBottomNavTabSelected(item.domain())

@State private var tabSelected: String

_tabSelected = State(initialValue: viewModel.sharedStateWrapped.value.bottomNavSelectedDomain)

    .onChange(of: tabSelected) { newValue in
                viewModel.onBottomNavTabSelected(domain: newValue)
            }


// Use the domain stored in SharedUiState
    private var tabBinding: Binding<String> {
        Binding(
            get: { sharedState.value.bottomNavSelectedDomain },
            set: { newValue in
                viewModel.updateBottomNavSelection(domain: newValue)
            }
        )
    }
