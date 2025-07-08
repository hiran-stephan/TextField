struct ViewHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

struct StickyFooterModifier<Footer: View>: ViewModifier {
    let footer: () -> Footer

    @State private var contentHeight: CGFloat = 0
    @State private var footerHeight: CGFloat = 0

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            let screenHeight = geometry.size.height
            let bottomSafeArea = UIApplication.shared.bottomSafeAreaInset

            ScrollView {
                VStack(spacing: 0) {
                    // Content + Geometry for measuring
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

                    // Spacer if content is short
                    if contentHeight + footerHeight < screenHeight {
                        Spacer(minLength: screenHeight - contentHeight - footerHeight)
                    }

                    // Footer + Geometry
                    VStack(spacing: 0) {
                        footer()
                            .padding(.top, 16)
                            .padding(.bottom, bottomSafeArea + 24)
                    }
                    .background(
                        GeometryReader { proxy in
                            Color.clear
                                .onAppear {
                                    footerHeight = proxy.size.height
                                }
                                .onChange(of: proxy.size.height) {
                                    footerHeight = $0
                                }
                        }
                    )
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


extension UIApplication {
    var bottomSafeAreaInset: CGFloat {
        let window = UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first

        return window?.safeAreaInsets.bottom ?? 0
    }
}
