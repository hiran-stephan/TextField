let finalState: InputFieldState = {
    switch inputFieldState {
    case .error: return isFocused ? .errorFocused : .error
    case .default: return isFocused ? .focused : .default
    default: return inputFieldState
    }
}()
