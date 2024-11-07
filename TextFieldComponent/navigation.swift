


import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class AccountDisplayNames(
    @SerialName("display_names")
    val displayNames: Map<String, LocalizedText>
)


override fun formatAccountDisplayName(
    nickName: String?,
    productName: String?,
    productLookupKey: String?
): String {
    val localizedContent = ContentFile(products)
    
    return when {
        !nickName.isNullOrBlank() -> nickName
        !productLookupKey.isNullOrBlank() -> {
            localizedContent.localized(key = productLookupKey, lang = locale.lang) ?: productName ?: ""
        }
        else -> productName ?: ""
    }
}
