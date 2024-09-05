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
    /// Binding boolean to indicate if there's an error state
    @Binding var isError: Bool
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
        isError: Binding<Bool>,
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

// A custom ViewModifier to style leading icons in a text field, allowing customization of color, padding, and height.
struct LeadingIconStyle: ViewModifier {
    // The color for the icon (default is the primary text color from the theme).
    var color: Color = TextFieldGeneralTheme.Colors.primaryTextColor
    
    // Padding to be applied to the left side of the icon (default is the icon padding from the theme).
    var padding: CGFloat = TextFieldGeneralTheme.Spacing.iconPadding
    
    // The height of the icon (default is the leading icon height from the theme).
    var height: CGFloat = TextFieldGeneralTheme.Spacing.leadingIconHeight

    // The body of the ViewModifier applies the styles to the content.
    func body(content: Content) -> some View {
        content
            .foregroundColor(color) // Set the icon color
            .padding(.leading, padding) // Apply left padding
            .frame(height: height) // Set the height of the icon
    }
}

// Extension to allow easy application of the LeadingIconStyle to any view.
extension View {
    // A helper function to apply the LeadingIconStyle ViewModifier with optional customization parameters.
    func leadingIconStyle(
        color: Color = TextFieldGeneralTheme.Colors.primaryTextColor,
        padding: CGFloat = TextFieldGeneralTheme.Spacing.iconPadding,
        height: CGFloat = TextFieldGeneralTheme.Spacing.leadingIconHeight
    ) -> some View {
        // Use the custom LeadingIconStyle modifier, passing in any customization values provided.
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


// A custom ViewModifier to apply a background with a border, which changes color based on an error state.
struct BackgroundWithBorderStyle: ViewModifier {
    // A binding to a boolean that indicates whether there is an error state.
    @Binding var isError: Bool

    // The body of the ViewModifier defines how the content should be styled.
    func body(content: Content) -> some View {
        content
            .background(
                // Apply a rounded rectangle as the background, using a corner radius.
                RoundedRectangle(cornerRadius: TextFieldGeneralTheme.Spacing.cornerRadius)
                    .foregroundColor(TextFieldGeneralTheme.Colors.backgroundColor) // Set background color
            )
            .overlay(
                // Apply an overlay with a rounded rectangle, used for the border.
                RoundedRectangle(cornerRadius: TextFieldGeneralTheme.Spacing.cornerRadius)
                    .stroke(
                        // Change the border color based on the error state.
                        isError ? TextFieldGeneralTheme.Colors.errorColor : TextFieldGeneralTheme.Colors.borderColor,
                        lineWidth: TextFieldGeneralTheme.Spacing.textFieldStroke // Set the stroke width
                    )
            )
    }
}

// Extension to allow easy application of the custom modifier.
extension View {
    // A helper function to apply the BackgroundWithBorderStyle ViewModifier.
    func backgroundWithBorder(isError: Binding<Bool>) -> some View {
        // Use the custom modifier and pass the binding for the error state.
        self.modifier(BackgroundWithBorderStyle(isError: isError))
    }
}

/*
 HStack {
     // Your content here
 }
 .backgroundWithBorder(isError: $isError)
 */
