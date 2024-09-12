//
//  ListCellBottomSheet.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 09/09/24.
//

import Foundation
import SwiftUI

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
        if sheetStack.count == 1 {
            sheetStack.removeFirst()
        }

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
                if UIDevice.current.userInterfaceIdiom == .pad {
                    HalfSheet {
                        sheet.view(coordinator: coordinator)
                    }
                } else {
                    adjustSheet {
                        sheet.view(coordinator: coordinator)
                    }
                }
            })
    }
    
    // Function to adjust sheet presentation for iPhone
    @ViewBuilder
    func adjustSheet<Content: View>(content: () -> Content) -> some View {
        if #available(iOS 16.0, *) {
            content()
                .presentationDetents([.fraction(0.1), .medium, .large])
        } else {
            content()
        }
    }
}


// HalfSheetController to customize the sheet presentation for iPad
class HalfSheetController<Content: View>: UIHostingController<Content> {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let presentation = sheetPresentationController {
            // Set the detents to medium and large for iPad
            presentation.detents = [.medium(), .large()]
            // Optional: Prevent drag-to-dismiss if required
            presentation.largestUndimmedDetentIdentifier = nil
        }
    }
}

// UIViewControllerRepresentable to wrap the HalfSheetController for iPad
struct HalfSheet<Content: View>: UIViewControllerRepresentable {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    func makeUIViewController(context: Context) -> HalfSheetController<Content> {
        HalfSheetController(rootView: content)
    }

    func updateUIViewController(_ uiViewController: HalfSheetController<Content>, context: Context) {
        // No updates required for now
    }
}

public extension View {
    func sheetCoordinating<Sheet: SheetEnum>(coordinator: SheetCoordinator<Sheet>) -> some View {
        modifier(SheetCoordinating(coordinator: coordinator))
    }
}



// Example AppSheet enum for managing sheets
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
                    coordinator.sheetDismissed()
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


