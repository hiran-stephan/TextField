//
//  ListCellBottomSheet.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 09/09/24.
//

import Foundation
import SwiftUI

public class PersistedSheetController<Content>: UIHostingController<Content> where Content: View {
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let sheet = sheetPresentationController {
            if #available(iOS 16.0, *) {
                // optional custom size
                let fraction = UISheetPresentationController.Detent.custom { context in
                    50.0
                }
                sheet.detents = [fraction, .medium(), .large()]
                sheet.largestUndimmedDetentIdentifier = fraction.identifier
                isModalInPresentation = true
            } else {
                sheet.detents = [.medium(), .large()]
            }
            sheet.prefersGrabberVisible = false
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
