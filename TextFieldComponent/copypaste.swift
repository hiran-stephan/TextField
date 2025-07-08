import SwiftUI

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

            ScrollView {
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        content

                        // Dynamically push footer if content is short
                        if contentHeight < screenHeight {
                            Spacer(minLength: screenHeight - contentHeight)
                        }

                        footer()
                            .padding(.top, 16)
                            .padding(.bottom, 24)
                    }
                    .background(
                        GeometryReader { proxy in
                            Color.clear
                                .preference(key: ViewHeightPreferenceKey.self,
                                            value: proxy.size.height)
                        }
                    )
                    .padding(.horizontal, 16)
                }
            }
            .onPreferenceChange(ViewHeightPreferenceKey.self) { height in
                contentHeight = height
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}

extension View {
    func stickyFooter<Footer: View>(@ViewBuilder footer: @escaping () -> Footer) -> some View {
        self.modifier(StickyFooterModifier(footer: footer))
    }
}


struct ManageAlertsAlertSettingsScreen: View {
    var body: some View {
        LoadingErrorLayout(
            isLoading: isLoading,
            hasData: hasData,
            hasFullError: hasFullError,
            hasInlineError: hasInlineError,
            inlineError: { errorInlineView() },
            fullError: { errorFullView() },
            content: {
                VStack(spacing: 24) {
                    contentView()
                }
            }
        }
        .stickyFooter {
            buildButtonView()
        }
    }
}
