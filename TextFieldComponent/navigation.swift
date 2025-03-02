import SwiftUI

struct ErrorCodeModifier: ViewModifier {
    let errorCode: String?
    let errorColor: Color

    func body(content: Content) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            content
            if let errorCode = errorCode, !errorCode.isEmpty {
                Text(" \(errorCode)")
                    .foregroundColor(errorColor)
                    .font(.caption) // Adjust font style if needed
            }
        }
    }
}

extension View {
    func appendErrorCode(_ errorCode: String?, color: Color = .red) -> some View {
        self.modifier(ErrorCodeModifier(errorCode: errorCode, errorColor: color))
    }
}

Text("This is an error message")
    .appendErrorCode("E101", color: .red)
