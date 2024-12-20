//
//  AccountPreferencesDetailsScreen.swift
//  Created by Stephan, Hiran on 2024-12-19.
//

import SwiftUI
import Umbrella
import Theme
import Components
import Koin

/// A SwiftUI view that displays the details of account preferences.
struct AccountPreferencesDetailsScreen: View {
    // MARK: - Properties
    
    /// The view model for managing the account preferences details.
    @State private var viewModel: AccountPreferencesDetailsViewModel

    /// An observed object to handle state updates for resource and UI states.
    @ObservedObject private var model: ObservableModelState<AccountPreferencesDetailsResourceUiState, AccountPreferencesDetailsUiState>

    // MARK: - Initializer
    
    /// Initializes the screen with the provided view model.
    /// - Parameter viewModel: The view model for this screen, injected by default.
    init(viewModel: AccountPreferencesDetailsViewModel) {
        self._viewModel = State(initialValue: viewModel)
        self._model = ObservedObject(
            initialValue: ObservableModelState(
                resourcePublisher: asPublisher(viewModel.resourceStateWrapped),
                statePublisher: asPublisher(viewModel.uiStateWrapped)
            )
        )
    }

    // MARK: - Body
    
    var body: some View {
        VStack {
            // Placeholder for the screen content.
            Text("AccountPreferencesDetailsScreen")
            
            Spacer()
        }
    }
}

// MARK: - Preview

/// A preview for the `AccountPreferencesDetailsScreen`.
#Preview {
    AccountPreferencesDetailsScreen(viewModel: AccountPreferencesDetailsViewModel())
}
