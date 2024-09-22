//
//  File.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 09/09/24.
//

import Foundation

import SwiftUI
import Umbrella
import Components
import Theme
import Koin

struct LoginScreen: View {
    @EnvironmentObject private var theme: Theme
    
    @State private var viewModel: LoginViewModel
    @StateObject private var form: LoginFormViewModel
    @ObservedObject private var model: ObservableModel<LoginUIState, LoginActionState>
    @StateObject var coordinator = BottomSheetCoordinator<ListCellBottomSheet>()
    
    var body: some View {
        LoadingContentLayout(
            state: model.state,
            errorView: {
                errorContentView
            }
        ) {
            contentView
        }
        .onAppear {
            viewModel.attachViewModel(navigator: LoginPageNavigatorImpl())
        }
    }
    
    private var contentView: some View {
        VStack {
            ScrollView {
                loginHeaderView
                
                if let error = model.action?.error {
                    errorView(message: error.message)
                }
                
                formContentView
                    .padding(.top, theme.dimens.large)
                    .padding(.bottom, theme.dimens.extraLarge)
            }
            .listRowInsets(EdgeInsets())
            
            bottomSafeSpaceTile
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    private var errorContentView: some View {
        AnyView(
            makeResourceErrorView {
                viewModel.fetchLoginPageContent()
            }
        )
    }
    
    private var loginHeaderView: some View {
        let loginFieldData = LoginFieldDataMapper.map(from: viewModel.createLoginPagePresenter())
        return VStack(spacing: BankingTheme.dimens.medium) {
            LoginGraphicContainer(
                title: loginFieldData.loginGraphicTitle,
                contentURL: loginFieldData.loginGraphicContentURL
            )
            .padding(.horizontal, BankingTheme.dimens.medium)
        }
    }
    
    private var formContentView: some View {
        VStack(spacing: BankingTheme.dimens.medium) {
            LoginForm(
                viewModel: form,
                isLoading: model.action?.isLoading ?? false,
                onRecoverUsername: { viewModel.onForgotPasswordClicked() },
                onForgotPassword: { viewModel.onForgotPasswordClicked() },
                onSubmitForm: { onSubmitForm() }
            )
            .padding(.bottom, theme.dimens.large)
        }
    }
    
    private var bottomSafeSpaceTile: some View {
        VStack {
            SafeSpaceTile {
                showSheetOne()
            }
            .bottomSheetManaging(coordinator: coordinator)
        }
    }
    
    init(viewModel: LoginViewModel = KoinApplication.inject()) {
        self._viewModel = State(initialValue: viewModel)
        self.model = ObservableModel(
            statePublisher: asPublisher(viewModel.loginStateWrapped),
            actionPublisher: asPublisher(viewModel.loginActionWrapped)
        )
        // Pass the presenter when initializing the formViewModel
        _form = StateObject(wrappedValue: LoginFormViewModel(presenter: viewModel.createLoginSubmitFormPresenter()))
    }
    
    private func onSubmitForm() {
        // Validate the form inputs
        let result = viewModel.validate(username: form.username, password: form.password)
        if form.updateValidation(result) {
            viewModel.authenticateCredentials(username: form.username, password: form.password, encrypt: true, encrypted: false)
        }
    }
    
    private func errorView(message: String?) -> some View {
        Text(message ?? "Unknown error")
            .foregroundColor(.red)
            .multilineTextAlignment(.center)
            .padding()
    }
    
    private func showSheetOne() {
        Task {
            do {
                await coordinator.transitionToSheet(.sheetOne)
            } catch {
                print("Failed to present sheet: \(error)")
            }
        }
    }
}

