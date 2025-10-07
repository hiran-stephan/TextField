private var tabSelected: Binding<String> {
       Binding(
           get: {
               // KMP current tab
               sharedState.state?.bottomNavSelectedDomain
               ?? HomeNavigationItems.Main.shared.domain()
           },
           set: { newDomain in
               guard let item = getNavigationItemFromDomain(domain: newDomain) else { return }
               // Mirrors your old write to @State, but to KMP
               viewModel.onBottomNavigationItemChanged(selectedItem: item)
           }
       )
   }

   private var previousTabSelected: Binding<String> {
       Binding(
           get: {
               // KMP previous tab
               sharedState.state?.previousBottomNavSelectedDomain
               ?? HomeNavigationItems.Main.shared.domain()
           },
           set: { newDomain in
               guard let item = getNavigationItemFromDomain(domain: newDomain) else { return }
               // New KMP method you’ll add
               viewModel.onPreviousBottomNavigationItemChanged(selectedItem: item)
           }
       )
   }

   .onChange(of: tabSelected.wrappedValue) { newValue in
               // == your existing logic, just reading/writing through the bindings ==
               guard let navigationItem = getNavigationItemFromDomain(domain: newValue) else { return }

               if tabSelected.wrappedValue != previousTabSelected.wrappedValue {
                   viewModel.onBottomNavigationItemClick(selectedItem: navigationItem)
                   previousTabSelected.wrappedValue = newValue
               } else {
                   viewModel.navigationToRDCForiOS(navigationItem: navigationItem)
               }
           }
