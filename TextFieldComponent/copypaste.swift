NavigationStackBackport.NavigationStack(path: $navigator.path) {
    SplashScene()
        .backport.navigationDestination(for: NavigationItem.self) { value in
            destinationView(for: value)
        }
}

@ViewBuilder
private func destinationView(for value: NavigationItem) -> some View {
    if KoinApplication.findRouter(domain: value.domain()).hasBottomNavigation {
        BottomNavView(model: viewModel)
    } else {
        makeScreen(selectedPath: value)
            .dismissKeyboardOnTap()
    }
}
