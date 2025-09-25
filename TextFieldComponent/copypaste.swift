ForEach(Array(sortedGroupedConsents.enumerated()), id: \.element.0) { index, pair in
    let (key, values) = pair
    let presenter = viewModel.createConsentSectionPresenter(
        documentList: values,
        consentCount: Int32(values.count),
        sectionIndex: Int32(index)          // ✅ new
    )
    let section = presenter.toSectionData()
    ConsentCaptureSectionView(
        data: section,
        onChangeConsent: { viewModel.onConsentCheckboxChanged() },
        onChangeDocumentReviewStatus: { type in
            viewModel.onConsentDocumentReviewed(consentType: type)
        }
    )
}

fun ConsentsViewModel.createConsentSectionPresenter(
    documentList: List<ConsentData>,
    consentCount: Int,
    sectionIndex: Int            // ✅ new
): ConsentSectionPresenter =
    ConsentSectionPresenter(
        isCheckboxChecked = consentActionState.value.isCheckboxChecked,
        isConsentValidationFailed = consentActionState.value.isConsentValidationFailed,
        consentData = documentList,
        contentFile = consentResourceState.value.contentFile,
        locale = locale,
        messageCatalogue = messageCatalogue,
        consentCount = consentCount,
        sectionIndex = sectionIndex        // ✅ new
    )

class ConsentSectionPresenter(
    private val contentFile: ContentFile?,
    private val locale: Locale,
    private val messageCatalogue: MessageCatalogue,
    private val consentData: List<ConsentData> = emptyList(),
    private val isCheckboxChecked: Boolean = false,
    private val isConsentValidationFailed: Boolean = false,
    private val consentCount: Int,
    private val sectionIndex: Int          // ✅ new
) {
    
    private val stepNumber: Int by lazy { sectionIndex + 1 }   // ✅ 1, 2, 3...

    val stepIndicatorText: String by lazy {
        when (stepNumber) {
            1 -> displayContent(ContentConstants.CONSENTS_STEP_1_NUMBER)
            2 -> displayContent(ContentConstants.CONSENTS_STEP_2_NUMBER)
            else -> stepNumber.toString()
        }
    }

    val stepIndicatorAccessibilityText: String by lazy {
        when (stepNumber) {
            1 -> displayContent(ContentConstants.CONSENTS_STEP_1_NUMBER, forAccessibility = true)
            2 -> displayContent(ContentConstants.CONSENTS_STEP_2_NUMBER, forAccessibility = true)
            else -> stepNumber.toString()
        }
    }

    val title: String by lazy {
        if (stepNumber == 1)
            displayContent(ContentConstants.CONSENTS_STEP_1_TITLE)
        else
            displayContent(ContentConstants.CONSENTS_STEP_2_TITLE)
    }

