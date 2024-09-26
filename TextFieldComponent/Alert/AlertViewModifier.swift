//
//  AlertViewModifier.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 25/09/24.
//

import Foundation
import SwiftUI

// MARK: - AlertViewModifier
/// A `ViewModifier` that displays a custom alert with multiple buttons.
struct AlertViewModifier: ViewModifier {
    @Binding var isVisible: Bool
    let title: String?
    let message: String?
    let actions: [AlertActionConfiguration]
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isVisible {
                backgroundOverlay()
                
                alertContainer()
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.easeInOut, value: isVisible)
            }
        }
    }
    
    // Background Overlay
    private func backgroundOverlay() -> some View {
        Color.black.opacity(AlertConstants.backgroundOpacity)
            .ignoresSafeArea()
            .onTapGesture {
                isVisible = false
            }
    }
    
    // Alert Container
    private func alertContainer() -> some View {
        VStack(spacing: AlertConstants.buttonSpacing) {
            if let title = title {
                alertTitle(title)
            }
            if let message = message {
                alertMessage(message)
            }
            
            alertActions()
            
            Button("Cancel") {
                isVisible = false
            }
            .foregroundColor(AlertConstants.cancelButtonForegroundColor)
            .padding(.top, AlertConstants.topPadding)
        }
        .padding()
        .background(AlertConstants.alertBackgroundColor)
        .cornerRadius(AlertConstants.cornerRadius)
        .shadow(radius: AlertConstants.shadowRadius)
        .padding(.horizontal, AlertConstants.alertContainerHorizontalPadding)
    }
    
    // Title
    private func alertTitle(_ title: String) -> some View {
        Text(title)
            .font(AlertConstants.alertTitleFont)
            .padding(.top)
            .foregroundColor(AlertConstants.buttonForegroundColor)
    }
    
    // Message
    private func alertMessage(_ message: String) -> some View {
        Text(message)
            .font(AlertConstants.alertMessageFont)
            .multilineTextAlignment(.center)
            .padding([.leading, .trailing])
            .foregroundColor(AlertConstants.buttonForegroundColor)
    }
    
    // Actions
    private func alertActions() -> some View {
        VStack(spacing: AlertConstants.buttonSpacing) {
            ForEach(actions.indices, id: \.self) { index in
                Button(actions[index].label) {
                    handleAction(for: actions[index])
                }
                .buttonStyle(buttonStyle(for: actions[index].type))
            }
        }
    }
    
    private func buttonStyle(for type: AlertButtonType) -> some ButtonStyle {
        switch type {
        case .destructive:
            return DestructiveButtonStyle()
        case .cancel:
            return CancelButtonStyle()
        default:
            return DefaultButtonStyle()
        }
    }
    
    private func handleAction(for config: AlertActionConfiguration) {
        config.action?()
        if config.autoDismiss {
            isVisible = false
        }
    }
}

// MARK: - View Extension for Alert
/// `presentAlert` is an extension on `View` that presents a custom alert.
extension View {
    func presentAlert(
        isVisible: Binding<Bool>,
        title: String? = nil,
        message: String? = nil,
        actions: [AlertActionConfiguration]
    ) -> some View {
        self.modifier(AlertViewModifier(isVisible: isVisible, title: title, message: message, actions: actions))
    }
}
