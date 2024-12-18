import SwiftUI

struct HeaderContentView<Content: View>: View {
    let headerText: String
    let content: Content

    init(headerText: String, @ViewBuilder content: () -> Content) {
        self.headerText = headerText
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(headerText)
                .font(.headline)
                .padding(.vertical, 4)

            content
                .padding(.horizontal)
        }
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 2)
        .padding(.horizontal)
    }
}


struct ContentView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HeaderContentView(headerText: "Account Group 1") {
                    VStack(alignment: .leading) {
                        Text("Account 1: Savings")
                        Text("Account 2: Checking")
                    }
                }

                HeaderContentView(headerText: "Account Group 2") {
                    VStack(alignment: .leading) {
                        Text("Account 3: Business Account")
                        Text("Account 4: Investment Account")
                    }
                }

                HeaderContentView(headerText: "Empty Group") {
                    Text("No accounts available.")
                        .foregroundColor(.gray)
                }
            }
        }
    }
}
