@available(iOS 18.0, *)
private struct HighPriorityTapWrapper: ViewModifier {
    let action: () -> Void

    func body(content: Content) -> some View {
        content.highPriorityGesture(
            TapGesture().onEnded { _ in action() }
        )
    }
}

func body(content: Content) -> some View {
    if #available(iOS 18.0, *) {
        content.modifier(HighPriorityTapWrapper(action: handleTap))
    } else {
        content.simultaneousGesture(
            TapGesture().onEnded { _ in handleTap() }
        )
    }
}


