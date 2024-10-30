struct AppNavigation: View {
    @EnvironmentObject private var appDelegate: MainAppDelegate
    @EnvironmentObject private var viewModel: AppStateViewModel
    @EnvironmentObject private var navigator: Navigator

    var body: some View {
        ZStack {
            // Define your tab items here for the CustomTabBarController
            CustomTabBarController(
                tabData: [
                    BottomNavTabData(
                        tabItemIcon: TableItemIconData(imageName: "house.fill", imageNameUnfilled: "house"),
                        tabItemText: "Home",
                        tabTag: NavigationItem(domain: "home"),
                        content: AnyView(makeScreen(selectedPath: NavigationItem(domain: "home")))
                    ),
                    BottomNavTabData(
                        tabItemIcon: TableItemIconData(imageName: "gearshape.fill", imageNameUnfilled: "gearshape"),
                        tabItemText: "Settings",
                        tabTag: NavigationItem(domain: "settings"),
                        content: AnyView(makeScreen(selectedPath: NavigationItem(domain: "settings")))
                    )
                    // Add more tabs as needed
                ],
                initialTab: NavigationItem(domain: "home")
            )
            .displaySessionExtensionDialog(viewModel: appDelegate.viewModel) // Custom modifier if needed
            
            if !viewModel.loading.isEmpty {
                LoadingView()
            }
        }
    }
    
    // Making the screen for the selected navigation path
    func makeScreen(selectedPath: NavigationItem) -> AnyView {
        switch selectedPath.domain {
        case AuthenticationNavigationItems.Companion.shared.DOMAIN:
            return AnyView(AuthenticationNavigation(item: selectedPath))
        case HomeNavigationItems.Companion.shared.DOMAIN:
            return AnyView(HomeNavigation(item: selectedPath))
        case AccountDetailsNavigationItems.Companion.shared.DOMAIN:
            return AnyView(AccountDetailsNavigation(item: selectedPath))
        case SettingsNavigationItems.Companion.shared.DOMAIN:
            return AnyView(SettingsNavigation(item: selectedPath))
        case SecurityCenterNavigationItems.Companion.shared.DOMAIN:
            return AnyView(SecurityCenterNavigation(item: selectedPath))
        default:
            return AnyView(Text("None")) // TODO: generic error screen
        }
    }
}

struct CustomTabBarView: View {
    @Binding var selectedTab: NavigationItem
    let tabData: [BottomNavTabData]
    
    var body: some View {
        HStack {
            ForEach(tabData, id: \.tabTag.domain) { tab in
                VStack {
                    Image(systemName: getTabImageName(for: tab))
                    Text(tab.tabItemText)
                        .font(.caption)
                }
                .padding()
                .onTapGesture {
                    selectedTab = tab.tabTag
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .background(Color.white) // Customize the background color here
        .shadow(radius: 5) // Optional: Add shadow for a floating effect
    }
    
    // Helper to get the correct icon image name based on selection
    private func getTabImageName(for tab: BottomNavTabData) -> String {
        return tab.tabTag == selectedTab ? tab.tabItemIcon.imageName : tab.tabItemIcon.imageNameUnfilled
    }
}

struct ContentView: View {
    var body: some View {
        CustomTabBarController(
            tabData: [
                BottomNavTabData(
                    tabItemIcon: TableItemIconData(imageName: "house.fill", imageNameUnfilled: "house"),
                    tabItemText: "Home",
                    tabTag: NavigationItem(domain: "home"),
                    content: AnyView(NavigationView { Text("Home Screen") })
                ),
                BottomNavTabData(
                    tabItemIcon: TableItemIconData(imageName: "person.fill", imageNameUnfilled: "person"),
                    tabItemText: "Profile",
                    tabTag: NavigationItem(domain: "profile"),
                    content: AnyView(NavigationView { Text("Profile Screen") })
                )
            ],
            initialTab: NavigationItem(domain: "home")
        )
    }
}
