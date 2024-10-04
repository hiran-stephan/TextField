//
//  ListCellIconView.swift
//  ListCell
//
//  Created by Hiran Stephan on 04/10/24.
//

import Foundation
import SwiftUI

/// A reusable view for displaying icons in list cells, with customizable padding.
public struct ListCellIconView: View {

    let imageName: String
    let padding: CGFloat
    
    /// Initializes the `ListCellIconView` with an image name and optional padding.
    /// - Parameters:
    ///   - imageName: The name of the image to display.
    ///   - padding: The padding around the image (defaults to no padding).
    public init(imageName: String, padding: CGFloat = BankingTheme.spacing.noPadding) {
        self.imageName = imageName
        self.padding = padding
    }
    
    public var body: some View {
        ZStack {
            ComponentImage(imageName, resizable: true)
                .frame(width: BankingTheme.dimens.large, height: BankingTheme.dimens.large)
                .padding(padding)
        }
    }
}

