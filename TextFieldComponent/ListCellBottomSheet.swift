//
//  ListCellBottomSheet.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 09/09/24.
//

import Foundation
import SwiftUI


//public class PersistedSheetController<Content>: UIHostingController<Content> where Content: View {
//
//    public override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        if let sheet = sheetPresentationController {
//            if #available(iOS 16.0, *) {
//                // Set the preferred content size
//                self.preferredContentSize = CGSize(width: view.bounds.width, height: 200)
//
//                // Configure detents
//                sheet.detents = [.medium()]
//                sheet.prefersGrabberVisible = true
//                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
//                isModalInPresentation = true
//            }
//        }
//    }
//}

//public class PersistedSheetController<Content>: UIHostingController<Content> where Content: View {
//
//    public override init(rootView: Content) {
//        super.init(rootView: rootView)
//
//        // Configure the sheet during initialization
//        if let sheet = sheetPresentationController {
//            if #available(iOS 16.0, *) {
//                // Check if it's running on an iPad
//                if UIDevice.current.userInterfaceIdiom == .pad {
//                    // Set the sheet for iPad to formSheet presentation style
//                    modalPresentationStyle = .formSheet
//                    preferredContentSize = CGSize(width: view.bounds.width, height: 300) // Set desired height
//                } else {
//                    // Custom detent for iPhone
//                    let customDetent = UISheetPresentationController.Detent.custom { context in
//                        return 300 // Set a specific height for the sheet
//                    }
//                    sheet.detents = [customDetent]
//                    sheet.largestUndimmedDetentIdentifier = customDetent.identifier
//                    sheet.prefersGrabberVisible = true
//                    sheet.prefersScrollingExpandsWhenScrolledToEdge = false
//                }
//            }
//        }
//    }
//
//    @objc required dynamic init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}




//public struct PersistedSheet<Content>: UIViewControllerRepresentable where Content: View {
//    private let content: Content
//
//    public init(@ViewBuilder content: () -> Content) {
//        self.content = content()
//    }
//
//    public func makeUIViewController(context: Context) -> PersistedSheetController<Content> {
//        return PersistedSheetController(rootView: content)
//    }
//
//    public func updateUIViewController(_ controller: PersistedSheetController<Content>, context: Context) {
//    }
//}

public protocol SheetEnum: Identifiable {
    associatedtype Body: View

    @ViewBuilder
    func view(coordinator: SheetCoordinator<Self>) -> Body
}

public final class SheetCoordinator<Sheet: SheetEnum>: ObservableObject {
    @Published var currentSheet: Sheet?

    public init() {}

    @MainActor
    public func presentSheet(sheet: Sheet) {
        currentSheet = sheet
    }

    @MainActor
    func sheetDismissed() {
        currentSheet = nil
    }
}

public struct SheetCoordinating<Sheet: SheetEnum>: ViewModifier {
    @StateObject var coordinator: SheetCoordinator<Sheet>
    
    public func body(content: Content) -> some View {
        content
            .sheet(item: $coordinator.currentSheet, onDismiss: {
                coordinator.sheetDismissed()
            }, content: { sheet in
                sheet.view(coordinator: coordinator)
            })
    }
}


public extension View {
    func sheetCoordinating<Sheet: SheetEnum>(coordinator: SheetCoordinator<Sheet>) -> some View {
        modifier(SheetCoordinating(coordinator: coordinator))
    }
}



// View Modifier extension to easily create buttons for switching between sheets
//extension View {
//    func sheetButton(coordinator: SheetCoordinator<AppSheet>, nextSheet: AppSheet, title: String) -> some View {
//        Button(action: {
//            Task {
//                await MainActor.run {
//                    coordinator.presentSheet(sheet: nextSheet)
//                }
//            }
//        }) {
//            Text(title)
//                .padding()
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(8)
//        }
//    }
//}

enum HelpSheet: String, Identifiable, SheetEnum {
    case help

    var id: String { rawValue }

