/** --- Extension Functions --- **/

fun ConsentsData.updateReviewStatus(consentType: String): ConsentsData = copy(
    groupedConsents = groupedConsents.mapValues { (_, consents) ->
        consents.mapNotNull { it.updateReviewStatusIfMatch(consentType) }
    }
)

fun ConsentData.updateReviewStatusIfMatch(consentType: String): ConsentData =
    takeIf { it.consentType == consentType }?.copy(isReviewed = true) ?: this

fun ConsentsData.updateConsentsError(): ConsentsData = copy(
    groupedConsents = groupedConsents.mapValues { (consentType, consents) ->
        val errorMessage = when (consentType) {
            EDCA_TYPE -> TODO(reason = "Get it from error presenter")
            BDSA_TYPE -> TODO(reason = "Get it from error presenter")
            OTHER_TYPE -> TODO(reason = "Get it from error presenter")
            else -> null
        }
        consents.map { it.copy(error = errorMessage) }
    }
)
