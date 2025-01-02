import kotlinx.serialization.Serializable
import kotlinx.serialization.SerialName

@Serializable
data class AccountPreferencesRequest(
    @SerialName("accounts")
    val accounts: List<AccountPreferences>,

    @SerialName("consent")
    val consent: Consent
)

@Serializable
data class AccountPreferences(
    @SerialName("id")
    val id: String,

    @SerialName("preferences")
    val preferences: Preferences
)

@Serializable
data class Preferences(
    @SerialName("estatement")
    val estatement: Boolean,

    @SerialName("nickname")
    val nickname: String,

    @SerialName("visibility")
    val visibility: Boolean
)

@Serializable
data class Consent(
    @SerialName("type")
    val type: String,

    @SerialName("version")
    val version: String,

    @SerialName("acceptTimestamp")
    val acceptTimestamp: String
)
