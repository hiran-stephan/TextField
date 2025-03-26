@State private var isFocused: Bool = false

private var effectiveState: DropdownState {
        if state == .disabled {
            return .disabled
        } else if state == .error && isFocused {
            return .focusedError
        } else if state == .error {
            return .error
        } else if isFocused {
            return .focused
        } else {
            return .default
        }
    }


Menu {
               ForEach(items) { item in
                   Button(action: {
                       selectedItem = item
                       isFocused = false
                   }) {
                       if selectedItem == item {
                           Label(item.displayTitle, systemImage: "checkmark")
                       } else {
                           Text(item.displayTitle)
                       }
                   }
               }
           }

.simultaneousGesture(
                TapGesture().onEnded {
                    isFocused = true
                }
            )


.background(effectiveState.backgroundColor)
                .cornerRadius(BankingTheme.dimens.smallMedium)
                .overlay(
                    RoundedRectangle(cornerRadius: BankingTheme.dimens.smallMedium)
                        .inset(by: 0.5)
                        .stroke(effectiveState.borderColor, lineWidth: effectiveState.borderWidth)
                )
