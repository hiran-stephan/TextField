Added HighPriorityThrottledTapModifier

Ensures tap gestures are recognized with high priority on iOS 18+.

Falls back to .simultaneousGesture on iOS 17 and below to preserve button highlighting, accessibility, and avoid gesture conflicts.

Includes built-in throttling (minInterval) to prevent rapid duplicate taps.

Updated Button usage

Introduced convenience Button initializer with empty action closure, allowing label-only buttons.

Real tap handling is now managed via .onHighPriorityThrottledTap, consolidating gesture handling and duplicate-tap prevention.
