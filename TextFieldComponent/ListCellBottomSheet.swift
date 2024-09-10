//
//  ListCellBottomSheet.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 09/09/24.
//

import Foundation
import SwiftUI


public class PersistedSheetController<Content>: UIHostingController<Content> where Content: View {
    
    // Initialize with modal presentation style based on device type
    public override init(rootView: Content) {
        super.init(rootView: rootView)
        
//        // Check device type and set the appropriate modal style
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            modalPresentationStyle = .formSheet // Full-screen for iPad
//        } else {
            modalPresentationStyle = .custom // Default for iPhone
//        }
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let sheet = sheetPresentationController {
            if #available(iOS 16.0, *) {
                let fraction = UISheetPresentationController.Detent.custom { context in
                    0.5 * context.maximumDetentValue // Custom detent at half the screen height
                }
                sheet.detents = [fraction, .medium()]
                sheet.largestUndimmedDetentIdentifier = fraction.identifier
                isModalInPresentation = true
            } else {
                sheet.detents = [.medium(), .large()]
            }
            sheet.prefersGrabberVisible = true // Show the grabber handle
        }
    }
}

public struct PersistedSheet<Content>: UIViewControllerRepresentable where Content: View {
    private let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public func makeUIViewController(context: Context) -> PersistedSheetController<Content> {
        return PersistedSheetController(rootView: content)
    }

    public func updateUIViewController(_ controller: PersistedSheetController<Content>, context: Context) {
    }
}

public protocol SheetEnum: Identifiable {
    associatedtype Body: View

    @ViewBuilder
    func view(coordinator: SheetCoordinator<Self>) -> Body
}

public final class SheetCoordinator<Sheet: SheetEnum>: ObservableObject {
    @Published var currentSheet: Sheet?
    private var sheetStack: [Sheet] = []

    public init() {}

    @MainActor
    public func presentSheet(sheet: Sheet) {
        sheetStack.append(sheet)

        if sheetStack.count == 1 {
            currentSheet = sheet
        }
    }

    @MainActor
    func sheetDismissed() {
        sheetStack.removeFirst()

        if let nextSheet = sheetStack.first {
            currentSheet = nextSheet
        }
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


// Example enum conforming to SheetEnum
enum AppSheet: String, Identifiable, SheetEnum {
    case sheetOne
    case sheetTwo

    var id: String { rawValue }

    @ViewBuilder
    func view(coordinator: SheetCoordinator<AppSheet>) -> some View {
        switch self {
        case .sheetOne:
            Text("This is Sheet One")
                .padding()
                .sheetButton(coordinator: coordinator, nextSheet: .sheetTwo, title: "Go to Sheet Two")
        case .sheetTwo:
            Text("This is Sheet Two")
                .padding()
                .sheetButton(coordinator: coordinator, nextSheet: .sheetOne, title: "Go back to Sheet One")
        }
    }
}

// View Modifier extension to easily create buttons for switching between sheets
extension View {
    func sheetButton(coordinator: SheetCoordinator<AppSheet>, nextSheet: AppSheet, title: String) -> some View {
        Button(action: {
            Task {
                await MainActor.run {
                    coordinator.presentSheet(sheet: nextSheet)
                }
            }
        }) {
            Text(title)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}

enum HelpSheet: SheetEnum {
    case help

    var id: String {
        switch self {
        case .help:
            return "help"
        }
    }

    @ViewBuilder
    func view(coordinator: SheetCoordinator<Self>) -> some View {
        switch self {
        case .help:
            HelpSheetView(coordinator: coordinator)
        }
    }
}

// The HelpSheetView which shows the actual help content
struct HelpSheetView: View {
    @ObservedObject var coordinator: SheetCoordinator<HelpSheet>

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Need more help?")) {
                    Button("Locations") {
                        // Handle location option
                    }
                    Button("Help") {
                        // Handle help option
                    }
                    Button("About") {
                        // Handle about option
                    }
                    Button("Mobile Privacy Policy") {
                        // Handle privacy policy option
                    }
                    Button("Mobile Online Security") {
                        // Handle online security option
                    }
                    Button("Mobile Terms") {
                        // Handle terms option
                    }
                }
            }
            .navigationTitle("Help")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
