//
//  AlertView.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 25/09/24.
//

import Foundation
import SwiftUI

// MARK: - ContentView (Example)
struct AlertView: View {
    @State private var showAlert = false

    var body: some View {
        VStack(spacing: 20) {
            Button("Show Custom Alert with Multiple Buttons") {
                showAlert = true
            }
            .presentAlert(
                isVisible: $showAlert,
                title: "Custom Alert",
                message: "This is a custom alert with multiple actions.",
                actions: [
                    AlertActionConfiguration(label: "Option 1", action: { print("Option 1 selected") }),
                    AlertActionConfiguration(label: "Option 2", action: { print("Option 2 selected") }),
                    AlertActionConfiguration(label: "Delete", type: .destructive, action: { print("Delete action selected") })
                ]
            )
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView()
    }
}

/*
 // Usage Example
 
 Button("Show Custom Alert") {
     showAlert = true
 }
 .presentAlert(
     isVisible: $showAlert,
     title: "Custom Alert",
     message: "This is a custom alert message.",
     actions: [
         AlertActionConfiguration(
             label: "Option 1",
             action: { print("Option 1 pressed") }
         ),
         AlertActionConfiguration(
             label: "Option 2",
             action: { print("Option 2 pressed") }
         ),
         AlertActionConfiguration(
             label: "Delete",
             type: .destructive,
             action: { print("Delete pressed") }
         )
     ]
 )
 */
