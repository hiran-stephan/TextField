final class AccountNicknameFormViewModel: ObservableObject {
    @Published private(set) var viewData: AccountNicknameFormViewData

    var onPrimaryButtonTap: () -> Void
    var onSecondaryButtonTap: () -> Void

    init(
        viewData: AccountNicknameFormViewData,
        onPrimaryButtonTap: @escaping () -> Void,
        onSecondaryButtonTap: @escaping () -> Void
    ) {
        self.viewData = viewData
        self.onPrimaryButtonTap = onPrimaryButtonTap
        self.onSecondaryButtonTap = onSecondaryButtonTap
    }

    func updateNickname(_ nickname: String) {
        viewData.nickname = nickname
        validateNickname()
    }

    func validateNickname() {
        if viewData.nickname.isEmpty {
            viewData.isValidationError = true
            viewData.validationMessage = "Nickname cannot be empty"
        } else {
            viewData.isValidationError = false
            viewData.validationMessage = ""
        }
    }

    func clearNickname() {
        viewData.nickname = ""
        viewData.isValidationError = false
        viewData.validationMessage = ""
    }

    func saveNickname() {
        validateNickname()
        if !viewData.isValidationError {
            onPrimaryButtonTap()
        }
    }
}


struct AccountNicknameFormViewData {
    var nickname: String
    var isValidationError: Bool
    var validationMessage: String
    var primaryButtonText: String
    var secondaryButtonText: String
}


struct AccountNicknameFormView: View {
    @ObservedObject var viewModel: AccountNicknameFormViewModel

    var body: some View {
        let data = viewModel.viewData

        VStack(spacing: 16) {
            // TextField for Nickname
            TextField("Nickname", text: Binding(
                get: { data.nickname },
                set: { viewModel.updateNickname($0) }
            ))
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)

            // Inline Validation Message
            if data.isValidationError {
                Text(data.validationMessage)
                    .font(.caption)
                    .foregroundColor(.red)
            }

            // Primary and Secondary Buttons
            HStack {
                Button(data.primaryButtonText, action: viewModel.saveNickname)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)

                Button(data.secondaryButtonText, action: viewModel.clearNickname)
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}


struct ContentView: View {
    var body: some View {
        AccountNicknameFormView(
            viewModel: AccountNicknameFormViewModel(
                viewData: AccountNicknameFormViewData(
                    nickname: "",
                    isValidationError: false,
                    validationMessage: "",
                    primaryButtonText: "Save",
                    secondaryButtonText: "Cancel"
                ),
                onPrimaryButtonTap: {
                    print("Nickname saved")
                },
                onSecondaryButtonTap: {
                    print("Nickname cleared")
                }
            )
        )
    }
}

