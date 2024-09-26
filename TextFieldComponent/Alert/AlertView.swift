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

import SwiftUI

struct TooltipAlertView: View {
    @State private var showTooltipAlert = false  // State variable to control the visibility of the alert

    let tooltipTitle: String
    let tooltipMessage: String
    let okButtonLabel: String
    let isRemembered: Bool

    var body: some View {
        VStack {
            Text(tooltipTitle)
            Toggle(isOn: .constant(isRemembered)) {
                Text("Remember User ID")
            }
            Button(action: {
                // Set showTooltipAlert to true when the button is clicked to show the alert
                showTooltipAlert.toggle()
            }) {
                Image(systemName: "info.circle")
            }
        }
        // Reuse your earlier custom alert implementation, renamed for TooltipAlert
        .presentAlert(
            isVisible: $showTooltipAlert,             // Bind the alert visibility to the state variable
            title: tooltipTitle,                      // Title passed from outside
            message: tooltipMessage,                  // Message passed from outside
            actions: [
                AlertActionConfiguration(
                    label: okButtonLabel,      // OK button label passed from outside
                    action: {
                        print("\(okButtonLabel) pressed")
                        showTooltipAlert = false      // Dismiss the alert by setting showTooltipAlert to false
                    }
                )
            ]
        )
        .padding()
    }
}

// MARK: - Preview for TooltipAlertView
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TooltipAlertView(
            tooltipTitle: "Custom Alert",
            tooltipMessage: "This is a custom tooltip alert message.",
            okButtonLabel: "OK",
            isRemembered: true
        )
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
