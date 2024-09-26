import SwiftUI

// Constants Enum
enum AlertConstants {
    static let backgroundOpacity: Double = 0.4
    static let cornerRadius: CGFloat = 15
    static let shadowRadius: CGFloat = 10
    static let padding: CGFloat = 10
    static let topPadding: CGFloat = 20
    static let buttonSpacing: CGFloat = 10
    static let alertContainerHorizontalPadding: CGFloat = 15
    static let alertTitleFont: Font = .headline
    static let alertMessageFont: Font = .body
}

// Struct for button configurations with auto-dismiss functionality
struct AlertActionConfiguration {
    let label: String
    let type: AlertButtonType
    let action: (() -> Void)?
    let autoDismiss: Bool
    
    init(label: String, type: AlertButtonType = .none, autoDismiss: Bool = true, action: (() -> Void)? = nil) {
        self.label = label
        self.type = type
        self.action = action
        self.autoDismiss = autoDismiss
    }
}

// Enum for button roles (e.g., default, cancel, destructive)
enum AlertButtonType {
    case none
    case cancel
    case destructive
}

// Custom ViewModifier for reusable multi-button modal alert
struct AlertViewModifier: ViewModifier {
    @Binding var isVisible: Bool
    let title: String?
    let message: String?
    let actions: [AlertActionConfiguration]
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isVisible {
                backgroundOverlay()
                
                alertContainer()
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.easeInOut, value: isVisible)
            }
        }
    }
    
    // Background overlay for the alert
    private func backgroundOverlay() -> some View {
        Color.black.opacity(AlertConstants.backgroundOpacity)
            .ignoresSafeArea()
            .onTapGesture {
                isVisible = false
            }
    }
    
    // Main container for the alert
    private func alertContainer() -> some View {
        VStack(spacing: AlertConstants.buttonSpacing) {
            if let title = title {
                alertTitle(title)
            }
            if let message = message {
                alertMessage(message)
            }
            
            alertActions()
            
            // Optionally you can still hardcode a "Cancel" button or pass it via the `actions` array
            Button("Cancel") {
                isVisible = false
            }
            .foregroundColor(.red)
            .padding(.top, AlertConstants.topPadding)
            
        }
        .padding()
        .background(Color.white)
        .cornerRadius(AlertConstants.cornerRadius)
        .shadow(radius: AlertConstants.shadowRadius)
        .padding(.horizontal, AlertConstants.alertContainerHorizontalPadding)
    }
    
    // Alert title component
    private func alertTitle(_ title: String) -> some View {
        Text(title)
            .font(AlertConstants.alertTitleFont)
            .padding(.top)
    }
    
    // Alert message component
    private func alertMessage(_ message: String) -> some View {
        Text(message)
            .font(AlertConstants.alertMessageFont)
            .multilineTextAlignment(.center)
            .padding([.leading, .trailing])
    }
    
    // Alert buttons container
    private func alertActions() -> some View {
        VStack(spacing: AlertConstants.buttonSpacing) {
            ForEach(actions.indices, id: \.self) { index in
                Button(actions[index].label) {
                    handleAction(for: actions[index])
                }
                .buttonStyle(buttonStyle(for: actions[index].type))
            }
        }
    }
    
    private func buttonStyle(for type: AlertButtonType) -> some ButtonStyle {
        switch type {
        case .destructive:
            return DestructiveButtonStyle()
        case .cancel:
            return CancelButtonStyle()
        default:
            return DefaultButtonStyle()
        }
    }
    
    private func handleAction(for config: AlertActionConfiguration) {
        config.action?()
        if config.autoDismiss {
            isVisible = false
        }
    }
}

// Extension for creating reusable multi-button modal alerts
extension View {
    func presentAlert(
        isVisible: Binding<Bool>,
        title: String? = nil,
        message: String? = nil,
        actions: [AlertActionConfiguration]
    ) -> some View {
        self.modifier(AlertViewModifier(isVisible: isVisible, title: title, message: message, actions: actions))
    }
}

// Custom ButtonStyles for different roles
struct DefaultButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue.opacity(configuration.isPressed ? 0.7 : 1.0))
            .foregroundColor(.white)
            .cornerRadius(AlertConstants.cornerRadius)
    }
}

struct DestructiveButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.red.opacity(configuration.isPressed ? 0.7 : 1.0))
            .foregroundColor(.white)
            .cornerRadius(AlertConstants.cornerRadius)
    }
}

struct CancelButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(configuration.isPressed ? 0.7 : 1.0))
            .foregroundColor(.white)
            .cornerRadius(AlertConstants.cornerRadius)
    }
}

// Example usage of the custom multi-button alert with improvements
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
