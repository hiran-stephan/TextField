import SwiftUI

struct ReviewAgreementsView: View {
    struct ReviewAgreementsData: Hashable {
        let title: String
        let description: String
        let agreementSections: [AgreementSectionData]
    }

    struct AgreementSectionData: Hashable {
        let title: String
        let pdfLinks: [String]
        let icon: String
        let badgeText: String
        let consentText: String
        let consentType: ConsentView.ConsentType
    }

    @State private var data = ReviewAgreementsData(
        title: "Review agreements",
        description: "Some of our agreements have been updated. To continue with your online banking, review and agree to the document provided.",
        agreementSections: [
            AgreementSectionData(
                title: "1. Review and accept the following agreement:",
                pdfLinks: ["Electronic Disclosure Consent Agreement (PDF, 15 KB)"],
                icon: BankingTheme.icons.functional.pdf.rawValue,
                badgeText: "Pending review",
                consentText: "I/we read and agree to the Electronic Disclosure Consent Agreement.",
                consentType: .normal
            ),
            AgreementSectionData(
                title: "2. Review and accept the following agreement:",
                pdfLinks: ["CIBC Digital Banking Service Agreement (PDF, 15 KB)"],
                icon: BankingTheme.icons.functional.pdf.rawValue,
                badgeText: "Pending review",
                consentText: "By clicking ‘Continue’, I confirm I have received, reviewed, and agreed to the CIBC Digital Banking Service Agreement.",
                consentType: .confirmed
            )
        ]
    )
