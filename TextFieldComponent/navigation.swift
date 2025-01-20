public struct StyledImageView<Style: ImageViewStyle>: View {
    private let image: Image
    private let style: Style

    public init(
        image: Image,
        style: Style = CircularImageViewStyle() as! Style // Default to CircularImageViewStyle
    ) {
        self.image = image
        self.style = style
    }

    public var body: some View {
        style.body(content: image)
    }
}


public protocol ImageViewStyle {
    associatedtype Body: View
    func body(content: Image) -> Body
}

public struct CircularImageViewStyle: ImageViewStyle {
    let backgroundColor: Color
    let size: CGFloat
    let padding: CGFloat

    public init(
        backgroundColor: Color = Color.gray.opacity(0.2),
        size: CGFloat = 100,
        padding: CGFloat = 16
    ) {
        self.backgroundColor = backgroundColor
        self.size = size
        self.padding = padding
    }

    public func body(content: Image) -> some View {
        ZStack {
            Circle()
                .fill(backgroundColor)
                .frame(width: size + padding, height: size + padding)
            content
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
        }
    }
}

public struct BackgroundlessImageViewStyle: ImageViewStyle {
    public init() {}

    public func body(content: Image) -> some View {
        content
            .resizable()
            .scaledToFit()
    }
}
