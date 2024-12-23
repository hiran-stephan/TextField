import SwiftUI
import Umbrella
import CustomizeBankingUI
import BiometricsSetupUI
import CustomerServiceUI
import SecurityCenterUI
import AccountPreferencesUI

public struct SettingsNavigation: View {
    private let item: NavigationItem

    public init(item: NavigationItem) {
        self.item = item
    }

    public var body: some View {
        switch item.route {
        case SettingsNavigationItems.Main.shared.route:
            Text("TBD") // Placeholder for Main Scene
        case SettingsNavigationItems.Customize.shared.route:
            CustomizeBankingScene()
                .navigationBarBackButtonHidden()
        case SettingsNavigationItems.BiometricsSetup.shared.route:
            BiometricsSetupInstructionsScene()
                .navigationBarBackButtonHidden()
        case SettingsNavigationItems.BiometricsSetupPassword.shared.route:
            BiometricsSetupPasswordScene()
                .navigationBarBackButtonHidden()
        case SettingsNavigationItems.SecurityCenterSetup.shared.route:
            SecurityCenterScene()
                .navigationBarBackButtonHidden()
        case SettingsNavigationItems.AccountPreferences.shared.route:
            AccountPreferencesScene()
                .navigationBarBackButtonHidden()
        case let route where route.starts(with: SettingsNavigationItems.AccountPreferencesDetails.shared.route):
            if let detailsItem = item as? SettingsNavigationItems.AccountPreferencesDetails {
                AccountPreferencesDetailsScene(navigationItem: detailsItem)
                    .navigationBarBackButtonHidden()
            } else {
                Text("Invalid Details Route")
            }
        default:
            Text("No scene found")
        }
    }
}
