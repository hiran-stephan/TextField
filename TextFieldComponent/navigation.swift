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
        // Check if the path is not empty and attempt to access the first item
        if !navigator.path.isEmpty {
            if let firstPathItem = (navigator.path.box as? NavigationPathBackport)?.items.first {
                return firstPathItem.domain == HomeNavigationItems.Companion.shared.DOMAIN
            }
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


import SwiftUI

/// A reusable view for displaying a section header with an uppercase title and custom styling.
struct SectionHeaderView: View {
    /// The title text to display in the section header.
    var title: String

    var body: some View {
        HStack(alignment: .top, spacing: BankingTheme.spacing.noPadding) {
            // Displays the uppercase title with custom font and color
            Text(title.uppercased())
                .font(BankingTheme.typography.allCapsHeading.font)
                .foregroundColor(BankingTheme.colors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .padding(.horizontal, BankingTheme.spacing.noPadding)
        .padding(.top, BankingTheme.spacing.paddingLg)
        .padding(.bottom, BankingTheme.dimensions.smallMedium)
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

// MARK: - Preview

struct SectionHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SectionHeaderView(title: "Section Title")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
