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

import SwiftUI
import Combine

struct LoginScreen: View {
    @EnvironmentObject private var theme: Theme
    @State private var viewModel: LoginViewModel
    @StateObject private var form: LoginFormViewModel
    @ObservedObject private var model: ObservableModel<LoginUIState, LoginActionState>
    @StateObject var coordinator = BottomSheetCoordinator<ListCellBottomSheet>()
    
    // State to track the keyboard height and focus field
    @State private var keyboardHeight: CGFloat = 0
    @FocusState private var focusedField: Field?
    
    // Field enum to track active TextField focus
    enum Field: Hashable {
        case username
        case password
    }

    init(viewModel: LoginViewModel = KoinApplication.inject()) {
        self.viewModel = viewModel
        self.model = ObservableModel(
            statePublisher: asPublisher(viewModel.loginStateWrapped),
            actionPublisher: asPublisher(viewModel.loginActionWrapped)
        )
        _form = StateObject(wrappedValue: LoginFormViewModel(presenter: viewModel.createLoginSubmitFormPresenter()))
    }
    
    var body: some View {
        LoadingContentLayout(
            state: model.state,
            error: {
                errorContentView
            }
        ) {
            contentView
        }
        .onAppear {
            viewModel.attachViewModel(navigator: LoginPageNavigatorImpl())
        }
        .onReceive(Publishers.keyboardHeight) { height in
            withAnimation {
                self.keyboardHeight = height
            }
        }
        .padding(.bottom, keyboardHeight) // Adjust padding for keyboard
    }

    private var contentView: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: BankingTheme.dimens.medium) {
                        loginGraphicContainerView
                        loginFormView(proxy: proxy)
                    }
                }
            }
            Spacer()
            bottomSafeSpaceTileView
        }
        .edgesIgnoringSafeArea(.bottom)
        .onTapGesture {
            UIApplication.shared.endEditing() // Dismiss the keyboard on tap
        }
    }
    
    private func loginFormView(proxy: ScrollViewProxy) -> some View {
        VStack(spacing: BankingTheme.dimens.medium) {
            // Username TextField
            TextField("Username", text: $form.username)
                .focused($focusedField, equals: .username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: focusedField) { newField in
                    if newField == .username {
                        scrollToActiveField(proxy: proxy, field: .username)
                    }
                }

            // Password TextField
            SecureField("Password", text: $form.password)
                .focused($focusedField, equals: .password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: focusedField) { newField in
                    if newField == .password {
                        scrollToActiveField(proxy: proxy, field: .password)
                    }
                }

            // Submit Button
            Button("Login") {
                onSubmitForm()
            }
            .padding(.top, theme.dimens.large)
        }
    }

    private func scrollToActiveField(proxy: ScrollViewProxy, field: Field) {
        withAnimation {
            proxy.scrollTo(field, anchor: .top)
        }
    }

    private func onSubmitForm() {
        let result = viewModel.validate(username: form.username, password: form.password)
        if form.updateValidation(result) {
            viewModel.authenticateCredentials(
                username: form.username,
                password: form.password,
                encrypt: true,
                encrypted: false
            )
        }
    }
    
    // Error content and bottomSafeSpaceTileView are as before.
}

// Utility publisher for observing keyboard height changes using Combine
extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let willShow = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .map { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0 }
        
        let willHide = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

// Utility to dismiss the keyboard
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
