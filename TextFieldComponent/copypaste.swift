import SwiftUI

/// Ensures taps are recognized with high priority on iOS 18+
/// and throttles rapid re-taps within `minInterval`.
struct HighPriorityThrottledTapModifier: ViewModifier {
    let minInterval: TimeInterval   // seconds (e.g. 0.5)
    let action: () -> Void

    @State private var lastFireTime: TimeInterval = 0

    private func handleTap() {
        let now = Date().timeIntervalSince1970
        if now - lastFireTime >= minInterval {
            lastFireTime = now
            action()
        }
    }

    func body(content: Content) -> some View {
        Group {
            if #available(iOS 18.0, *) {
                content.highPriorityGesture(
                    TapGesture().onEnded { _ in handleTap() }
                )
            } else {
                content.onTapGesture { handleTap() }
            }
        }
    }
}

public extension View {
    /// Attach a high-priority (iOS 18+) throttled tap handler.
    func onHighPriorityThrottledTap(
        minInterval: TimeInterval = 0.5,  // 500ms
        _ action: @escaping () -> Void
    ) -> some View {
        modifier(HighPriorityThrottledTapModifier(minInterval: minInterval, action: action))
    }
}

// Keep Button for native highlighting/accessibility; route the real action via the modifier.
// (Optional) contentShape makes the whole row tappable.
Button(action: {}) {
    ListCellBaseView()
}
.contentShape(Rectangle())
.onHighPriorityThrottledTap(0.5) {
    // your action
}
