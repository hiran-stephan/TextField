//
//  AccountPreferencesDetailsScene.swift
//  Created by Stephan, Hiran on 2024-12-19.
//

import SwiftUI
import Components
import Theme
import Umbrella
import Koin

/// A view representing the Account Preferences Details scene.
public struct AccountPreferencesDetailsScene: View {
    // MARK: - Properties
    
    /// The view model for the Account Preferences Details scene.
    let viewModel: AccountPreferencesDetailsViewModel

    // MARK: - Initializer
    
    /// Initializes the `AccountPreferencesDetailsScene` with an optional dependency injection.
    /// - Parameter viewModel: The view model for this scene, injected via Koin by default.
    public init(viewModel: AccountPreferencesDetailsViewModel = KoinApplication.inject()) {
        self.viewModel = viewModel
    }

    // MARK: - Body
    
    public var body: some View {
        ZStack {
            VStack {
                // Retrieve and use the screen presenter from the view model.
                let presenter = viewModel.createScreenPresenter()
                
                // Display the masthead with a title and back button.
                MastheadRegularView(
                    title: presenter.screenTitle,
                    leadingView: BackButton()
                )
                
                Spacer()
                
                // The main content of the screen.
                AccountPreferencesDetailsScreen(
                    viewModel: viewModel
                )
            }
        }
        .onAppear {
            // Attach the view model to the view lifecycle.
            viewModel.attachViewModel()
        }
    }
}

// MARK: - Preview

/// A preview for the `AccountPreferencesDetailsScene`.
#Preview {
    AccountPreferencesDetailsScene()
}
