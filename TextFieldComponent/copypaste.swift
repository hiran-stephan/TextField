@State private var showInfoDialog = false

...

.onReceive(model.$state.map(\.shouldShowInfoDialog).removeDuplicates()) { shouldShow in
    showInfoDialog = shouldShow
}
.alert(isPresented: $showInfoDialog) {
    Alert(
        title: Text("Info"),
        message: Text("Your message here"),
        dismissButton: .default(Text("OK"), action: {
            model.onInfoCloseButtonClicked()
        })
    )
}
