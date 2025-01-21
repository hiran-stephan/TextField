struct EmptyState: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Your Content Here")
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color.yellow)
        }
    }
}
