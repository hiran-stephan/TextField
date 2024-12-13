import SwiftUI

struct ContentView: View {

    @StateObject var viewModel = ContentViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(viewModel.rows, id: \.self) { row in
                HStack(spacing: 6) {
                    ForEach(row) { tag in
                        HStack(spacing: 8) {
                            if let iconName = tag.icon {
                                Image(systemName: iconName) // Use SF Symbols as the icon
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 16, height: 16)
                                    .foregroundColor(.blue)
                            }
                            Text(tag.name)
                                .font(.system(size: 16))
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Capsule().fill(Color.gray.opacity(0.3)))
                    }
                }
                .frame(height: 28)
                .padding(.bottom, 10)
            }
        }
        .padding(24)
    }
}

struct Tag: Identifiable, Hashable {
    var id = UUID().uuidString
    var name: String
    var icon: String? // Optional icon (SF Symbol name)
    var size: CGFloat = 0
}

class ContentViewModel: ObservableObject {

    @Published var rows: [[Tag]] = []
    @Published var tags: [Tag] = [
        Tag(name: "XCode", icon: "hammer.fill"),
        Tag(name: "iOS", icon: "iphone"),
        Tag(name: "iOS App Development", icon: "app"),
        Tag(name: "Swift", icon: "swift"),
        Tag(name: "SwiftUI", icon: nil),
        Tag(name: "Custom Layouts", icon: "rectangle.grid.1x2.fill")
    ]

    init() {
        calculateRows()
    }

    func calculateRows() {
        var rows: [[Tag]] = []
        var currentRow: [Tag] = []
        var totalWidth: CGFloat = 0

        let screenWidth = UIScreen.screenWidth - 10
        let tagSpacing: CGFloat = 56

        if !tags.isEmpty {
            for index in 0..<tags.count {
                self.tags[index].size = tags[index].name.getSize(withIcon: tags[index].icon != nil)
            }

            tags.forEach { tag in
                totalWidth += (tag.size + tagSpacing)

                if totalWidth > screenWidth {
                    totalWidth = (tag.size + tagSpacing)
                    rows.append(currentRow)
                    currentRow.removeAll()
                    currentRow.append(tag)
                } else {
                    currentRow.append(tag)
                }
            }

            if !currentRow.isEmpty {
                rows.append(currentRow)
                currentRow.removeAll()
            }

            self.rows = rows
        } else {
            self.rows = []
        }
    }
}

extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.width
}

extension String {
    func getSize(withIcon hasIcon: Bool = false) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 16)
        let attributes = [NSAttributedString.Key.font: font]
        let size = (self as NSString).size(withAttributes: attributes)
        return size.width + (hasIcon ? 24 : 0) // Add space for the icon if present
    }
}

