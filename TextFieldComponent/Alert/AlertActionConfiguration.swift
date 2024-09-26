//
//  AlertActionConfiguration.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 25/09/24.
//

import Foundation
import SwiftUI

// MARK: - AlertActionConfiguration
/// Configuration struct for an alert action (button).
struct AlertActionConfiguration {
    let label: String
    let type: AlertButtonType
    let action: (() -> Void)?
    let autoDismiss: Bool
    
    init(label: String, type: AlertButtonType = .none, autoDismiss: Bool = true, action: (() -> Void)? = nil) {
        self.label = label
        self.type = type
        self.action = action
        self.autoDismiss = autoDismiss
    }
}
