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
        let bottomInset = UIApplication.shared.bottomSafeAreaInset

        ScrollView {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    content
                }
                .background(
                    GeometryReader { proxy in
                        Color.clear
                            .preference(key: ViewHeightPreferenceKey.self,
                                        value: proxy.size.height)
                    }
                )

                if contentHeight < UIScreen.main.bounds.height {
                    Spacer(minLength: UIScreen.main.bounds.height - contentHeight)
                }

                footer()
                    .padding(.top, 16)
                    .padding(.bottom, bottomInset + 24) // ✅ Trustable safe area
            }
            .padding(.horizontal, 16)
        }
        .onPreferenceChange(ViewHeightPreferenceKey.self) { height in
            contentHeight = height
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
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
