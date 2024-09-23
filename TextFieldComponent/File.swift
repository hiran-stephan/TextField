//
//  File.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 09/09/24.
//

import Foundation
//
//import SwiftUI
//import Umbrella
//import Components
//import Theme
//import Koin
//
//struct LoginScreen: View {
//    // The theme object injected into the environment, which holds app-wide styling information.
//    @EnvironmentObject private var theme: Theme
//    
//    // The primary ViewModel responsible for handling login logic, injected using @State.
//    @State private var viewModel: LoginViewModel
//    
//    // ViewModel for handling the login form data, stored as a StateObject.
//    @StateObject private var form: LoginFormViewModel
//    
//    // ObservableModel that contains the UI state and action state for the login screen.
//    @ObservedObject private var model: ObservableModel<LoginUIState, LoginActionState>
//    
//    // Coordinator for managing the bottom sheet transitions, stored as a StateObject.
//    @StateObject var coordinator = BottomSheetCoordinator<ListCellBottomSheet>()
//    
//    // Initializes the LoginScreen with a dependency-injected LoginViewModel and prepares the formViewModel.
//    init(viewModel: LoginViewModel = KoinApplication.inject()) {
//        // Injecting the LoginViewModel using the Koin dependency injection framework.
//        self.viewModel = viewModel
//        
//        // ObservableModel is initialized with state and action publishers from the ViewModel.
//        self.model = ObservableModel(
//            statePublisher: asPublisher(viewModel.loginStateWrapped),
//            actionPublisher: asPublisher(viewModel.loginActionWrapped)
//        )
//        
//        // Passes the LoginFormPresenter from the viewModel to initialize the LoginFormViewModel.
//        _form = StateObject(wrappedValue: LoginFormViewModel(presenter: viewModel.createLoginSubmitFormPresenter()))
//    }
//    
//    // Main body of the LoginScreen which provides the loading state layout and main content layout.
//    var body: some View {
//        LoadingContentLayout(
//            // Displays the content based on the state of the login process.
//            state: model.state,
//            error: {
//                // Error view shown when there is an issue during the loading process.
//                errorContentView
//            }
//        ) {
//            // Main content view displayed when there are no loading issues.
//            contentView
//        }
//        .onAppear {
//            // Attaches the ViewModel's navigator on screen appear.
//            viewModel.attachViewModel(navigator: LoginPageNavigatorImpl())
//        }
//    }
//    
//    // Content view that encapsulates the primary UI components of the LoginScreen.
//    private var contentView: some View {
//        VStack {
//            // ScrollView that contains all the UI elements of the login screen.
//            ScrollView {
//                // Handles any error in the action state and shows an error message if present.
//                if let error = model.action?.error {
//                    errorView(message: error.message)
//                }
//                
//                // Stack containing the login graphic and form views, styled with spacers and padding.
//                VStack(spacing: BankingTheme.dimens.medium) {
//                    loginGraphicContainerView
//                    loginFormView
//                }
//                .padding(.top, theme.dimens.large)
//                .padding(.bottom, theme.dimens.extraLarge)
//                
//                Spacer()
//            }
//            
//            // Bottom safe space view that handles the SafeSpaceTile and presents the bottom sheet.
//            .listRowInsets(EdgeInsets())
//            bottomSafeSpaceTileView
//        }
//        .edgesIgnoringSafeArea(.bottom) // Ignores the safe area at the bottom to stretch content fully.
//    }
//    
//    // Error content view shown when there is a loading error.
//    private var errorContentView: AnyView {
//        return AnyView(
//            makeResourceErrorView {
//                // Fetches the login page content when an error occurs.
//                viewModel.fetchLoginPageContent()
//            }
//        )
//    }
//    
//    // View that contains the graphic container, mapped from the LoginFieldDataMapper.
//    private var loginGraphicContainerView: some View {
//        // Maps the login presenter data into the field data model.
//        let loginFieldData = LoginFieldDataMapper.map(from: viewModel.createLoginPagePresenter())
//        
//        return VStack(spacing: BankingTheme.dimens.medium) {
//            // Displays the login graphic title and content URL in the LoginGraphicContainer.
//            LoginGraphicContainer(
//                title: loginFieldData.loginGraphicTitle,
//                contentURL: loginFieldData.loginGraphicContentURL
//            )
//            .padding(.horizontal, BankingTheme.dimens.medium)
//        }
//    }
//    
//    // View that holds the login form UI components such as text fields and buttons.
//    private var loginFormView: some View {
//        VStack(spacing: BankingTheme.dimens.medium) {
//            // The login form that interacts with the ViewModel and handles various user actions.
//            LoginForm(
//                viewModel: form,
//                isLoading: model.action?.isLoading ?? false,
//                onRecoverUsername: {
//                    // Handles the event when the user clicks on "Recover Username".
//                    viewModel.onForgotPasswordClicked()
//                },
//                onForgotPassword: {
//                    // Handles the event when the user clicks on "Forgot Password".
//                    viewModel.onForgotPasswordClicked()
//                },
//                onSubmitForm: {
//                    // Triggers the submission of the login form.
//                    onSubmitForm()
//                }
//            )
//            .padding(.bottom, theme.dimens.large)
//        }
//    }
//    
//    // View that contains the SafeSpaceTile and manages the presentation of the bottom sheet.
//    private var bottomSafeSpaceTileView: some View {
//        VStack {
//            SafeSpaceTile {
//                // Presents the bottom sheet when SafeSpaceTile is tapped.
//                showSheetOne()
//            }
//        }
//        .bottomSheetManaging(coordinator: coordinator)
//    }
//    
//    // Handles the submission of the login form, validates input, and authenticates credentials.
//    private func onSubmitForm() {
//        // TODO: Replace code below to get state values from TextFields.
//        let result = viewModel.validate(username: form.username, password: form.password)
//        if form.updateValidation(result) {
//            // Authenticates the user's credentials if validation succeeds.
//            viewModel.authenticateCredentials(
//                username: form.username,
//                password: form.password,
//                encrypt: true,
//                encrypted: false
//            )
//        }
//    }
//    
//    // Error view that displays a custom error message.
//    private func errorView(message: String?) -> some View {
//        Text(message ?? "Unknown error")
//            .foregroundColor(.red)
//            .multilineTextAlignment(.center)
//            .padding()
//    }
//    
//    // Presents the bottom sheet for the first sheet in the navigation flow.
//    private func showSheetOne() {
//        // TODO: This should be moved to Navigation.
//        // Define the sheet presentation logic in a separate function.
//        Task {
//            do {
//                await coordinator.transitionToSheet(.sheetOne)
//            } catch {
//                // Logs the error if the bottom sheet fails to present.
//                print("Failed to present sheet: \(error)")
//            }
//        }
//    }
//}
//
//
