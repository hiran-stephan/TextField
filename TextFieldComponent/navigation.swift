

import Foundation

struct ListCellBottomSheetData {
    let title: String
    let titleAccessibilityText: String
    let menuActions: [ListCellData]
}

struct ListCellData {
    let actionCellId: String
    let leadingIcon: String?
    let trailingIcon: String?
    let primaryLabel: String
    let secondaryLabel: String?
    let leadingIconAccessibilityText: String?
    let trailingIconAccessibilityText: String?
    let route: String
}

extension PreSignonMenuPresenter {
    func toListCellBottomSheetData(locale: Locale) -> ListCellBottomSheetData {
        return ListCellBottomSheetData(
            title: self.menuTitle.localized(locale: locale),
            titleAccessibilityText: self.menuTitleAccessibilityText.localized(locale: locale),
            menuActions: self.menuActionList.map { item in
                ListCellData(
                    actionCellId: item.id,
                    leadingIcon: item.leadingIcon?.localized(locale: locale).flatMap { mapToDrawableResource($0) },
                    trailingIcon: item.trailingIcon?.localized(locale: locale).flatMap { mapToDrawableResource($0) },
                    primaryLabel: item.primaryText.localized(locale: locale),
                    secondaryLabel: item.secondaryText?.localized(locale: locale),
                    leadingIconAccessibilityText: item.leadingIcon?.localizedAccessibility(locale: locale),
                    trailingIconAccessibilityText: item.trailingIcon?.localizedAccessibility(locale: locale),
                    route: item.actionLink
                )
            ],
            initialTab: NavigationItem(domain: "home")
        )
    }
}


struct TabContentView: View {
    let selectedTab: NavigationItem
    let tabData: [BottomNavTabData]
    
    var body: some View {
        ForEach(tabData, id: \.tabTag.domain) { tab in
            if tab.tabTag == selectedTab {
                tab.content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

struct CustomTabBarController: View {
    // State to track the selected tab
    @State private var selectedTab: NavigationItem
    
    // Array of tab data to configure each tab
    private let tabData: [BottomNavTabData]
    
    init(tabData: [BottomNavTabData], initialTab: NavigationItem) {
        self.tabData = tabData
        self._selectedTab = State(initialValue: initialTab)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Display the selected tab content
            TabContentView(selectedTab: selectedTab, tabData: tabData)
            
            // Custom tab bar overlay at the bottom
            CustomTabBarView(selectedTab: $selectedTab, tabData: tabData)
        }
        .ignoresSafeArea(edges: .bottom) // Make the tab bar stick to the bottom
    }
}


import SwiftUI

struct NavigationItem: Hashable {
    let domain: String
}

struct BottomNavTabData {
    let tabItemIcon: TableItemIconData
    let tabItemText: String
    let tabTag: NavigationItem
    let content: AnyView // Use `AnyView` to allow dynamic content types
}

struct TableItemIconData {
    let imageName: String
    let imageNameUnfilled: String
}


import SwiftUI

struct AppNavigation: View {
    @EnvironmentObject private var appDelegate: MainAppDelegate
    @EnvironmentObject private var viewModel: AppStateViewModel
    @EnvironmentObject private var navigator: Navigator

    var body: some View {
        ZStack {
            // Main navigation stack for the app
            NavigationStack(path: $navigator.path) {
                SplashScene() // Show initial splash or loading screen
                
                .navigationDestination(for: NavigationItem.self) { value in
                    if let featureRouter = getRouter(for: value.domain),
                       featureRouter.hasBottomNavigation {
                        // Use BottomNavigationLayout if the feature requires bottom navigation
                        BottomNavigationLayout(
                            currentDomain: value.domain,
                            navigateToDeeplink: { featureRouter.navigateTo($0) },
                            bottomNavigationBarItems: featureRouter.bottomNavigationBarItems
                        )
                    } else {
                        // Directly show the screen for the selected path
                        makeScreen(selectedPath: value)
                    }
                }
            }
            .displaySessionExtensionDialog(viewModel: appDelegate.viewModel) // Custom dialog, if needed

            // Display a loading view overlay if loading
            if !viewModel.loading.isEmpty {
                LoadingView()
            }
        }
    }

    // Helper method to retrieve the appropriate router for the specified domain
    private func getRouter(for domain: String) -> FeatureRouter? {
        return KoinApplication.findRouter(domain: "


    import SwiftUI

// MARK: - BottomNavigationLayout Component
struct BottomNavigationLayout: View {
    let currentDomain: String
    let navigateToDeeplink: (NavigationItem) -> Void
    let bottomNavigationBarItems: [BottomNavTabData]

    var body: some View {
        CustomTabBarController(
            tabData: bottomNavigationBarItems,
            initialTab: bottomNavigationBarItems.first?.tabTag ?? NavigationItem(domain: currentDomain)
        )
    }
}
                                          
struct CustomTabBarController: View {
    @State private var selectedTab: NavigationItem
    private let tabData: [BottomNavTabData]
    
    init(tabData: [BottomNavTabData], initialTab: NavigationItem) {
        self.tabData = tabData
        self._selectedTab = State(initialValue: initialTab)
    }
    
    private func mapToDrawableResource(_ iconName: String) -> String {
        // Implement mapping logic to get the drawable resource name or path
        return iconName
    }
}

// Usage Example
// let bottomSheetData = presenter.toListCellBottomSheetData(locale: Locale.current)

