//
//  AlertView.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 25/09/24.
//

import Foundation
import SwiftUI

// MARK: - ContentView (Example)
/// Example usage of the custom multi-button alert with different actions.
struct ContentView: View {
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
        ContentView()
    }
}


// Usage Example
/*
Button("Show Custom Alert") {
    showAlert = true
}
.presentAlert(
    isVisible: $showAlert,                      // Bind the alert visibility to the state
    title: "Custom Alert",                      // Title of the alert
    message: "This is a custom alert message.", // Message of the alert
    actions: [                                  // Array of actions (buttons)
        AlertActionConfiguration(
            label: "Option 1",                  // Button label
            action: { print("Option 1 pressed") } // Button action
        ),
        AlertActionConfiguration(
            label: "Option 2",                  // Button label
            action: { print("Option 2 pressed") }
        ),
        AlertActionConfiguration(
            label: "Delete",                    // Destructive button label
            type: .destructive,                 // Button type (destructive)
            action: { print("Delete pressed") }
        )
             ]
)

*/
