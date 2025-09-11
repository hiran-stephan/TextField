/// A modifier that ensures tap gestures are recognized with high priority on iOS 18+
/// and throttles rapid re-taps within `minInterval`.
///
/// Use this modifier when:
/// - You need taps to override competing gestures in complex view hierarchies.
/// - You want to prevent accidental double-taps by throttling repeated triggers.
///
/// Accessibility:
/// - Always combine with `.disabled(...)` on the parent control so the element
///   is still exposed to VoiceOver as disabled when appropriate.
///
