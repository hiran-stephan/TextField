import SwiftUI

@available(iOS 13.0, *)
public struct TextInputField: View {

    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State private var trailingImage: Image?
    @State private var secureText = false {
        didSet {
            if secureText {
                isFocused = false
            }
        }
    }
    @State private var isFocused = false
    private var text: Binding<String>
    private var disable: Binding<Bool>?
    private var error: Binding<Bool>?
    private var errorText: Binding<String>?
    private var isSecureText: Bool = false
    private var titleText: String?
    private var placeHolderText: String = ""
    private var trailingImageClick: (() -> Void)?
    private var secureTextImageOpen: Image? = Image(systemName: "eye.fill")
    private var secureTextImageClose: Image? = Image(systemName: "eye.slash.fill")
    private var maxCount: Int? = 12 // Default max 12 characters
    private var truncationMode: Text.TruncationMode = .tail
    
    // Configurable validation properties
    private var minLetters: Int = 2
    private var minNumbers: Int = 2
    private var allowedCharacters: CharacterSet = .alphanumerics
    
    // Colors
    private var defaultTextColor = TextInputFieldConfig.shared.defaultTextColor
    private var darkModeTextColor = TextInputFieldConfig.shared.darkModeTextColor
    private var defaultTitleColor = TextInputFieldConfig.shared.defaultTitleColor
    private var darkModeTitleColor = TextInputFieldConfig.shared.darkModeTitleColor
    private var defaultPlaceHolderTextColor = TextInputFieldConfig.shared.defaultPlaceHolderTextColor
    private var darkModePlaceHolderTextColor = TextInputFieldConfig.shared.darkModePlaceHolderTextColor
    private var defaultDisableColor = TextInputFieldConfig.shared.defaultDisableColor
    private var darkModeDisableColor = TextInputFieldConfig.shared.darkModeDisableColor
    private var defaultBackgroundColor = TextInputFieldConfig.shared.defaultBackgroundColor
    private var darkModeBackgroundColor = TextInputFieldConfig.shared.darkModeBackgroundColor
    private var defaultErrorTextColor = TextInputFieldConfig.shared.defaultErrorTextColor
    private var darkModeErrorTextColor = TextInputFieldConfig.shared.darkModeErrorTextColor
    private var defaultBorderColor = TextInputFieldConfig.shared.defaultBorderColor
    private var darkModeBorderColor = TextInputFieldConfig.shared.darkModeBorderColor
    private var defaultTrailingImageForegroundColor = TextInputFieldConfig.shared.defaultTrailingImageForegroundColor
    private var darkModeTrailingImageForegroundColor = TextInputFieldConfig.shared.darkModeTrailingImageForegroundColor
    private var focusedBorderColorEnable = TextInputFieldConfig.shared.focusedBorderColorEnable
    private var defaultFocusedBorderColor = TextInputFieldConfig.shared.defaultFocusedBorderColor
    private var darkModeFocusedBorderColor = TextInputFieldConfig.shared.darkModeFocusedBorderColor
    
    // Fonts
    private var textFont = TextInputFieldConfig.shared.textFont
    private var titleFont = TextInputFieldConfig.shared.titleFont
    private var errorFont = TextInputFieldConfig.shared.errorFont
    private var placeHolderFont = TextInputFieldConfig.shared.placeHolderFont
    
    // Layout
    private var borderWidth = TextInputFieldConfig.shared.borderWidth
    private var cornerRadius = TextInputFieldConfig.shared.cornerRadius
    private var borderType = TextInputFieldConfig.shared.borderType
    private var disableAutoCorrection = TextInputFieldConfig.shared.disableAutoCorrection
    private var textFieldHeight = TextInputFieldConfig.shared.textFieldHeight
    
    // Initializer
    public init(text: Binding<String>) {
        self.text = text
    }
    
