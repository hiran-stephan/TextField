struct ViewHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

struct StickyFooterModifier<Footer: View>: ViewModifier {
    let footer: () -> Footer

    @State private var contentHeight: CGFloat = 0

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            let screenHeight = geometry.size.height
            let bottomSafeArea = geometry.safeAreaInsets.bottom

            ScrollView {
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        content
                    }
                    .background(
                        GeometryReader { proxy in
                            Color.clear
                                .preference(
                                    key: ViewHeightPreferenceKey.self,
                                    value: proxy.size.height
                                )
                        }
                    )

                    // Spacer to push footer if needed
                    if contentHeight < screenHeight {
                        Spacer(minLength: screenHeight - contentHeight)
                    }

                    // Footer
                    footer()
                        .padding(.top, 16)
                        .padding(.bottom, bottomSafeArea + 24) // ✅ Fix here
                }
                .padding(.horizontal, 16)
            }
            .onPreferenceChange(ViewHeightPreferenceKey.self) { height in
                contentHeight = height
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}


extension View {
    func stickyFooter<Footer: View>(
        @ViewBuilder footer: @escaping () -> Footer
    ) -> some View {
        self.modifier(StickyFooterModifier(footer: footer))
    }
}
