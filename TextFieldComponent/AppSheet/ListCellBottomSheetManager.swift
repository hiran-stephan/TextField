//
//  ListCellBottomSheetManager.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 12/09/24.
//

import Foundation
import SwiftUI

public protocol BottomSheetEnum: Identifiable {
    associatedtype Body: View
    @ViewBuilder func view(coordinator: BottomSheetCoordinator<Self>) -> Body
}

public final class BottomSheetCoordinator<Sheet: BottomSheetEnum>: ObservableObject {
    @Published var currentSheet: Sheet?
    private var sheetStack: [Sheet] = []

    public init() {}

    @MainActor
    public func presentSheet(sheet: Sheet) {
        sheetStack.append(sheet)
        currentSheet = sheet
    }

    @MainActor
    func sheetDismissed() {
        if !sheetStack.isEmpty {
            sheetStack.removeFirst()
        }

        if let nextSheet = sheetStack.first {
            currentSheet = nextSheet
        } else {
            currentSheet = nil
        }
    }
}

public struct BottomSheetManaging<Sheet: BottomSheetEnum>: ViewModifier {
    @StateObject var coordinator: BottomSheetCoordinator<Sheet>

    public func body(content: Content) -> some View {
        content
            .sheet(item: $coordinator.currentSheet, onDismiss: {
                coordinator.sheetDismissed()
            }, content: { sheet in
                if UIDevice.current.userInterfaceIdiom == .pad {
                    BottomSheetView {
                        sheet.view(coordinator: coordinator)
                    }
                } else {
                    adjustBottomSheet {
                        sheet.view(coordinator: coordinator)
                    }
                }
            })
    }

    @ViewBuilder
    func adjustBottomSheet<Content: View>(content: () -> Content) -> some View {
        if #available(iOS 16.0, *) {
            content().presentationDetents([.medium, .large])
        } else {
            content()
        }
    }
}

public extension View {
    func bottomSheetManaging<Sheet: BottomSheetEnum>(coordinator: BottomSheetCoordinator<Sheet>) -> some View {
        modifier(BottomSheetManaging(coordinator: coordinator))
    }
}

public struct BottomSheetButton<Sheet: BottomSheetEnum>: View {
    let coordinator: BottomSheetCoordinator<Sheet>
    let nextSheet: Sheet
    let title: String

    public var body: some View {
        Button(action: {
            Task {
                await MainActor.run {
                    coordinator.currentSheet = nil
                }

                try? await Task.sleep(nanoseconds: 300_000_000)

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

class BottomSheetHostingController<Content: View>: UIHostingController<Content> {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let presentation = sheetPresentationController {
            presentation.detents = [.medium(), .large()]
            presentation.prefersGrabberVisible = true
        }
    }
}

struct BottomSheetView<Content: View>: UIViewControllerRepresentable {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    func makeUIViewController(context: Context) -> BottomSheetHostingController<Content> {
        BottomSheetHostingController(rootView: content)
    }

    func updateUIViewController(_ uiViewController: BottomSheetHostingController<Content>, context: Context) {
        // No updates required for now
    }
}
