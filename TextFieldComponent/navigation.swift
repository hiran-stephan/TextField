struct CustomDropdown: View {
    let title: String
    let items: [String]
    @Binding var selectedItem: String
    var showError: Bool = false
    var errorMessage: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Text(title)
                    .font(.body)
                    .foregroundColor(.primary)

                Image(systemName: "info.circle")
                    .foregroundColor(.gray)
            }

            Menu {
                ForEach(items, id: \.self) { item in
                    Button(action: {
                        selectedItem = item
                    }) {
                        Text(item)
                    }
                }
            } label: {
                HStack {
                    Text(selectedItem.isEmpty ? "Please select an item" : selectedItem)
                        .foregroundColor(selectedItem.isEmpty ? .secondary : .primary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 16)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(showError ? Color.red : Color.gray, lineWidth: 1)
                )
            }

            if showError, let message = errorMessage {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                        .font(.caption)
                    Text(message)
                        .font(.caption)
                        .foregroundColor(.red)
                }
                .padding(.top, 2)
            }
        }
    }
}


@State private var accountType: String = ""

var body: some View {
    CustomDropdown(
        title: "Label",
        items: ["Deposit", "Loan", "Card"],
        selectedItem: $accountType,
        showError: accountType.isEmpty,
        errorMessage: "Error message (code#)"
    )
    .padding()
}
