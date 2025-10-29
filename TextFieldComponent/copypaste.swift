#if TEST || DEBUG
enum NavigationOption {
    case setAsRoot(animated: Bool, param: Any?)
    case push
    case present
}
#endif

it("embeds the FRM screen in a UINavigationController") {
    let center = PanelHelper.getPanelFrame()?.center
    expect(center).to(beAKindOf(UINavigationController.self))

    let nav = center as? UINavigationController
    expect(nav?.visibleViewController).to(beAKindOf(FRMWebViewNavigation.self))
    // or PushPayLoadViewController.self based on the path you’re testing
}


waitUntil(timeout: .seconds(2)) { done in
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        let visible = visibleContent(of: PanelHelper.getPanelFrame()?.center)
        expect(visible).to(beAKindOf(FRMWebViewNavigation.self)) // or PushPayLoadViewController
        done()
    }
}
