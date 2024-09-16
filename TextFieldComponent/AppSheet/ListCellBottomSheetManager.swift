//
//  ListCellBottomSheetManager.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 12/09/24.
//

import Foundation
import SwiftUI

/// A protocol for representing an identifiable sheet in a bottom sheet presentation system.
/// Conforming types must define a view to be presented in the bottom sheet.
public protocol BottomSheetEnum: Identifiable {
    associatedtype Body: View
    
    /// A method that returns the view to be displayed when the sheet is presented.
    /// - Parameter coordinator: The `BottomSheetCoordinator` managing the sheet presentation.
    /// - Returns: A view representing the content of the bottom sheet.
    @ViewBuilder func view(coordinator: BottomSheetCoordinator<Self>) -> Body
}

/// A class responsible for coordinating the presentation of bottom sheets.
/// It manages a stack of sheets and ensures proper navigation between them.
public final class BottomSheetCoordinator<Sheet: BottomSheetEnum>: ObservableObject {
    /// The currently presented sheet.
    @Published var currentSheet: Sheet?
    
    /// A stack to hold the presented sheets for navigation.
    private var sheetStack: [Sheet] = []

    /// Initializes the `BottomSheetCoordinator`.
    public init() {}

    /// Presents a new sheet by adding it to the stack and making it the current sheet.
    /// - Parameter sheet: The sheet to be presented.
    @MainActor
    public func presentSheet(sheet: Sheet) {
        sheetStack.append(sheet)
        currentSheet = sheet
    }

    /// Handles the dismissal of the current sheet. If there are more sheets in the stack, the next one is presented.
    @MainActor
    func sheetDismissed() {
        if !sheetStack.isEmpty {
            sheetStack.removeFirst() // Remove the current sheet
        }

        if let nextSheet = sheetStack.first {
            currentSheet = nextSheet // Present the next sheet if available
        } else {
            currentSheet = nil // Clear the current sheet if the stack is empty
        }
    }
}

/// A view modifier that manages the presentation of a bottom sheet based on the current sheet
/// managed by the `BottomSheetCoordinator`.
public struct BottomSheetManaging<Sheet: BottomSheetEnum>: ViewModifier {
    /// The coordinator responsible for managing the bottom sheets.
    @StateObject var coordinator: BottomSheetCoordinator<Sheet>

    /// Defines the body content of the view modifier.
    /// It listens for changes in the coordinator and presents the appropriate sheet.
    public func body(content: Content) -> some View {
        content
            .sheet(item: $coordinator.currentSheet, onDismiss: {
                coordinator.sheetDismissed()
            }, content: { sheet in
                if UIDevice.current.userInterfaceIdiom == .pad {
                    // Use BottomSheetView for iPad
                    BottomSheetView {
                        sheet.view(coordinator: coordinator)
                    }
                } else {
                    // Adjust bottom sheet presentation for iPhone and smaller devices
                    adjustBottomSheet {
                        sheet.view(coordinator: coordinator)
                    }
                }
            })
    }
    
    /// Adjusts the presentation of the bottom sheet, using `.presentationDetents` for iOS 16 and above.
    /// - Parameter content: The content view to be presented in the bottom sheet.
    @ViewBuilder
    func adjustBottomSheet<Content: View>(content: () -> Content) -> some View {
        if #available(iOS 16.0, *) {
            content()
                .presentationDetents([
                    .fraction(0.75), // 3/4 of the screen height
                    .large // Full-screen detent
                ])
        } else {
            content() // Fallback for iOS versions below 16
        }
    }
}

/// A view extension that adds the `bottomSheetManaging` modifier to manage bottom sheets using a coordinator.
/// - Parameter coordinator: The coordinator managing the sheet presentation.
/// - Returns: A view that applies the bottom sheet management logic.
public extension View {
    func bottomSheetManaging<Sheet: BottomSheetEnum>(coordinator: BottomSheetCoordinator<Sheet>) -> some View {
        modifier(BottomSheetManaging(coordinator: coordinator))
    }
}

/// A button used to navigate between bottom sheets.
/// When pressed, it dismisses the current sheet and presents the next one after a brief delay.
public struct BottomSheetButton<Sheet: BottomSheetEnum>: View {
    /// The coordinator managing the sheet transitions.
    let coordinator: BottomSheetCoordinator<Sheet>
    
    /// The next sheet to be presented when the button is pressed.
    let nextSheet: Sheet
    
    /// The title of the button.
    let title: String

    /// The body of the button, defining its appearance and action.
    public var body: some View {
        Button(action: {
            Task {
                await MainActor.run {
                    coordinator.currentSheet = nil // Dismiss the current sheet
                }

                try? await Task.sleep(nanoseconds: 300_000_000) // Wait for 300ms

                await MainActor.run {
                    coordinator.presentSheet(sheet: nextSheet) // Present the next sheet
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

/// A custom `UIHostingController` that configures the bottom sheet's appearance.
/// It ensures that the bottom sheet has a custom 3/4 detent and a grabber handle.
class BottomSheetHostingController<Content: View>: UIHostingController<Content> {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let presentation = sheetPresentationController {
            let threeQuarterDetent = UISheetPresentationController.Detent.custom { context in
                return context.maximumDetentValue * 0.75 // 3/4 height of the available screen
            }
            presentation.detents = [threeQuarterDetent, .large()] // Available detents
            presentation.prefersGrabberVisible = true // Show grabber handle for dragging
        }
    }
}

/// A wrapper view that uses `UIViewControllerRepresentable` to present a `BottomSheetHostingController`
/// for displaying content as a bottom sheet.
struct BottomSheetView<Content: View>: UIViewControllerRepresentable {
    /// The content to be displayed in the bottom sheet.
    let content: Content

    /// Initializes the `BottomSheetView` with the content to be presented.
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    /// Creates the `BottomSheetHostingController` that hosts the content.
    /// - Parameter context: The context in which the view is presented.
    /// - Returns: A `BottomSheetHostingController` that hosts the provided content.
    func makeUIViewController(context: Context) -> BottomSheetHostingController<Content> {
        BottomSheetHostingController(rootView: content)
    }

    /// Updates the `BottomSheetHostingController` when the SwiftUI state changes.
    /// - Parameters:
    ///   - uiViewController: The hosting controller to update.
    ///   - context: The context in which the update occurs.
    func updateUIViewController(_ uiViewController: BottomSheetHostingController<Content>, context: Context) {
        // No updates required for now
    }
}

