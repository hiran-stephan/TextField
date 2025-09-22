import SwiftUI

struct HighPriorityTapGestureModifier: ViewModifier {
    let minInterval: TimeInterval   // e.g., 0.5
    let action: @MainActor () -> Void

    @Environment(\.isEnabled) private var isEnabled
    @State private var lastFireTime: TimeInterval = 0

    private func trigger() {
        guard isEnabled else { return }
        let now = Date().timeIntervalSince1970
        if now - lastFireTime >= minInterval {
            lastFireTime = now
            action()
        }
    }

    func body(content: Content) -> some View {
        content
            // Make entire area tappable for touch
            .contentShape(Rectangle())
            // Make VO/keyboard activation call our action
            .accessibilityAddTraits(.isButton)
            .accessibilityAction(.activate) { trigger() }
            // Touch handling (prioritized on iOS 18)
            .modifier(HighPriorityTapWrapper(onTap: trigger))
    }

    // Keep wrapper private & versioned
    @available(iOS 18.0, *)
    private struct HighPriority18: ViewModifier {
        let onTap: () -> Void
        func body(content: Content) -> some View {
            content.highPriorityGesture(TapGesture().onEnded { onTap() })
        }
    }

    private struct HighPriorityTapWrapper: ViewModifier {
        let onTap: () -> Void
        func body(content: Content) -> some View {
            if #available(iOS 18.0, *) {
                content.modifier(HighPriority18(onTap: onTap))
            } else {
                content.simultaneousGesture(TapGesture().onEnded { onTap() })
            }
        }
    }
}

public extension View {
    /// Attach a throttled, unified tap handler (touch + VO activate)
    func onButtonTap(
        minInterval: TimeInterval = 0.5,
        _ action: @escaping @MainActor () -> Void
    ) -> some View {
        modifier(HighPriorityTapGestureModifier(minInterval: minInterval, action: action))
    }
}
