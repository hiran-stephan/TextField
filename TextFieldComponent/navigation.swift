public struct EmptyState<ImageView: View, ContentView: View, Action: View>: View {
    private let imageView: (() -> ImageView)?
    private let contentView: (() -> ContentView)?
    private let action: (() -> Action)?

    public init(
        imageView: (() -> ImageView)? = nil,
        contentView: (() -> ContentView)? = nil,
        action: (() -> Action)? = nil
    ) {
        self.imageView = imageView
        self.contentView = contentView
        self.action = action
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: BankingTheme.dimens.extraLarge) {
                if let imageView = imageView {
                    imageView()
                }
                if let contentView = contentView {
                    contentView()
                }
                if let action = action {
                    action()
                }
            }
            .padding(.vertical, BankingTheme.dimens.medium)
        }
    }
}

EmptyState(
    imageView: {
        Image(systemName: "exclamationmark.circle")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .foregroundColor(.red)
    },
    contentView: {
        VStack(spacing: BankingTheme.dimens.medium) {
            Text("Error Occurred")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            Text("Something went wrong. Please try again later.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
            Text("If the problem persists, contact support.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
        }
    },
    action: {
        Button(action: {
            print("Retry tapped")
        }) {
            Text("Retry")
                .fontWeight(.semibold)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .padding(.horizontal)
    }
)
