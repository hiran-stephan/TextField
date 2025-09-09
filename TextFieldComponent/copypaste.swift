import SwiftUI

struct HighPriorityButton<Label: View>: View {
    let action: () -> Void
    @ViewBuilder var label: () -> Label

    var body: some View {
        if #available(iOS 18, *) {
            // Empty Button for accessibility/visuals, gesture handled via modifier
            Button(action: {}) {
                label()
            }
            .contentShape(Rectangle())
            .highPriorityTapGesture(action: action) // ✅ use your modifier here
        } else {
            // Pre–iOS 18: fallback to normal button
            Button(action: action) {
                label()
            }
        }
    }
}