    public var body: some View {
        VStack(spacing: 8) {
            // Display the title text if available
            if let titleText {
                Text(titleText)
                    .font(titleFont)
                    .foregroundColor(getTitleTextColor())
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    // The main text input field (secure or regular)
                    secureAnyView()
                        .placeholder(when: text.wrappedValue.isEmpty) {
                            Text(placeHolderText)
                                .foregroundColor(getPlaceHolderTextColor())
                                .font(placeHolderFont)
                        }
                        .font(textFont)
                        .frame(maxWidth: .infinity)
                        .frame(height: textFieldHeight)
                        .foregroundColor(getTextColor())
                        .disabled(disable?.wrappedValue ?? false)
                        .padding([.leading, .trailing], borderType == .square ? 12 : 1)
                        .disableAutocorrection(disableAutoCorrection)
                        .onChange(of: text.wrappedValue) { newValue in
                            enforceMaxCountAndFilterAllowedCharacters(newValue)
                        }
                        .truncationMode(truncationMode)
                        .background(Color.clear)
                    
                    // Display a trailing image (e.g., for showing password visibility)
                    if let trailingImage {
                        trailingImage
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(getTrailingImageForegroundColor())
                            .frame(width: 25, height: 25)
                            .padding(.trailing, 12)
                            .onTapGesture {
                                handleTrailingImageTap()
                            }
                            .disabled(disable?.wrappedValue ?? false)
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: getCornerRadius())
                        .stroke(getBorderColor(), lineWidth: getBorderWidth(type: .square))
                        .background(getBackgroundColor().cornerRadius(getCornerRadius()))
                )
                
                // Add a bottom border if the border type is 'line'
                if borderType == .line {
                    Rectangle()
                        .frame(height: getBorderWidth(type: .line))
                        .foregroundColor(getBorderColor())
                }
            }
            
            // Display error text if validation fails
            if let error = error?.wrappedValue, error {
                Text(errorText?.wrappedValue ?? "")
                    .font(errorFont)
                    .foregroundColor(getErrorTextColor())
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .accessibilityElement(children: .combine)
    }
    
    // MARK: - Validation Logic
    
    // Validate the input when the user presses "Enter"
    private func validateInputOnEnter(_ input: String) {
        let lettersCount = input.filter { $0.isLetter }.count
        let numbersCount = input.filter { $0.isNumber }.count
        
        // Check if the input meets the minimum letter and number requirements
        guard lettersCount >= minLetters, numbersCount >= minNumbers else {
            error?.wrappedValue = true
            errorText?.wrappedValue = "Must contain at least \(minLetters) letters and \(minNumbers) numbers."
            return
        }
        
        // Clear the error if the input is valid
        error?.wrappedValue = false
        errorText?.wrappedValue = ""
    }
    
    // Enforce maximum character count and filter disallowed characters
    private func enforceMaxCountAndFilterAllowedCharacters(_ input: String) {
        let filteredInput = input.filter { character in
            character.unicodeScalars.allSatisfy { allowedCharacters.contains($0) }
        }
        
        guard let maxCount = maxCount, filteredInput.count > maxCount else {
            text.wrappedValue = filteredInput
            return
        }
        
        // Trim the input to the maximum allowed character count
        let finalInput = String(filteredInput.prefix(maxCount))
        if finalInput != text.wrappedValue {
            text.wrappedValue = finalInput
        }
    }

    // Generate the appropriate view based on whether secure text is enabled
    private func secureAnyView() -> AnyView {
        if !secureText {
            return AnyView(TextField("", text: text, onEditingChanged: { isEditing in
                isFocused = isEditing
            }, onCommit: {
                validateInputOnEnter(text.wrappedValue)
            }))
        } else {
            return AnyView(SecureField("", text: text, onCommit: {
                validateInputOnEnter(text.wrappedValue)
            }))
        }
    }
    
    // Handle the action when the trailing image is tapped
    private func handleTrailingImageTap() {
        if !isSecureText {
            trailingImageClick?()
        } else {
            secureText.toggle()
            trailingImage = secureText ? secureTextImageClose : secureTextImageOpen
        }
    }
    
    // MARK: - Getters for Colors and Styling
    
    // Get the border color based on the current state (focused, error, etc.)
    private func getBorderColor() -> Color {
        if error?.wrappedValue ?? false {
            return getErrorTextColor()
        }
        if colorScheme == .light {
            return isFocused && focusedBorderColorEnable ? defaultFocusedBorderColor : defaultBorderColor
        } else {
            return isFocused && focusedBorderColorEnable ? darkModeFocusedBorderColor : darkModeBorderColor
        }
    }
    
    // Get the background color based on the current state and color scheme
    private func getBackgroundColor() -> Color {
        return (disable?.wrappedValue ?? false)
            ? (colorScheme == .light ? defaultDisableColor : darkModeDisableColor)
            : (colorScheme == .light ? defaultBackgroundColor : darkModeBackgroundColor)
    }
    
    // Get the text color based on the current color scheme
    private func getTextColor() -> Color {
        return colorScheme == .light ? defaultTextColor : darkModeTextColor
    }
    
    // Get the error text color based on the current color scheme
    private func getErrorTextColor() -> Color {
        return colorScheme == .light ? defaultErrorTextColor : darkModeErrorTextColor
    }
    
    // Get the placeholder text color based on the current color scheme
    private func getPlaceHolderTextColor() -> Color {
        return colorScheme == .light ? defaultPlaceHolderTextColor : darkModePlaceHolderTextColor
    }
    
    // Get the title text color based on the current color scheme
    private func getTitleTextColor() -> Color {
        return colorScheme == .light ? defaultTitleColor : darkModeTitleColor
    }
    
    // Get the border width based on the border type
    private func getBorderWidth(type: BorderType) -> CGFloat {
        return type == .square ? (borderType == .square ? borderWidth : 0.0) : borderWidth
    }
    
    // Get the corner radius based on the border type
    private func getCornerRadius() -> CGFloat {
        return borderType == .square ? cornerRadius : 0.0
    }
    
    // Get the color for the trailing image based on the current color scheme
    private func getTrailingImageForegroundColor() -> Color {
        return colorScheme == .light ? defaultTrailingImageForegroundColor : darkModeTrailingImageForegroundColor
    }
}

// MARK: - View Extensions

@available(iOS 13.0, *)
extension TextInputField {
    public func setTextColor(_ color: Color) -> Self {
        var copy = self
        copy.defaultTextColor = color
        return copy
    }
    
