//
//  File.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 09/09/24.
//

final class LoginFormViewModel: ObservableObject {
    enum Field {
        case username
        case password
    }
    
    @Published var editingField: Field?
    
    @Published var username = "" {
        didSet {
            if username != oldValue {
                validationUsername = nil
            }
        }
    }
    
    @Published var password = "" {
        didSet {
            if password != oldValue {
                validationPassword = nil
            }
        }
    }
    
    @Published var validationUsername: ValidationRule?
    @Published var validationPassword: ValidationRule?
    
    // This helps keep track of the field being edited
    func edit(field: Field) {
        editingField = field
    }
}

struct LoginForm: View {
    @EnvironmentObject var theme: Theme
    @ObservedObject var viewModel: LoginFormViewModel
    @FocusState private var focusedField: LoginFormViewModel.Field? // Track focus state

    let proxy: ScrollViewProxy // Pass proxy to scroll
    let data: LoginSubmitFormData
    let isLoading: Bool
    let onRecoverUsername: () -> Void
    let onForgotPassword: () -> Void
    let onSubmitForm: () -> Void
    
    var body: some View {
        VStack {
            createUsernameField(data)
            createPasswordField(data)
            createPrimaryButton(data)
        }
        .onChange(of: focusedField) { field in
            // Scroll to the active field when focus changes
            if let field = field {
                scrollToActiveField(field)
            }
        }
    }
    
    private func createUsernameField(_ data: LoginSubmitFormData) -> some View {
        VStack(spacing: theme.dimens.medium) {
            TextFieldGeneral(
                text: $viewModel.username,
                label: data.userIdTitle,
                trailingIcon: ComponentConstants.Images.profile,
                placeholder: "Type here",
                isError: false
            )
            .focused($focusedField, equals: .username) // Bind focus to username
            .id(LoginFormViewModel.Field.username)     // Unique ID for scrolling

            HStack {
                TextLinkButton(title: data.userIdActionLinkText) { onRecoverUsername() }
                    .frame(maxWidth: .infinity, alignment: .leading)

                TextLinkButton(title: data.notRegisteredLinkText) { onForgotPassword() }
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }

    private func createPasswordField(_ data: LoginSubmitFormData) -> some View {
        VStack(spacing: theme.dimens.medium) {
            TextFieldPassword(
                text: $viewModel.password,
                label: data.passwordTitle,
                isError: false
            )
            .focused($focusedField, equals: .password) // Bind focus to password
            .id(LoginFormViewModel.Field.password)     // Unique ID for scrolling

            HStack {
                TextLinkButton(title: data.resetPasswordLinkText) { onForgotPassword() }
                Spacer()
            }
        }
    }

    private func createPrimaryButton(_ data: LoginSubmitFormData) -> some View {
        VStack {
            PrimaryButton {
                Text(data.signonButtonLabel)
            }
            .isDisabled(isLoading)
            .onSubmitForm()
        }
        .padding(.top, theme.dimens.medium)
    }
    
    // Use the proxy to scroll to the active field
    private func scrollToActiveField(_ field: LoginFormViewModel.Field) {
        withAnimation {
            proxy.scrollTo(field, anchor: .top)
        }
    }
}


import SwiftUI
import Combine

struct LoginScreen: View {
    @EnvironmentObject private var theme: Theme
    @State private var viewModel: LoginViewModel
    @StateObject private var form: LoginFormViewModel
    @ObservedObject private var model: ObservableModel<LoginUIState, LoginActionState>
    
    @FocusState private var focusedField: LoginFormViewModel.Field? // Manage focus
    
    init(viewModel: LoginViewModel = KoinApplication.inject()) {
        self.viewModel = viewModel
        self.model = ObservableModel(
            statePublisher: asPublisher(viewModel.loginStateWrapped),
            actionPublisher: asPublisher(viewModel.loginActionWrapped)
        )
        _form = StateObject(wrappedValue: LoginFormViewModel(presenter: viewModel.createLoginSubmitFormPresenter()))
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: theme.dimens.medium) {
                    loginGraphicContainerView
                    
                    // Inject ScrollViewProxy into LoginForm
                    LoginForm(
                        viewModel: form,
                        data: formData,
                        isLoading: model.action?.isLoading ?? false,
                        onRecoverUsername: {
                            viewModel.onForgotPasswordClicked()
                        },
                        onForgotPassword: {
                            viewModel.onForgotPasswordClicked()
                        },
                        onSubmitForm: {
                            onSubmitForm()
                        }
                    )
                }
            }
            .onTapGesture {
                UIApplication.shared.endEditing() // Dismiss keyboard when tapping outside
            }
            .onChange(of: focusedField) { field in
                // Scroll to the focused field
                if let field = field {
                    scrollToActiveField(proxy: proxy, field: field)
                }
            }
            .onAppear {
                addKeyboardObservers() // Observe keyboard appearance
            }
            .onDisappear {
                removeKeyboardObservers() // Remove observers when view disappears
            }
        }
    }
    
    // Scroll to the active field (username or password) when focused
    private func scrollToActiveField(proxy: ScrollViewProxy, field: LoginFormViewModel.Field) {
        withAnimation {
            proxy.scrollTo(field, anchor: .top) // Adjust anchor as needed
        }
    }
    
    // Observe keyboard appearance to trigger scroll
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
            // You can customize logic here if needed when the keyboard appears
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
            // Handle logic when the keyboard disappears
        }
    }

    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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
}
