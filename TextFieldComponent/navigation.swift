class LoginViewModel : ViewModel() {

    fun authenticateCredentials(
        username: String,
        password: String,
        encrypt: Boolean?,
        encrypted: Boolean?,
        rememberMe: Boolean = false
    ) = launch(_loginAction) {
        repository.authenticateCredentials(
            username = username,
            password = password,
            pageId = TmxPageIds.getLoginId(),
            profilingId = tmxProvider.getProfilingSessionId(),
            encrypt = encrypt,
            encrypted = encrypted
        ).collect(_loginAction) { result ->
            result.isLoading { /* Handle loading state */ }

            result.onSuccess { session ->
                handleAuthenticationSuccess(
                    userData = username,
                    session = session,
                    signOnType = AUTH_ANALYTICS_SIGN_ON_TYPE_UNSAVED,
                    rememberMe = rememberMe,
                    redirectToDeepLink = navigationItem.redirectTo
                )
            }

            result.onException { /* Handle errors */ }
        }
    }

    fun authenticateBiometricsCredentialsManual(manualPassword: String) = launch(_loginAction) {
        val savedUserIdData = _loginAction.value.savedUserIdData
        savedUserIdData?.let {
            repository.authenticateCredentials(
                username = it.encrypted.toString(),
                password = manualPassword,
                pageId = TmxPageIds.getLoginId(),
                profilingId = tmxProvider.getProfilingSessionId(),
                encrypt = false,
                encrypted = true
            ).collect(_loginAction) { credentialsResult ->
                credentialsResult.isLoading { /* Handle loading */ }

                credentialsResult.onSuccess { session ->
                    handleAuthenticationSuccess(
                        userData = savedUserIdData,
                        session = session,
                        signOnType = AUTH_ANALYTICS_SIGN_ON_TYPE_SAVED_PASSWORD,
                        rememberMe = false,
                        redirectToDeepLink = navigationItem.redirectTo
                    )
                }

                credentialsResult.onException { /* Handle exceptions */ }
            }
        }
    }

    private fun loginBiometrics(savedUserIdData: UserIdData?, manualPassword: String) = launch(_loginAction) {
        repository.authenticateCredentials(
            username = savedUserIdData?.encrypted.toString(),
            password = manualPassword,
            pageId = TmxPageIds.getLoginId(),
            profilingId = tmxProvider.getProfilingSessionId(),
            encrypt = false,
            encrypted = true
        ).collect(_loginAction) { credentialsResult ->
            credentialsResult.isLoading { /* Handle loading */ }

            credentialsResult.onSuccess { session ->
                handleAuthenticationSuccess(
                    userData = savedUserIdData,
                    session = session,
                    signOnType = signOnType,
                    rememberMe = rememberMe,
                    redirectToDeepLink = navigationItem.redirectTo
                )
            }

            credentialsResult.onException { /* Handle errors */ }
        }
    }

    private fun handleAuthenticationSuccess(
        userData: Any,
        session: SessionData,
        signOnType: String,
        rememberMe: Boolean,
        redirectToDeepLink: String
    ) {
        launch {
            val consents = getConsents() // ✅ Automatically fetch consents
            val authenticationSessionData = createAuthenticationSessionData(userData, session, consents)
            
            postAuthenticationChecks(plugin, authenticationSessionData) {
                onSignOnSuccess(
                    signOnType = signOnType,
                    rememberMe = rememberMe,
                    consent = consents.isNotEmpty(),
                    redirectToDeepLink = redirectToDeepLink
                )
            }
        }
    }

    private fun createAuthenticationSessionData(
        userData: Any,
        session: SessionData,
        consents: List<ConsentData>
    ): AuthenticationSessionData {
        return AuthenticationSessionData(
            maskedUsername = when (userData) {
                is String -> userData.maskLast()
                is UserIdData -> userData.display.toString()
                else -> ""
            },
            lastSignOn = session.lastSignOn,
            encryptedFriendlyId = session.encryptedFriendlyId ?: StringUtils.EMPTY,
            localId = when (userData) {
                is String -> createLocalId(userData)
                is UserIdData -> userData.id.toString()
                else -> ""
            },
            consents = consents
        )
    }

    private fun getConsents(): List<ConsentData> {
        // Fetch consents (dummy implementation; replace with actual API call)
        return listOf() // Replace with actual logic to retrieve consents
    }
}
