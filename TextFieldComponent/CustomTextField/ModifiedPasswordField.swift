//
//  ModifiedPasswordField.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 05/09/24.
//

import Foundation
import SwiftUI
/// A custom view that represents a password input field with optional icons and error handling.
public struct TextFieldPassword: View {
    
    /// Binding variable to store the entered text
    @Binding var text: String
    
    /// Label text displayed above the text field
    var label: String
    /// Optional image name for the icon displayed next to the label
    var labelIcon: String?
    
    // Optional properties for customization
    /// Optional image name for the icon displayed inside the text field, before the text
    var leadingIcon: String?
    /// Optional placeholder text for the text field
    var placeholder: String?
    
    // Error handling
    /// Boolean to indicate if there's an error state
    var isError: Bool = false
    /// Optional error message displayed below the text field when 'isError' is true
    var errorText: String?
    
    // Closures for actions
    /// Closure executed when the quick tip icon next to the label is tapped
    var onQuickTipClicked: (() -> Void)?
    /// Closure executed when the return button on the keyboard is tapped
    var onCommit: (() -> Void)?
    
    @State private var showPassword: Bool = false
    @FocusState private var isFocused: Bool
    
    /// Custom initializer for the TextFieldPassword view
    public init(
        text: Binding<String>,
        label: String,
        labelIcon: String? = nil,
        leadingIcon: String? = nil,
        placeholder: String? = nil,
        isError: Bool = false,
        errorText: String? = nil,
        onQuickTipClicked: (() -> Void)? = nil,
        onCommit: (() -> Void)? = nil
    ) {
        self._text = text
        self.label = label
        self.labelIcon = labelIcon
        self.leadingIcon = leadingIcon
        self.placeholder = placeholder
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
    
    // MARK: - View Builders
    
    @ViewBuilder
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
                .buttonStyle(PlainButtonStyle())
            }
        }
        .frame(height: TextFieldGeneralTheme.Spacing.labelHeight)
    }
    
    @ViewBuilder
    private var textFieldView: some View {
        HStack {
            if let leadingIcon = leadingIcon {
                ComponentImage(leadingIcon, resizable: false)
                    .foregroundColor(TextFieldGeneralTheme.Colors.primaryTextColor)
                    .padding(.leading, TextFieldGeneralTheme.Spacing.iconPadding)
                    .frame(height: TextFieldGeneralTheme.Spacing.leadingIconHeight)
            }
            
            if showPassword {
                textField
            } else {
                secureField
            }
            
            // Toggle password visibility icon
            Button(action: {
                showPassword.toggle()
                if showPassword {
                    isFocused = true
                }
            }) {
                ComponentImage(showPassword ? ComponentConstants.Images.passwordShownIcon : ComponentConstants.Images.passwordHiddenIcon, resizable: false)
                    .foregroundColor(TextFieldGeneralTheme.Colors.primaryTextColor)
                    .padding(.trailing, TextFieldGeneralTheme.Spacing.iconPadding)
                    .frame(height: TextFieldGeneralTheme.Spacing.trailingIconHeight)
            }
        }
        .padding(.horizontal, TextFieldGeneralTheme.Spacing.iconPadding)
        .background(RoundedRectangle(cornerRadius: TextFieldGeneralTheme.Spacing.cornerRadius)
                        .foregroundColor(TextFieldGeneralTheme.Colors.backgroundColor))
        .overlay(
            RoundedRectangle(cornerRadius: TextFieldGeneralTheme.Spacing.cornerRadius)
                .stroke(isError ? TextFieldGeneralTheme.Colors.errorColor : TextFieldGeneralTheme.Colors.borderColor, lineWidth: TextFieldGeneralTheme.Spacing.textFieldStroke)
        )
    }
    
    @ViewBuilder
    private var textField: some View {
        TextField(placeholder ?? "", text: $text)
            .focused($isFocused)
            .font(TextFieldGeneralTheme.Fonts.labelFont)
            .padding(.leading, leadingIcon == nil ? TextFieldGeneralTheme.Spacing.textFieldPadding : 0)
            .frame(height: TextFieldGeneralTheme.Spacing.textFieldHeight)
            .onSubmit {
                onCommit?()
            }
    }
    
    @ViewBuilder
    private var secureField: some View {
        SecureField(placeholder ?? "", text: $text)
            .focused($isFocused)
            .font(TextFieldGeneralTheme.Fonts.labelFont)
            .padding(.leading, leadingIcon == nil ? TextFieldGeneralTheme.Spacing.textFieldPadding : 0)
            .frame(height: TextFieldGeneralTheme.Spacing.textFieldHeight)
            .onSubmit {
                onCommit?()
            }
    }
    
    @ViewBuilder
    private func errorMessageView(text: String) -> some View {
        HStack {
            ComponentImage(ComponentConstants.Images.errorMessageLeadingIcon, resizable: false)
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
            isError: false,
            errorText: "Invalid Password"
        )
        .onCommit {
            // Handle onCommit action
        }
        .previewLayout(.sizeThatFits)
    }
}

struct LeadingIconStyle: ViewModifier {
    var color: Color = TextFieldGeneralTheme.Colors.primaryTextColor
    var padding: CGFloat = TextFieldGeneralTheme.Spacing.iconPadding
    var height: CGFloat = TextFieldGeneralTheme.Spacing.leadingIconHeight

    func body(content: Content) -> some View {
        content
            .foregroundColor(color)
            .padding(.leading, padding)
            .frame(height: height)
    }
}

extension View {
    func leadingIconStyle(
        color: Color = TextFieldGeneralTheme.Colors.primaryTextColor,
        padding: CGFloat = TextFieldGeneralTheme.Spacing.iconPadding,
        height: CGFloat = TextFieldGeneralTheme.Spacing.leadingIconHeight
    ) -> some View {
        self.modifier(LeadingIconStyle(color: color, padding: padding, height: height))
    }
}

/*
 // Using default styles
 ComponentImage(leadingIcon, resizable: false)
     .leadingIconStyle()

 // Using custom styles
 ComponentImage(leadingIcon, resizable: false)
     .leadingIconStyle(color: .red, padding: 10, height: 40)
 */

struct BackgroundWithBorderStyle: ViewModifier {
    var isError: Bool

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: TextFieldGeneralTheme.Spacing.cornerRadius)
                    .foregroundColor(TextFieldGeneralTheme.Colors.backgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: TextFieldGeneralTheme.Spacing.cornerRadius)
                    .stroke(
                        isError ? TextFieldGeneralTheme.Colors.errorColor : TextFieldGeneralTheme.Colors.borderColor,
                        lineWidth: 1 // TextFieldGeneralTheme.Spacing.textFieldStroke
                    )
            )
    }
}

extension View {
    func backgroundWithBorder(isError: Bool) -> some View {
        self.modifier(BackgroundWithBorderStyle(isError: isError))
    }
}

/*
 HStack {
     // Your content here
 }
 .backgroundWithBorder(isError: true)
 */
