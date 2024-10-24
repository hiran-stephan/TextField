//
//  navigation.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 24/10/24.
//

import Foundation
struct AppNavigation: View {
    @EnvironmentObject private var viewModel: AppStateViewModel
    @EnvironmentObject private var navigator: Navigator
    
    var body: some View {
        ZStack {
            NavigationStackBackport.NavigationStack(path: $navigator.path) {
                if isHomeNavigation {
                    makeBottomNavTabBarView(createTabScreen: { tab in
                        // Use the correct closure expected by makeBottomNavTabBarView
                        AnyView(HomeNavigation(item: HomeNavigationItems.Main.shared))
                    })
                } else {
                    SplashScene()
                        .backport.navigationDestination(for: NavigationItem.self) { value in
                            makeScreen(selectedPath: value)
                        }
                }
            }

            if !viewModel.loading.isEmpty {
                LoadingView()
            }
        }
    }
    
    private var isHomeNavigation: Bool {
        let currentPath = navigator.path // Directly access the current path
        if let firstPathItem = currentPath.first {
            return firstPathItem.domain == HomeNavigationItems.Companion.shared.DOMAIN
        }
        return false
    }
    
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
        default:
            return AnyView(Text("None")) // todo generic error screen
        }
    }
}

