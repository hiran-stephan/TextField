//
//  FigmaCode.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 29/08/24.
//


import SwiftUI

struct ContentViewFigma: View {
    @State var text = ""
    @State var isError = false
    @State var errorText = ""
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center, spacing: 0) {
                    // Body
                    Text("User ID")
                        .font(.custom("Whitney", size: Constantss.FontSizeBody))
                        .foregroundColor(Constantss.TextTextPrimary)
                }
                .padding(.horizontal, 0)
                .padding(.vertical, Constantss.spacing2)
                .cornerRadius(Constantss.size0)
                
                HStack(alignment: .top, spacing: Constantss.Padding3Xs) {
                    // Body
                    Text("Type here")
                        .font(.custom("Whitney", size: Constantss.FontSizeBody))
                        .foregroundColor(Constantss.BrandDarkGrey)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    Image("profile")
                        .frame(width: 24, height: 24)
                        .cornerRadius(Constantss.size0)
                }
                .padding(Constantss.Padding2Xs)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .background(Constantss.BrandWhite)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .inset(by: 0.5)
                        .stroke(Constantss.TextTextSecondary, lineWidth: Constantss.size0)
                )
            }
            .padding(0)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .cornerRadius(Constantss.size0)
            .padding(0)
            .frame(maxWidth: .infinity, alignment: .top)
            .cornerRadius(Constantss.size0)
        }
        .padding(.horizontal, Constantss.MarginMd)
    }
}

struct ContentViewFigma_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewFigma()
    }
}


struct Constantss {
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