    public func setDarkModeTextColor(_ color: Color) -> Self {
        var copy = self
        copy.darkModeTextColor = color
        return copy
    }
    
    public func setTitleText(_ titleText: String) -> Self {
        var copy = self
        copy.titleText = titleText
        return copy
    }
    
    public func setTitleColor(_ titleColor: Color) -> Self {
        var copy = self
        copy.defaultTitleColor = titleColor
        return copy
    }
    
    public func setDarkModeTitleColor(_ titleColor: Color) -> Self {
        var copy = self
        copy.darkModeTitleColor = titleColor
        return copy
    }
    
    public func setTitleFont(_ titleFont: Font) -> Self {
        var copy = self
        copy.titleFont = titleFont
        return copy
    }
    
    public func setPlaceHolderText(_ placeHolderText: String) -> Self {
        var copy = self
        copy.placeHolderText = placeHolderText
        return copy
    }
    
    public func setPlaceHolderFont(_ placeHolderFont: Font) -> Self {
        var copy = self
        copy.placeHolderFont = placeHolderFont
        return copy
    }
    
    public func setPlaceHolderTextColor(_ color: Color) -> Self {
        var copy = self
        copy.defaultPlaceHolderTextColor = color
        return copy
    }
    
    public func setDarkModePlaceHolderTextColor(_ color: Color) -> Self {
        var copy = self
        copy.darkModePlaceHolderTextColor = color
        return copy
    }
    
    public func setDisable(_ disable: Binding<Bool>) -> Self {
        var copy = self
        copy.disable = disable
        return copy
    }
    
    public func setDisableColor(_ color: Color) -> Self {
        var copy = self
        copy.defaultDisableColor = color
        return copy
    }
    
    public func setDarkModeDisableColor(_ color: Color) -> Self {
        var copy = self
        copy.darkModeDisableColor = color
        return copy
    }
    
    public func setError(errorText: Binding<String>, error: Binding<Bool>) -> Self {
        var copy = self
        copy.error = error
        copy.errorText = errorText
        return copy
    }
    
    public func setErrorTextColor(_ color: Color) -> Self {
        var copy = self
        copy.defaultErrorTextColor = color
        return copy
    }
    
    public func setDarkModeErrorTextColor(_ color: Color) -> Self {
        var copy = self
        copy.darkModeErrorTextColor = color
        return copy
    }
    
    public func setErrorFont(_ errorFont: Font) -> Self {
        var copy = self
        copy.errorFont = errorFont
        return copy
    }
    
    public func setTrailingImage(_ image: Image, click: @escaping (() -> Void)) -> Self {
        var copy = self
        copy.trailingImage = image
        copy.trailingImageClick = click
        return copy
    }
    
    public func setSecureText(_ secure: Bool) -> Self {
        var copy = self
        copy.secureText = secure
        if secure {
            copy.trailingImage = copy.secureTextImageClose
        }
        copy.isSecureText = secure
        return copy
    }
    
    public func setSecureTextImages(open: Image, close: Image) -> Self {
        var copy = self
        copy.secureTextImageOpen = open
        copy.secureTextImageClose = close
        copy.trailingImage = copy.secureTextImageClose
        return copy
    }
    
    public func setMaxCount(_ count: Int) -> Self {
        var copy = self
        copy.maxCount = count
        return copy
    }
    
    public func setTruncateMode(_ mode: Text.TruncationMode) -> Self {
        var copy = self
        copy.truncationMode = mode
        return copy
    }
    
    public func setBorderColor(_ color: Color) -> Self {
        var copy = self
        copy.defaultBorderColor = color
        return copy
    }
    
    public func setDarkModeBorderColor(_ color: Color) -> Self {
        var copy = self
        copy.darkModeBorderColor = color
        return copy
    }
    
    public func setTrailingImageForegroundColor(_ color: Color) -> Self {
        var copy = self
        copy.defaultTrailingImageForegroundColor = color
        return copy
    }
    
    public func setDarkModeTrailingImageForegroundColor(_ color: Color) -> Self {
        var copy = self
        copy.darkModeTrailingImageForegroundColor = color
        return copy
    }
    
