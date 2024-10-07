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
private var cancellables = Set<AnyCancellable>()

// MARK: - Keyboard management
extension LoginScreen {

    /// Adds observers for keyboard show and hide notifications.
    ///
    /// This listens for keyboard appearance and dismissal, triggering UI updates when the keyboard state changes.
    private func addKeyboardObservers() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .merge(with: NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification))
            .receive(on: RunLoop.main)
            .sink { notification in
                self.handleKeyboard(notification: notification)
            }
            .store(in: &cancellables)
    }

    /// Adjusts view layout based on keyboard appearance or dismissal.
    ///
    /// Updates the `keyboardHeight` when the keyboard shows or hides, allowing the UI to respond appropriately.
    /// - Parameter notification: Keyboard notification containing frame and visibility info.
    private func handleKeyboard(notification: Notification) {
        if notification.name == UIResponder.keyboardWillShowNotification {
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                withAnimation {
                    keyboardHeight = keyboardFrame.height
                }
            }
        } else if notification.name == UIResponder.keyboardWillHideNotification {
            withAnimation {
                keyboardHeight = 0
            }
        }
    }

    /// Removes keyboard observers when they are no longer needed.
    ///
    /// Cancels all subscriptions to keyboard notifications.
    private func removeKeyboardObservers() {
        cancellables.removeAll()
    }
}

import SwiftUI

public enum ComponentConstants {
    
    public enum Images: String, CustomStringConvertible {
        case chevron = "TnChevron"
        case logoBrandCibc = "brand_logo"
        case backButton = "back_Button"
        case quickTip = "quick-tip"
        case shieldHome = "shield-home"
        case add = "add"
        case addPerson = "add-person"
        case errorMessageLeadingIcon = "alert-general-filled"
        case passwordShownIcon = "quick-look"
        case passwordHiddenIcon = "view-hide"
        case profile = "profile"
        case logoFdic = "fdic-logo"
        case stopwatch = "stopwatch"
        case user = "user"
        case edit = "edit"
        case mobile = "mobile"
        case faceId = "face-id"
        
        // Automatically return the raw value (image name) when enum case is used
        public var description: String {
            return self.rawValue
        }
    }

    public enum BottomNavBar {
        public enum Images: String, CustomStringConvertible {
            case homePageFilled = "home-filled"
            case homePageUnfilled = "home-unfilled"
            case moreFilled = "more-filled"
            case morePageUnfilled = "more-unfilled"
            
            // Automatically return the raw value (image name) when enum case is used
            public var description: String {
                return self.rawValue
            }
        }
    }

    public enum AccountDetailsCard {
        public enum Images: String, CustomStringConvertible {
            case accountDetailsCard = "account-details-card"
            case mastercardLogo = "mastercard-logo"
            
            // Automatically return the raw value (image name) when enum case is used
            public var description: String {
                return self.rawValue
            }
        }
    }
}
