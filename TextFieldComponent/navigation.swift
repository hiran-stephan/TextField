


import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class AccountDisplayNames(
    @SerialName("display_names")
    val displayNames: Map<String, LocalizedText>
)
