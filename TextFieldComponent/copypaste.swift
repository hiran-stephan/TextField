import SwiftUI

struct HighPriorityButton<Label: View>: View {
    let action: () -> Void
    @ViewBuilder var label: () -> Label

    @ViewBuilder
    var body: some View {
        if #available(iOS 18, *) {
            // Use an empty Button action so the high-priority tap is the
            // one that fires (prevents double-fire on iOS 18).
            Button(action: {}) { label() }
                .contentShape(Rectangle())
                .highPriorityGesture(
                    TapGesture().onEnded { action() }
                )
        } else {
            // Pre-iOS 18: regular Button action
            Button(action: action) { label() }
        }
    }
}
