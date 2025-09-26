How to Add a New Consent Type (e.g., Consent 21)
When adding a new consent, you must include the following keys in consents-content.json:
1. Agreement Title Key
    * Key: consents_<type>_agreement_title
    * Example: consents_21_agreement_title
    * Purpose: Agreement text shown below the documents.
2. Document Title Key
    * Key: consents_<type>_document_title
    * Example: consents_21_document_title
    * Purpose: PDF document title displayed in the UI.
3. Document Name Key
    * Key: consents_<type>_document_name
    * Example: consents_21_document_name
    * Purpose: Accessibility name and analytics tracking.
4. Error Code Key
    * Key: consents_document_error_code_<type>
    * Example: consents_document_error_code_21
    * Purpose: Configurable error code if consent is not reviewed.
5. Update Document Order (if required)
    * Key: consents_documents_order
    * Example: "13,14,19,21"
    * Purpose: Controls display order of documents.
