/**
 * Constants for the Authentication Api module
 */
object ApiConstants {
    const val API_UBS_VERIFY_PASSWORD = "/ubs-auth/api/v1/verify-password"
    const val API_UBS_RESET_PASSWORD = "/ubs-auth/api/v1/user/credentials/password"
    const val API_UBS_AUTH_SESSIONS = "/ubs-auth/api/v1/authenticate/sessions"
    const val API_UBS_SESSION_SESSIONS = "/ubs-session/api/v1/sessions"
    const val API_UBS_AUTH_SESSIONS_LOGIN_INFO = "/ubs-auth/api/v1/sessions/login-info"
    const val API_SEARCH_FRIENDLY_ID = "/ubs-auth/api/v1/friendlyId-retrieval-session"
    const val API_AUTHENTICATE_USER_INFO = "/ubs-auth/api/v1/authenticate/user-info"
    const val API_CREDENTIAL_FRIENDLY_ID = "/ubs-auth/api/v1/user/credentials/friendlyId"
}
