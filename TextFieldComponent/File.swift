//
//  File.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 09/09/24.
//

import Foundation

struct LoginFieldDataMapper {

    // Define LoginFieldData inside the mapper
    struct LoginFieldData {
        let mastheadCaption: String
        let mastheadCaptionAccessibilityText: String
        let loginGraphicTitle: String
        let loginGraphicContentURL: String
        let systemErrorDialogDismiss: String
        let systemErrorDialogResetPassword: String
    }

    // Map from LoginPagePresenter to LoginFieldData
    static func map(from presenter: LoginPagePresenter) -> LoginFieldData {
        return LoginFieldData(
            mastheadCaption: presenter.mastheadCaption,
            mastheadCaptionAccessibilityText: presenter.mastheadCaptionAccessibilityText,
            loginGraphicTitle: presenter.loginGraphicTitle,
            loginGraphicContentURL: presenter.loginGraphicContentURL,
            systemErrorDialogDismiss: presenter.systemErrorDialogDismiss,
            systemErrorDialogResetPassword: presenter.systemErrorDialogResetPassword
        )
    }
}

struct LoginSubmitFormDataMapper {

    // Define LoginSubmitFormData inside the mapper
    struct LoginSubmitFormData {
        let userIdTitle: String
        let selectedUserIdAccessibilityText: String
        let deleteUserIdAccessibilityText: String
        let removeSavedUserIdDialogTitle: String
        let removeSavedUserIdDialogProceed: String
        let removeSavedUserIdDialogCancel: String
        let notRegisteredLinkText: String
        let passwordTitle: String
        let resetPasswordLinkText: String
        let showPasswordAccessibilityText: String
        let hidePasswordAccessibilityText: String
        let rememberMeTitleText: String
        let rememberMeDialogTitle: String
        let rememberMeDialogText: String
        let rememberMeDialogDismiss: String
    }

    // Map from LoginSubmitFormPresenter to LoginSubmitFormData
    static func map(from presenter: LoginSubmitFormPresenter) -> LoginSubmitFormData {
        return LoginSubmitFormData(
            userIdTitle: presenter.userIdTitle,
            selectedUserIdAccessibilityText: presenter.selectedUserIdAccessibilityText,
            deleteUserIdAccessibilityText: presenter.deleteUserIdAccessibilityText,
            removeSavedUserIdDialogTitle: presenter.removeSavedUserIdDialogTitle,
            removeSavedUserIdDialogProceed: presenter.removeSavedUserIdDialogProceed,
            removeSavedUserIdDialogCancel: presenter.removeSavedUserIdDialogCancel,
            notRegisteredLinkText: presenter.notRegisteredLinkText,
            passwordTitle: presenter.passwordTitle,
            resetPasswordLinkText: presenter.resetPasswordLinkText,
            showPasswordAccessibilityText: presenter.showPasswordAccessibilityText,
            hidePasswordAccessibilityText: presenter.hidePasswordAccessibilityText,
            rememberMeTitleText: presenter.rememberMeTitleText,
            rememberMeDialogTitle: presenter.rememberMeDialogTitle,
            rememberMeDialogText: presenter.rememberMeDialogText,
            rememberMeDialogDismiss: presenter.rememberMeDialogDismiss
        )
    }
}


// Map presenter to data model using the LoginFieldDataMapper
let loginFieldData = LoginFieldDataMapper.map(from: viewModel.createLoginPagePresenter())

// Map the data from LoginSubmitFormPresenter using LoginSubmitFormDataMapper
let loginSubmitFormData = LoginSubmitFormDataMapper.map(from: viewModel.createLoginSubmitFormPresenter())

