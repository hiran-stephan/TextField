Key Changes

Dynamic Agreement Titles

Removed hardcoded when(consentType) logic.

Added support for combined agreement titles (e.g., consents_13_14_agreement_title) when a section has multiple consent types.

Falls back to individual titles if a combined key isn’t defined in content.

Checkbox Rules (Configurable via Content)

Checkbox requirement now driven by content JSON instead of hardcoding.

New rules:

EDCA (13) → checkbox always required.

DBSA (14) → checkbox required only when it is the only consent on the page.

Fully controlled through content keys:

consents_checkbox_always_required_document_types

consents_checkbox_required_when_solo_document_types

Content-Driven Document Ordering

Removed EDCA hardcoding as “primary.”

Added support for comma-separated order from JSON (consents_documents_order).

Ensures consistent order across mobile and web without code changes.

Section Grouping

EDCA (13) always appears in its own section.

DBSA (14) + EDAD (19) are grouped into a single section.

Keeps related documents together and reduces redundant checkboxes.

Presenter Updates

ConsentSectionPresenter now receives:

sectionTypes → consent types within that section.

allTypesOnPage → all consent types for the page.

Enables correct agreement title resolution and checkbox logic per section/page.

Content & JSON Updates

Added entries for single and combined consent agreement titles (e.g., consents_13_14_agreement_title).

Added document name and title entries for accessibility.

Example:

consents_13_agreement_title

consents_14_agreement_title

consents_13_14_agreement_title