    public func setFocusedBorderColorEnable(_ enable: Bool) -> Self {
        var copy = self
        copy.focusedBorderColorEnable = enable
        return copy
    }
    
    public func setFocusedBorderColor(_ color: Color) -> Self {
        var copy = self
        copy.defaultFocusedBorderColor = color
        return copy
    }
    
    public func setDarkModeFocusedBorderColor(_ color: Color) -> Self {
        var copy = self
        copy.darkModeFocusedBorderColor = color
        return copy
    }
    
    public func setBorderWidth(_ width: CGFloat) -> Self {
        var copy = self
        copy.borderWidth = width
        return copy
    }
    
    public func setBackgroundColor(_ color: Color) -> Self {
        var copy = self
        copy.defaultBackgroundColor = color
        return copy
    }
    
    public func setDarkModeBackgroundColor(_ color: Color) -> Self {
        var copy = self
        copy.darkModeBackgroundColor = color
        return copy
    }
    
    public func setCornerRadius(_ radius: CGFloat) -> Self {
        var copy = self
        copy.cornerRadius = radius
        return copy
    }
    
    public func setBorderType(_ type: BorderType) -> Self {
        var copy = self
        copy.borderType = type
        return copy
    }
    
    public func setDisableAutoCorrection(_ disable: Bool) -> Self {
        var copy = self
        copy.disableAutoCorrection = disable
        return copy
    }
    
    public func setTextFieldHeight(_ height: CGFloat) -> Self {
        var copy = self
        copy.textFieldHeight = height
        return copy
    }
    
    public func setMinLetters(_ count: Int) -> Self {
        var copy = self
        copy.minLetters = count
        return copy
    }
    
    public func setMinNumbers(_ count: Int) -> Self {
        var copy = self
        copy.minNumbers = count
        return copy
    }
    
    public func setAllowedCharacters(_ characterSet: CharacterSet) -> Self {
        var copy = self
        copy.allowedCharacters = characterSet
        return copy
    }
}

@available(iOS 13.0, *)
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}

// Example usage of TextInputField:
/*
struct ContentView: View {
    @State private var text = ""
    @State private var isError = false
    @State private var errorText = ""
    @State private var isSecure = false
    @State private var isFocused = false

    var body: some View {
        VStack(spacing: 16) {
            // Regular text input field
            TextInputField(text: $text)
                .setTitleText("User ID")
                .setPlaceHolderText("Type here")
                .setBorderColor(Constants.TextTextSecondary)
                .setCornerRadius(12)
                .setBackgroundColor(Constants.BrandWhite)
                .setDarkModeBackgroundColor(Constants.BrandCharcoal)
                .setTrailingImage(Image("profile")) {
                    // Trailing Image Click Action
                    print("Profile icon tapped")
                }
                .setTextColor(Constants.TextTextPrimary)
                .setDarkModeTextColor(Constants.BrandDarkGrey)
                .setErrorTextColor(.red)
                .setDisableAutoCorrection(true)
                .setMinLetters(2)
                .setMinNumbers(2)
                .setAllowedCharacters(.alphanumerics)
                .setMaxCount(12)
                .setError(errorText: $errorText, error: $isError)
                .onEditingChanged { isEditing in
                    isFocused = isEditing
                }

            // Secure text input field (e.g., for passwords)
            TextInputField(text: $text)
                .setTitleText("Password")
                .setPlaceHolderText("Enter your password")
                .setBorderColor(Constants.TextTextSecondary)
                .setCornerRadius(12)
                .setBackgroundColor(Constants.BrandWhite)
                .setDarkModeBackgroundColor(Constants.BrandCharcoal)
                .setTrailingImage(isSecure ? Image(systemName: "eye.slash.fill") : Image(systemName: "eye.fill")) {
                    // Toggle secure text visibility
                    isSecure.toggle()
                }
                .setSecureText(isSecure)
                .setTextColor(Constants.TextTextPrimary)
                .setDarkModeTextColor(Constants.BrandDarkGrey)
                .setErrorTextColor(.red)
                .setMaxCount(20)
                .setError(errorText: $errorText, error: $isError)
                .onEditingChanged { isEditing in
                    isFocused = isEditing
                }
                .setDisableAutoCorrection(true)

            // Text input field with custom font and padding
            TextInputField(text: $text)
                .setTitleText("Custom Field")
                .setPlaceHolderText("Custom font and padding")
                .setTextColor(Constants.TextTextPrimary)
                .setTitleFont(.headline)
                .setPlaceHolderFont(.caption)
                .setPadding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                .setCornerRadius(8)
                .setMaxCount(15)
                .setError(errorText: $errorText, error: $isError)
        }
        .padding()
    }
}
*/
