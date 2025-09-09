/// A custom SwiftUI button that ensures consistent tap handling across iOS versions.
///
/// - On **iOS 18+**, uses an empty `Button` action with
///   `.highPriorityTapGesture` to avoid double-fire issues.
/// - On **earlier iOS**, falls back to a normal `Button`.
///
/// ### Usage
/// ```swift
/// HighPriorityButton(action: {
///     print("Tapped")
/// }) {
///     Text("Continue")
/// }
/// ```
public struct HighPriorityButton<Label: View>: View { ... }
