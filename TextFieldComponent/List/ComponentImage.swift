//
//  ComponentImage.swift
//  ListCell
//
//  Created by Hiran Stephan on 04/10/24.
//

import Foundation
import SwiftUI

public struct ComponentImage: View {
    let name: String
    let resizable: Bool

    public init(_ name: String, resizable: Bool = false) {
        self.name = name
        self.resizable = resizable
    }

    public var body: some View {
        if resizable {
            Image(name, bundle: Bundle.main)
                .resizable()
        } else {
            Image(name, bundle: Bundle.main)
        }
    }
}
