//
//  File.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 09/09/24.
//

import Foundation

final class LoginFormViewModel: ObservableObject {
    enum Field {
        case username
        case password
    }
    
    // MARK: - Published Properties
    
    @Published var editingField: Field?
    @Published var usernameHint: String = ""
    @Published var username: String = "" {
        didSet {
            if username != oldValue {
                validationUsername = nil
            }
        }
    }
    @Published var editingUsername = false
    @Published var validationUsername: ValidationRule?
    
    @Published var passwordHint: String = ""
    @Published var password: String = "" {
        didSet {
            if password != oldValue {
                validationPassword = nil
            }
        }
    }
    @Published var editingPassword = false
    @Published var validationPassword: ValidationRule?
    
    @Published var submitFormData: LoginSubmitFormData?
    
    // MARK: - Initialization
    
    init(presenter: LoginSubmitFormPresenter) {
        // Map data from the presenter to the form data model
        self.submitFormData = LoginSubmitFormDataMapper.map(from: presenter)
    }
    
    // MARK: - Validation Logic
    
    func updateValidation(_ result: LoginFormValidationResults) -> Bool {
        validationUsername = result.username.error
        validationPassword = result.password.error
        return result.username.isValid && result.password.isValid
    }
    
    // MARK: - Editing Management
    
    func edit(field: Field) {
        editingField = field
        editingUsername = (field == .username)
        editingPassword = (field == .password)
    }
}

