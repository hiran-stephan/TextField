import SwiftUI

public struct HighPriorityButton<Label: View>: View {
    public let action: (() -> Void)?   // ✅ optional action
    @ViewBuilder public var label: () -> Label

    public init(action: (() -> Void)? = nil,
                @ViewBuilder label: @escaping () -> Label) {
        self.action = action
        self.label = label
    }

    public var body: some View {
        if #available(iOS 18, *) {
            Button(action: {}) {
                label()
            }
            .contentShape(Rectangle())
            .highPriorityTapGesture { action?() }   // call only if non-nil
        } else {
            if let action {
                Button(action: action) {
                    label()
                }
            } else {
                Button(action: {}) { label() }      // fallback if no action
            }
        }
    }
}
