val consentDocumentBadgeText: String = if (consentData?.isReviewed == true)
    reviewedStatusPillText 
else
    pendingReviewStatusPillText
