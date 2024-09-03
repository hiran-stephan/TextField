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
//            TextFieldGeneral(
//                text: $text,
//                label: "Email",
//                labelIcon: "info",
//                trailingIcon: "padlock",
//                placeholder: "Enter your email",
//                isError: showError,
//                errorText: "Invalid email address",
//                errorIcon: "error"
//            )
//            Spacer()
            TextFieldPassword(
                text: $text,
                label: "Password",
                placeholder: "Enter your password",
                labelIcon: "info",
//                leadingIcon: "padlock",
                isError: true,
                errorText: "Invalid password",
                onQuickTipClicked: {
                    print("Quick tip clicked")
                },
                onCommit: {
                    print("Done")
                }
            )

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
