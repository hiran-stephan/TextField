struct ReviewAgreementsScreen: View {
    @State private var agreements: [AgreementData] = [
        AgreementData(
            title: "Review and accept the following agreement:",
            pdfLinks: ["Electronic Disclosure Consent Agreement (PDF, 15 KB)"],
            agreementText: "I/we read and agree to the Electronic Disclosure Consent Agreement."
        ),
        AgreementData(
            title: "Review and accept the following agreement:",
            pdfLinks: ["CIBC Digital Banking Service Agreement (PDF, 15 KB)"],
            agreementText: "I/we read and agree to the CIBC Digital Banking Service Agreement."
        )
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header Section
            VStack(alignment: .leading, spacing: 8) {
                Text("Review agreements")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Some of our agreements have been updated. To continue with your online banking, review and agree to the document provided.")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)

            // List of Agreements
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(agreements, id: \.self) { agreement in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(agreement.title)
                                .font(.headline)
                            
                            ConsentCaptureListCell(title: agreement.title, pdfLinks: agreement.pdfLinks)
                            
                            ConsentMethod(agreementText: agreement.agreementText)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    }
                }
                .padding(.horizontal)
            }

            // Confirmation Text
            Text("By clicking ‘Continue’, I confirm I have received, reviewed, and agreed to the CIBC Digital Banking Service Agreement.")
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.horizontal)
                .padding(.bottom, 8)
            
            // Action Buttons
            VStack(spacing: 8) {
                Button(action: {
                    // Submit action
                }) {
                    Text("Submit")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    // Cancel action
                }) {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.black)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
    }
}

// Agreement Data Model
struct AgreementData: Hashable {
    let title: String
    let pdfLinks: [String]
    let agreementText: String
}
