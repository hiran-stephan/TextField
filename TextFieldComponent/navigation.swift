/// A `PreferenceKey` used to measure and share a view's frame information within its container.
/// It allows child views to pass their `CGRect` frame values up the view hierarchy.
struct ContainerFramePreferenceKey: PreferenceKey {
    /// The default value of the preference, initialized to an empty `CGRect`.
    static var defaultValue: CGRect = .zero

    /// Combines the current value and the next value for the preference.
    /// - Parameters:
    ///   - value: The current value of the preference.
    ///   - nextValue: A closure that provides the next `CGRect` value.
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
