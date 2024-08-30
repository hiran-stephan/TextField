import SwiftUI

// Usage Example
struct ContentView: View {
    @State private var text: String = ""
    @State private var showError: Bool = false
    // State variables to handle alerts
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        VStack {
            TextInput(
                text: $text,
                enabled: true,
                label: "Username",
                labelIcon: "person.fill",
                leadingIcon: "lock.fill",
                trailingIcon: "eye.fill",
                placeholder: "Enter your username",
                isError: showError,
                errorText: "Invalid username",
                onTrailingIconClicked: {
                    alertMessage = "Trailing icon clicked"
                    showAlert = true
                },
                onQuickTipClicked: {
                    alertMessage = "Quick tip clicked"
                    showAlert = true
                }
            )
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Alert"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            
            Button(action: {
                showError.toggle()
            }) {
                Text(showError ? "Hide Error" : "Show Error")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .accessibilityLabel(Text(showError ? "Hide Error" : "Show Error"))
            }
            .padding(.top, 20)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