    @ViewBuilder
    func view(coordinator: SheetCoordinator<Self>) -> some View {
        switch self {
        case .help:
            HelpSheetView(coordinator: coordinator)
        }
    }
}

struct HelpSheetView: View {
    @ObservedObject var coordinator: SheetCoordinator<HelpSheet>

    let listCellItemData = [
        ListCellItemData(textPrimary: "Locations"),
        ListCellItemData(textPrimary: "Help"),
        ListCellItemData(textPrimary: "About")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Need more help?")
                .font(.headline)
                .padding(.top)
                .padding(.horizontal)

            Divider()

            // Constrain the height of the list to fit the content
            VStack(spacing: 0) {
                ForEach(listCellItemData) { itemData in
                    ListCellItemView(listCellItemData: itemData)
                        .padding(.horizontal)
                }
            }
            .frame(maxHeight: 150) // Set a fixed maximum height for the content

            Spacer()
        }
        .background(Color.white)
        .cornerRadius(16)
        .padding(.top) // Adjust as necessary for aesthetic spacing
    }
}










public struct ListCellContainerView: View {
    let listCellItemData: [ListCellItemData]

    public init(listCellItemData: [ListCellItemData]) {
        self.listCellItemData = listCellItemData
    }

    public var body: some View {
        ForEach(listCellItemData) { itemData in
            ListCellItemView(listCellItemData: itemData)
        }
    }
}



public struct ListCellItemView: View {
    let listCellItemData: ListCellItemData

    public init(listCellItemData: ListCellItemData) {
        self.listCellItemData = listCellItemData
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                // TODO: button action
            } label: {
                HStack(spacing: 16) {
                    // Left icon
                    ListCellIconView(imageName: "location") // Adjust imageName dynamically as per the content

                    // Primary and secondary text
                    VStack(alignment: .leading, spacing: 4) {
                        Text(listCellItemData.textPrimary)
                            .font(.body)
                            .foregroundColor(.primary)

                        if let textSecondary = listCellItemData.textSecondary {
                            Text(textSecondary)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }

                    Spacer()

                    // Chevron icon on the right
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 12)
            }

            Divider() // Line separating the items
        }
        .padding(.horizontal) // Padding for horizontal space
        .frame(maxWidth: .infinity, alignment: .top) // Align the content to the top
    }
}


public struct ListCellIconView: View {
    let imageName: String

    public init(imageName: String) {
        self.imageName = imageName
    }

    public var body: some View {
        Image(systemName: imageName) // Replacing `ComponentImage` with SF Symbol or actual image name
            .resizable()
            .scaledToFit()
            .frame(width: 24, height: 24) // Size adjustment to match the UI in the image
            .foregroundColor(.red) // Adjust color as needed, or dynamically based on context
    }
}
//
//#Preview {
//    ListCellIconView(imageName: ComponentConstants.Images.chevron)
//}

struct ListCellButtonModifier: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .frame(minHeight: ListCellTheme.cellHeight)
            .background(configuration.isPressed ? BankingTheme.colors.pressed : BankingTheme.colors.surface)
    }
}

struct ListCellTheme {
    static let cellHeight = 72.0
}

public struct ListCellItemData: Identifiable {
    public let id = UUID()
    public let textPrimary: String
    public let textSecondary: String?
    public let showLeftIcon: String?
    public let rightIconName: String?
    public let leftIconName: String?
    public let rightIconAccessibilityText: String?
    public let leftIconAccessibilityText: String?

    public init(textPrimary: String,
                textSecondary: String? = nil,
                showLeftIcon: String? = nil,
                rightIconName: String? = nil,
                leftIconName: String? = nil,
                rightIconAccessibilityText: String? = nil,
                leftIconAccessibilityText: String? = nil) {
        self.textPrimary = textPrimary
        self.textSecondary = textSecondary
        self.showLeftIcon = showLeftIcon
        self.rightIconName = rightIconName
        self.leftIconName = leftIconName
        self.rightIconAccessibilityText = rightIconAccessibilityText
        self.leftIconAccessibilityText = leftIconAccessibilityText
    }
}
