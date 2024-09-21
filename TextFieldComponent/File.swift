//
//  File.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 09/09/24.
//

import Foundation

/// A SwiftUI view representing the login form, containing fields for the user ID and password,
/// and buttons for submitting the form and performing additional actions like password recovery.
struct LoginForm: View {
    @EnvironmentObject var theme: Theme
    @ObservedObject var viewModel: LoginFormViewModel
    
    /// Indicates whether the form submission process is currently loading.
    let isLoading: Bool
    
    /// A closure to handle the "Recover Username" action.
    let onRecoverUsername: () -> Void
    
    /// A closure to handle the "Forgot Password" action.
    let onForgotPassword: () -> Void
    
    /// A closure to handle the form submission process.
    let onSubmitForm: () -> Void

    /// State variable to manage the error state for input fields, e.g., highlighting incorrect inputs.
    @State var isError = false
    
    var body: some View {
        VStack(spacing: BankingTheme.dimens.medium) {
            /// The main content area, conditionally displayed if the `submitFormData` is available.
            if let submitFormData = viewModel.submitFormData {
                
                /// A container for the login page's graphic, located above the input fields.
                LoginGraphicContainer()
                    .padding(.horizontal, BankingTheme.dimens.medium)
                
                VStack(spacing: BankingTheme.spacing.noPadding) {
                    /// Creates the username input field along with associated links (Recover Username, Not Registered).
                    createUsernameField(submitFormData: submitFormData)
                    
                    /// Creates the password input field along with a link for resetting the password.
                    createPasswordField(submitFormData: submitFormData)
                    
                    /// Footer section with additional links for user actions.
                    createFooterLinks(submitFormData: submitFormData)
                    
                    Spacer()
                    
                    /// Option for the user to toggle the "Remember User ID" setting.
                    RememberUserIdView(
                        title: submitFormData.rememberMeTitleText,
                        isRemembered: true
                    )
                    
                    /// A primary button that submits the form.
                    createPrimaryButton(submitFormData: submitFormData)
                }
            }
        }
        .padding(.top, theme.dimens.medium)
        .padding(.bottom, theme.dimens.medium)
    }
    
    // MARK: - Subviews
    
    /// Creates the input field for the username and associated links for user actions.
    /// - Parameter submitFormData: Data used to configure the user ID field and related links.
    /// - Returns: A SwiftUI view that contains the username input field and associated links.
    private func createUsernameField(submitFormData: LoginSubmitFormData) -> some View {
        VStack(spacing: BankingTheme.spacing.noPadding) {
            /// A general input field for entering the username.
            TextFieldGeneral(
                text: $viewModel.username,
                label: submitFormData.userIdTitle,
                trailingIcon: ComponentConstants.Images.profile,
                placeholder: "Type here",
                isError: false
            )
            
            HStack {
                /// Link for recovering the username.
                TextLinkButton(title: submitFormData.userIdActionLinkText, action: onRecoverUsername)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                /// Link for users who have not yet registered.
                TextLinkButton(title: submitFormData.notRegisteredLinkText, action: onForgotPassword)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
    
    /// Creates the input field for the password.
    /// - Parameter submitFormData: Data used to configure the password field.
    /// - Returns: A SwiftUI view containing the password input field.
    private func createPasswordField(submitFormData: LoginSubmitFormData) -> some View {
        TextFieldPassword(
            text: $viewModel.password,
            label: submitFormData.passwordTitle,
            isError: $isError
        )
    }
    
    /// Creates additional footer links for user actions, such as resetting the password.
    /// - Parameter submitFormData: Data used to configure the footer links.
    /// - Returns: A SwiftUI view that contains links for additional actions.
    private func createFooterLinks(submitFormData: LoginSubmitFormData) -> some View {
        HStack {
            /// Link for resetting the password.
            TextLinkButton(title: submitFormData.resetPasswordLinkText, action: onForgotPassword)
        }
    }
    
    /// Creates the primary button used to submit the form.
    /// - Parameter submitFormData: Data used to configure the button's label and action.
    /// - Returns: A SwiftUI view that contains the primary form submission button.
    private func createPrimaryButton(submitFormData: LoginSubmitFormData) -> some View {
        HStack {
            /// A button labeled with the form's submission label, disabled if `isLoading` is true.
            PrimaryButton(
                content: {
                    Text(submitFormData.signonButtonLabel)
                },
                isDisabled: isLoading
            ) {
                onSubmitForm()
            }
        }
    }
}

