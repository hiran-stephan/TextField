struct DestinationView: View {
    let item: NavigationItem

    var body: some View {
        if KoinApplication.findRouter(domain: item.domain()).hasBottomNavigation {
            BottomNavBarView(viewModel: SharedStateViewModel())
        } else {
            makeScreen(selectedPath: item)
                .dismissKeyboardOnTap()
        }
    }
}
