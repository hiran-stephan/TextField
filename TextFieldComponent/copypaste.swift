struct ViewHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

struct StickyFooterModifier<Footer: View>: ViewModifier {
    let footer: () -> Footer

    @State private var contentHeight: CGFloat = 0
    @State private var footerHeight: CGFloat = 0 // ✅ Add this

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            let screenHeight = geometry.size.height

            ScrollView {
                VStack(spacing: 0) {
                    content

                    // ✅ Footer height measurement
                    VStack(spacing: 0) {
                        footer()
                            .background(
                                GeometryReader { proxy in
                                    Color.clear
                                        .onAppear {
                                            footerHeight = proxy.size.height
                                        }
                                        .onChange(of: proxy.size.height) { newHeight in
                                            footerHeight = newHeight
                                        }
                                }
                            )
                    }

                    // ✅ Adjusted spacer to consider footer height
                    if contentHeight + footerHeight < screenHeight {
                        Spacer(minLength: screenHeight - contentHeight - footerHeight)
                    }
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
