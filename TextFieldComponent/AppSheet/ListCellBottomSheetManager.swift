//
//  ListCellBottomSheetManager.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 12/09/24.
//

import Foundation
import SwiftUI

enum BottomSheetConstants {
    
    enum Detents {
        static let threeQuarter: CGFloat = 0.75
        static let half: CGFloat = 0.5
    }
}

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
@MainActor
public final class BottomSheetCoordinator<Sheet: BottomSheetEnum>: ObservableObject {
    /// The currently presented sheet.
    @Published var currentSheet: Sheet?
    
    /// A stack to hold the presented sheets for navigation.
    private var sheetStack: [Sheet] = []
    
    /// Initializes the `BottomSheetCoordinator`.
    public init() {}
    
    /// Presents a new sheet by adding it to the stack and making it the current sheet.
    /// - Parameter sheet: The sheet to be presented.
    public func presentSheet(sheet: Sheet) {
        sheetStack.append(sheet)
        currentSheet = sheet
    }
    
    /// Handles the dismissal of the current sheet. If there are more sheets in the stack, the next one is presented.
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
                    .fraction(BottomSheetConstants.Detents.threeQuarter),
                    .large
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
/// The button accepts an async block that can handle custom logic when the button is pressed.
public struct BottomSheetButton<Sheet: BottomSheetEnum>: View {
    /// The title of the button.
    let title: String
    
    /// The async action to be executed when the button is pressed.
    let action: () async -> Void
    
    /// The body of the button, defining its appearance and action.
    public var body: some View {
        Button(action: {
            Task {
                await action() // Execute the async action when the button is pressed
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

public extension BottomSheetCoordinator {
    /// Handles transitioning from the current sheet to a new sheet with an optional delay.
    /// - Parameters:
    ///   - nextSheet: The sheet to present after the current sheet is dismissed.
    ///   - delay: An optional delay before presenting the next sheet (default is 300ms).
    @MainActor
    func transitionToSheet(_ nextSheet: Sheet, withDelay delay: UInt64 = 300_000_000) async {
        // Dismiss the current sheet
        currentSheet = nil
        
        // Wait for the specified delay
        try? await Task.sleep(nanoseconds: delay)
        
        // Present the next sheet
        presentSheet(sheet: nextSheet)
    }
}

// MARK: - BottomSheetHostingController (UIKit)

/// A custom `UIHostingController` to configure bottom sheet presentation with custom detents and a grabber.
class BottomSheetHostingController<Content: View>: UIHostingController<Content> {
    
    /// Configures the sheet’s detents and grabber visibility before the view appears.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let presentation = sheetPresentationController {
            if #available(iOS 16.0, *) {
                let threeQuarterDetent = UISheetPresentationController.Detent.custom { context in
                    context.maximumDetentValue * BottomSheetConstants.Detents.threeQuarter
                }
                presentation.detents = [threeQuarterDetent, .large()]
            } else {
                presentation.detents = [.medium(), .large()]
            }
            presentation.prefersGrabberVisible = true
        }
    }
}

// MARK: - BottomSheetView (UIKit)

/// A SwiftUI wrapper for a `UIHostingController` that presents SwiftUI content as a bottom sheet.
struct BottomSheetView<Content: View>: UIViewControllerRepresentable {
    
    let content: Content

    /// Initializes with the SwiftUI content to be displayed.
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    /// Creates the `BottomSheetHostingController` with the SwiftUI content.
    func makeUIViewController(context: Context) -> BottomSheetHostingController<Content> {
        BottomSheetHostingController(rootView: content)
    }

    /// Updates the hosting controller (no updates needed here).
    func updateUIViewController(_ uiViewController: BottomSheetHostingController<Content>, context: Context) {}
}

