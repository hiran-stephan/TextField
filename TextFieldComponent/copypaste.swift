class BottomSheetHostingController<Content: View>: UIHostingController<Content> {
    private let detents: [UISheetPresentationController.Detent]

    init(rootView: Content, detents: [UISheetPresentationController.Detent]) {
        self.detents = detents
        super.init(rootView: rootView)
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let presentation = sheetPresentationController {
            presentation.detents = detents
            presentation.prefersGrabberVisible = true
        }
    }
}

public struct BottomSheetView<Content: View>: UIViewControllerRepresentable {
    let content: () -> Content
    let detents: [UISheetPresentationController.Detent]

    public init(
        detents: [UISheetPresentationController.Detent] = [.fraction(0.75), .large()],
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
        self.detents = detents
    }

    public func makeUIViewController(context: Context) -> BottomSheetHostingController<Content> {
        BottomSheetHostingController(rootView: content(), detents: detents)
    }

    public func updateUIViewController(
        _ uiViewController: BottomSheetHostingController<Content>,
        context: Context
    ) {
        // No updates needed
    }
}


    .sheet(isPresented: shouldShowLearnMoreDialog, content: {
        BottomSheetView(detents: [.fraction(0.75), .large()]) {
            ChangePasswordLearnMoreScreen(viewModel: viewModel)
        }
    })
