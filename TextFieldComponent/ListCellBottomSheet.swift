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
                adjustSheet {
                    sheet.view(coordinator: coordinator)
                }
            })
            .applyPresentationStyleIfNeeded()
    }
    
    func adjustSheet(content: () -> any View) -> AnyView {
        if #available(iOS 16.4, *) {
            return AnyView(
                content()
                    .presentationDetents([.fraction(0.1), .medium, .large])
                    .presentationCompactAdaptation(.sheet)
            )
        } else if #available(iOS 16.0, *) {
            return AnyView(
                content()
                    .presentationDetents([.fraction(0.1), .medium, .large])
            )
        } else {
            return AnyView(content())
        }
    }
}

public extension View {
    func sheetCoordinating<Sheet: SheetEnum>(coordinator: SheetCoordinator<Sheet>) -> some View {
        modifier(SheetCoordinating(coordinator: coordinator))
    }
}



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


extension View {
    @ViewBuilder
    func applyPresentationStyleIfNeeded() -> some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.presentationDetents([.medium])
        } else {
            self
        }
    }
}
