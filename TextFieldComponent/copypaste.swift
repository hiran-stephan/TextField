#if TEST || DEBUG
enum NavigationOption {
    case setAsRoot(animated: Bool, param: Any?)
    case push
    case present
}
#endif
