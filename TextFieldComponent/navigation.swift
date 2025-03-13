suspend inline fun <reified T> GlobalCallbackRequestBuilder.safeClientCall(
    referenceId: String,
    result: GlobalCallbackRequestBuilder.(T?) -> Unit = {},  // Make result nullable
    block: GlobalCallbackRequestBuilder.() -> HttpResponse
): T? {
    try {
        val response = block(this)
        val statusCode = response.status.value

        if (statusCode == 204) {
            // No Content - Return null instead of deserializing
            globalCallbacks.onGlobalSuccess(referenceId, response = response)
            return null
        }

        try {
            response.body<T>().also {
                result(this, it)
                globalCallbacks.onGlobalSuccess(referenceId, response = response)
            }
        } catch (e: Exception) {
            throw BundleException(e, response)
        }
    } catch (e: Exception) {
        when (e) {
            is BundleException -> {
                globalCallbacks.onGlobalError(referenceId, response = e.response, exception = e.exception)
                throw e.exception
            }
            is StepUpException, is NetworkErrorException -> {
                globalCallbacks.onGlobalError(referenceId, response = e.response, exception = e)
                throw e
            }
            else -> {
                globalCallbacks.onGlobalError(referenceId, response = null, exception = e)
                throw e
            }
        }
    }
}
