//
//  ContentView.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 29/08/24.
//

import SwiftUI

struct ContentView: View {
    @State var text = ""
    @State var isError = false
    @State var errorText = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.MarginXs) {
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
                .setError(errorText: $errorText, error: $isError) // Pass the error bindings here
        }
        .padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Constants {
    static let size0: CGFloat = 1
    static let size40: CGFloat = 40
    static let spacing2: CGFloat = 8
    static let TextTextPrimary: Color = Color(red: 0.22, green: 0.23, blue: 0.24)
    
    static let FontSizeBody: CGFloat = 17
    static let Padding3Xs: CGFloat = 12
    static let BrandWhite: Color = .white
    static let TextTextSecondary: Color = Color(red: 0.38, green: 0.39, blue: 0.4)
    
    static let Padding2Xs: CGFloat = 16
    static let BrandCharcoal: Color = Color(red: 0.22, green: 0.23, blue: 0.24)
    
    static let MarginXs: CGFloat = 8
    static let MarginSm: CGFloat = 12
    static let MarginNone: CGFloat = 0
    static let MarginMd: CGFloat = 16
    static let IllustrationPinkBg: Color = Color(red: 0.96, green: 0.89, blue: 0.91)
    
    static let MainBg: Color = .blue
    static let BrandDarkGrey: Color = Color(red: 0.53, green: 0.53, blue: 0.54)
}
