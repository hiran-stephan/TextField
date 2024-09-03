//
//  TextInputPassword.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 03/09/24.
//

import Foundation
import SwiftUI

/// A custom view that represents a password input field with optional icons and error handling.
public struct TextFieldPassword: View {
    // Binding variable to store the entered text
    @Binding var text: String
    
    // Label text displayed above the text field
    var label: String
    
    // Optional image name for the icon displayed next to the label
    var labelIcon: String?
    
    // Optional placeholder text for the text field
    var placeholder: String?
        
    // Optional image name for the icon displayed inside the text field, before the text
    var leadingIcon: String?
    
    // Boolean to indicate if there's an error state
    var isError: Bool = false
    
    // Optional error message displayed below the text field when `isError` is true
    var errorText: String?
    
    // Closure executed when the quick tip icon next to the label is tapped
    var onQuickTipClicked: (() -> Void)?
    
    // Closure executed when the return button on the keyboard is tapped
    var onCommit: (() -> Void)?

    // Private state variable to toggle password visibility
    @State private var showPassword: Bool = false
    
    // Focus state for the text field
    @FocusState private var isFocused: Bool

    // Custom initializer for the TextFieldPassword view
    public init(
        text: Binding<String>,
        label: String,
        placeholder: String? = nil,
        labelIcon: String? = nil,
        leadingIcon: String? = nil,
        isError: Bool = false,
        errorText: String? = nil,
        onQuickTipClicked: (() -> Void)? = nil,
        onCommit: (() -> Void)? = nil
    ) {
        self._text = text
        self.label = label
        self.placeholder = placeholder
        self.labelIcon = labelIcon
        self.leadingIcon = leadingIcon
        self.isError = isError
        self.errorText = errorText
        self.onQuickTipClicked = onQuickTipClicked
        self.onCommit = onCommit
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: TextFieldGeneralTheme.Spacing.errorTextTopPadding) {
            labelView
            textFieldView
            if isError, let text = errorText {
                errorMessageView(text: text)
            }
        }
        .padding(.horizontal, TextFieldGeneralTheme.Spacing.containerPadding)
    }

    /// View that displays the label and an optional icon
    private var labelView: some View {
        HStack(alignment: .center, spacing: TextFieldGeneralTheme.Spacing.iconPadding) {
            Text(label)
                .font(TextFieldGeneralTheme.Fonts.labelFont)
            if let labelIcon = labelIcon {
                Button(action: {
                    onQuickTipClicked?()
                }) {
                    ComponentImage(labelIcon, resizable: false)
                        .frame(width: TextFieldGeneralTheme.Spacing.labelIconHeight, height: TextFieldGeneralTheme.Spacing.labelIconHeight)
                }
                //.buttonStyle(PlainButtonStyle())
            }
        }
        .frame(height: TextFieldGeneralTheme.Spacing.labelHeight)
    }

    /// View that displays the text field with optional leading and trailing icons
    private var textFieldView: some View {
        HStack {
            if let leadingIcon = leadingIcon {
                ComponentImage(leadingIcon, resizable: false)
                    .foregroundColor(TextFieldGeneralTheme.Colors.primaryTextColor)
                    .padding(.leading, TextFieldGeneralTheme.Spacing.iconPadding)
                    .frame(height: TextFieldGeneralTheme.Spacing.leadingIconHeight)
            }

            // Toggle between TextField and SecureField based on showPassword state
            if showPassword {
                TextField(placeholder ?? "", text: $text)
                    .focused($isFocused)
                    .font(TextFieldGeneralTheme.Fonts.labelFont)
                    .padding(.leading, leadingIcon == nil ? TextFieldGeneralTheme.Spacing.textFieldPadding : TextFieldGeneralTheme.Spacing.leadingTextFieldPadding)
                    .frame(height: TextFieldGeneralTheme.Spacing.textFieldHeight)
                    .onSubmit {
                        onCommit?()
                    }
            } else {
                SecureField(placeholder ?? "", text: $text)
                    .focused($isFocused)
                    .font(TextFieldGeneralTheme.Fonts.labelFont)
                    .padding(.leading, leadingIcon == nil ? TextFieldGeneralTheme.Spacing.textFieldPadding : TextFieldGeneralTheme.Spacing.leadingTextFieldPadding)
                    .frame(height: TextFieldGeneralTheme.Spacing.textFieldHeight)
                    .onSubmit {
                        onCommit?()
                    }
            }

            // Toggle password visibility icon
            Button(action: {
                showPassword.toggle()
                if showPassword {
                    isFocused = true
                }
            }) {
                ComponentImage(showPassword ? "close-eye" : "open-eye", resizable: false)
                    .foregroundColor(TextFieldGeneralTheme.Colors.primaryTextColor)
                    .padding(.trailing, TextFieldGeneralTheme.Spacing.iconPadding)
                    .frame(height: TextFieldGeneralTheme.Spacing.trailingIconHeight)
            }
        }
        .padding(.horizontal, TextFieldGeneralTheme.Spacing.iconPadding)
        .background(RoundedRectangle(cornerRadius: TextFieldGeneralTheme.Spacing.cornerRadius)
            .fill(isError ? TextFieldGeneralTheme.Colors.errorBgColor : TextFieldGeneralTheme.Colors.backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: TextFieldGeneralTheme.Spacing.cornerRadius)
                    .stroke(isError ? TextFieldGeneralTheme.Colors.errorColor : TextFieldGeneralTheme.Colors.borderColor, lineWidth: 1)
            ))
    }

    /// View that displays the error message when `isError` is true
    private func errorMessageView(text: String) -> some View {
        HStack {
            ComponentImage("error", resizable: false)
                .foregroundColor(TextFieldGeneralTheme.Colors.errorColor)
            Text(text)
                .foregroundColor(TextFieldGeneralTheme.Colors.errorColor)
                .font(TextFieldGeneralTheme.Fonts.errorFont)
        }
        .frame(height: TextFieldGeneralTheme.Spacing.errorContainerHeight)
        .padding(.top, TextFieldGeneralTheme.Spacing.errorTextTopPadding)
    }
}

struct TextFieldPassword_Previews: PreviewProvider {
    @State static var text = ""
    
    static var previews: some View {
        TextFieldPassword(
            text: $text,
            label: "Password",
            placeholder: "Enter your password",
            labelIcon: "info.circle",
            leadingIcon: "lock.fill",
            isError: true,
            errorText: "Invalid password",
            onQuickTipClicked: {
                print("Quick tip clicked")
            },
            onCommit: {
                print("Done")
            }
        )
        .previewLayout(.sizeThatFits)
    }
}
