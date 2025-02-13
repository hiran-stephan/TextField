struct ConsentCaptureListCell: View {
    let title: String
    let pdfLinks: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)

            ForEach(pdfLinks, id: \.self) { link in
                HStack {
                    Image(systemName: "doc.text") // PDF Icon
                    Text(link)
                        .foregroundColor(.blue)
                    Spacer()
                    BadgeIndicator(text: "Pending review", type: .passive)
                }
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
            }

        }
        .padding()
    }
}

struct ConsentMethod: View {
    @State private var isChecked = false

    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                .resizable()
                .frame(width: 24, height: 24)
                .onTapGesture {
                    isChecked.toggle()
                }

            Text("I/We read and agree to the Lorem Ipsum Agreement.")
                .font(.body)
                .foregroundColor(.primary)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary, lineWidth: 1))
    }
}

struct ConsentCaptureScreen: View {
    var body: some View {
        VStack(spacing: 16) {
            ConsentCaptureListCell(title: "Lorem Ipsum", pdfLinks: ["PDF Link Goes Here", "PDF Link Goes Here"])
            ConsentMethod()
        }
        .padding()
    }
}
