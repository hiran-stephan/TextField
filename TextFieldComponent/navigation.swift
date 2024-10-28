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

struct IdentityVerificationView: View {
    var headingText: String
    var biometricsText: String
    var descriptionText: String
    var statusText: String
    var iconImageName: String
    var chevronImageName: String

    var body: some View {
        VStack(spacing: Spacing.noPadding) {
            VStack(alignment: .leading, spacing: Spacing.sectionMarginSm) {
                
                // All Caps Heading
                Text(headingText)
                    .customFont(size: FontSizes.allCapsHeading, weight: .medium)
                    .kerning(1.5)
                    .foregroundColor(Colors.brandCharcoal)
                    .frame(maxWidth: .infinity, minHeight: 20, alignment: .topLeading)

                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .center, spacing: Spacing.padding3Xs) {
                        RoundedIconView(imageName: iconImageName)
                        
                        VStack(alignment: .leading, spacing: Spacing.marginSm) {
                            CustomTextView(text: biometricsText, color: Colors.textPrimary, fontSize: FontSizes.body)
                            CustomTextView(text: descriptionText, color: Colors.textSecondary, fontSize: FontSizes.bodyS)
                            CustomTextView(text: statusText, color: Colors.textSecondary, fontSize: FontSizes.bodyS)
                        }

                        Image(chevronImageName)
                            .frame(width: 24, height: 24)
                            .cornerRadius(CornerRadius.small)
                    }
                    .padding(.horizontal, Spacing.padding2Xs)
                    .padding(.vertical, Spacing.padding2Xs)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Colors.brandWhite)
                    .cornerRadius(CornerRadius.large)
                }
                .padding(.horizontal, Spacing.padding2Xs)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .cornerRadius(CornerRadius.large)
            }
            .padding(.horizontal, Spacing.marginMd)
            .padding(.top, Spacing.padding3Xs)
            .padding(.bottom, Spacing.sectionMarginSm)
            .frame(minWidth: 375, maxWidth: 375, alignment: .topLeading)
            .cornerRadius(CornerRadius.small)
            
            Spacer()
        }
    }
}

// Reusable View for Rounded Icon
struct RoundedIconView: View {
    var imageName: String
    
    var body: some View {
        Image(imageName)
            .frame(width: 24, height: 24)
            .background(Colors.brandWhite)
            .cornerRadius(CornerRadius.mediumScreen)
            .padding(10)
    }
}

// Reusable View for Custom Text
struct CustomTextView: View {
    var text: String
    var color: Color
    var fontSize: CGFloat
    
    var body: some View {
        Text(text)
            .font(Font.custom("Whitney", size: fontSize))
            .foregroundColor(color)
            .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

// Extension for Font Styling
extension Text {
    func customFont(size: CGFloat, weight: Font.Weight) -> some View {
        self.font(Font.custom("Whitney", size: size).weight(weight))
    }
}

// Struct Organization for Constants
struct FontSizes {
    static let allCapsHeading: CGFloat = 15
    static let body: CGFloat = 17
    static let bodyS: CGFloat = 15
}

struct Colors {
    static let brandCharcoal = Color(red: 0.22, green: 0.23, blue: 0.24)
    static let brandWhite = Color.white
    static let textPrimary = Color(red: 0.22, green: 0.23, blue: 0.24)
    static let textSecondary = Color(red: 0.38, green: 0.39, blue: 0.4)
}

struct Spacing {
    static let noPadding: CGFloat = 0
    static let sectionMarginSm: CGFloat = 32
    static let padding3Xs: CGFloat = 12
    static let padding2Xs: CGFloat = 16
    static let marginSm: CGFloat = 12
    static let marginMd: CGFloat = 16
}

struct CornerRadius {
    static let small: CGFloat = 0
    static let large: CGFloat = 12
    static let mediumScreen: CGFloat = 50
}

struct IdentityVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            IdentityVerificationView(
                headingText: "identity verification",
                biometricsText: "Biometrics",
                descriptionText: "Change the option to sign on to your CIBC account using this device's biometric security features.",
                statusText: "ON",
                iconImageName: "Face ID",
                chevronImageName: "TnChevron"
            )
            .previewLayout(.sizeThatFits)
            .padding()
            .previewDisplayName("Default Preview")

            IdentityVerificationView(
                headingText: "alternative verification",
                biometricsText: "Fingerprint",
                descriptionText: "Use fingerprint recognition for added security.",
                statusText: "OFF",
                iconImageName: "Fingerprint",
                chevronImageName: "ChevronRight"
            )
            .previewLayout(.sizeThatFits)
            .padding()
            .previewDisplayName("Alternative Preview")
        }
    }
}

