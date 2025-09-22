import SwiftUI
import Combine
import Umbrella

@MainActor
final class AlertManager: ObservableObject {

    struct AlertItem: Identifiable {
        let id = UUID()
        let tag: String?                     // ← NEW (optional; defaults to nil)
        let errors: [ProblemData]?
        let title: String
        let message: String
        let primaryAction: ActionButton
        let secondaryAction: ActionButton?
    }

    struct ActionButton {
        let title: String
        let action: (() -> Void)?
    }

    @Published var alertQueue: [AlertItem] = []
    @Published var currentAlert: AlertItem?

    // Single-action alert (backward compatible)
    func addAlert(errors: [ProblemData]? = nil,
                  title: String,
                  message: String,
                  actionTitle: String,
                  dismissAction: (() -> Void)? = nil,
                  tag: String? = nil) {               // ← NEW param with default

        let alert = AlertItem(
            tag: tag,                                // ← set tag
            errors: errors,
            title: title,
            message: message,
            primaryAction: .init(title: actionTitle, action: dismissAction),
            secondaryAction: nil
        )

        // keep existing clear-queue logic
        if let _ = errors?.first(where: { $0.code == ErrorCode.signOut }) {
            currentAlert = nil
            alertQueue.removeAll()
        }

        alertQueue.append(alert)
        showNextAlert()
    }

    // Two-action alert (backward compatible)
    func addAlert(errors: [ProblemData]? = nil,
                  title: String,
                  message: String,
                  cancelTitle: String,
                  cancelAction: (() -> Void)? = nil,
                  continueTitle: String,
                  continueAction: (() -> Void)? = nil,
                  tag: String? = nil) {               // ← NEW param with default

        let alert = AlertItem(
            tag: tag,                                // ← set tag
            errors: errors,
            title: title,
            message: message,
            primaryAction: .init(title: cancelTitle, action: cancelAction),
            secondaryAction: .init(title: continueTitle, action: continueAction)
        )

        // keep existing clear-queue logic
        if let _ = errors?.first(where: { $0.code == ErrorCode.signOut }) {
            currentAlert = nil
            alertQueue.removeAll()
        }

        alertQueue.append(alert)
        showNextAlert()
    }

    // NEW: dismiss by tag (safe no-op if not found)
    func dismiss(tag: String) {
        if currentAlert?.tag == tag {
            currentAlert = nil
        }
        alertQueue.removeAll { $0.tag == tag }
        showNextAlert()
    }

    private func showNextAlert() {
        if currentAlert == nil, !alertQueue.isEmpty {
            currentAlert = alertQueue.removeFirst()
        } else {
            currentAlert = nil
        }
    }

    func dismissAlert() {
        showNextAlert()
    }
}

extension AlertManager {
    private enum ErrorCode {
        static let signOut = "0003"
    }
}



private let sessionTimeoutTag = "session-timeout"

func prepareSessionExtensionDialog() {
    let sessionViewModel: SessionViewModel = KoinApplication.inject()

    // trigger the Analytics call for it
    sessionViewModel.onSessionExtensionDialogPopUp()

    let presenter = sessionViewModel.createSessionTimeoutPresenter()

    DispatchQueue.main.async {
        self.alertManager?.addAlert(
            title: presenter.sessionTimeoutDialogTitle,
            message: presenter.sessionTimeoutDialogText,
            actionTitle: presenter.sessionTimeoutDialogDismiss,
            dismissAction: {
                sessionViewModel.renewSession()
                self.updateSessionExtensionDialog(showDialog: false)
            },
            tag: sessionTimeoutTag                 // ← NEW
        )
    }
}


private let sessionTimeoutTag = "session-timeout"

func updateSessionExtensionDialog(showDialog: Bool) {
    DispatchQueue.main.async {
        self.showSessionExtensionDialog = showDialog
        if self.showSessionExtensionDialog {
            self.prepareSessionExtensionDialog()
        } else {
            self.alertManager?.dismiss(tag: sessionTimeoutTag)   // ← NEW
        }
    }
}


