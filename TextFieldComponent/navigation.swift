import kotlinx.serialization.Serializable
import kotlinx.serialization.SerialName

@Serializable
data class AccountPreferencesResponse(
    @SerialName("status")
    val status: String, // Example: SUCCESS or PARTIAL_SUCCESS

    @SerialName("problems")
    val problems: List<BankErrorApiData>? = null
)
