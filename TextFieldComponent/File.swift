import SwiftUI
import Combine

struct ContentView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    
    @FocusState private var focusedField: Field?

    enum Field {
        case username
        case password
    }

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Username Field
                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .focused($focusedField, equals: .username) // Track focus state
                    
                    // Username Field
                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .focused($focusedField, equals: .username) // Track focus state
                    
                    // Username Field
                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .focused($focusedField, equals: .username) // Track focus state
                    
                    // Username Field
                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .focused($focusedField, equals: .username) // Track focus state
                    
                    
                    // Username Field
                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .focused($focusedField, equals: .username) // Track focus state

                    // Password Field
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .focused($focusedField, equals: .password) // Track focus state

                    // Login Button
                    Button("Login") {
                        print("Logging in with username: \(username) and password: \(password)")
                        // Dismiss the keyboard when login is pressed
                        focusedField = nil
                    }
                    .padding()
                    
                    Spacer()
                }
            }
        }
        .keyboardResponsive(focusedField: $focusedField) // Apply the custom modifier
        .background(.blue)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

import SwiftUI
import Combine

final class KeyboardResponder: ObservableObject {
    @Published var keyboardHeight: CGFloat = 0
    private var cancellable: AnyCancellable?

    init() {
        // Listen to keyboard notifications and update height accordingly
        let willShow = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { notification -> CGFloat? in
                (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height
            }
        
        let willHide = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .compactMap { _ -> CGFloat? in
                return 0
            }

        cancellable = willShow
            .merge(with: willHide)
            .assign(to: \.keyboardHeight, on: self)
    }
}

import SwiftUI

struct KeyboardResponsiveModifier<Field: Hashable>: ViewModifier {
    @ObservedObject private var keyboardResponder = KeyboardResponder()
    @FocusState.Binding var focusedField: Field?

    func body(content: Content) -> some View {
        content
            .padding(.bottom, 16)  // Adjust by half of the keyboard height
            .animation(.easeOut(duration: 0.3), value: keyboardResponder.keyboardHeight) // Smooth animation
            .onTapGesture {
                // Dismiss the keyboard when tapping outside
                print(keyboardResponder.keyboardHeight)
                focusedField = nil
            }
    }
}

extension View {
    func keyboardResponsive<Field: Hashable>(focusedField: FocusState<Field?>.Binding) -> some View {
        self.modifier(KeyboardResponsiveModifier(focusedField: focusedField))
    }
}
