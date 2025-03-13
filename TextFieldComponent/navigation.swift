suspend inline fun <reified T : Any> GlobalCallbackRequestBuilder.safeClientCall(
    referenceId: String,
    result: GlobalCallbackRequestBuilder.(T) -> Unit = {},
    block: GlobalCallbackRequestBuilder.() -> HttpResponse
): T {
    try {
        val response = block(this)
        val statusCode = response.status.value

        if (statusCode == 204) {
            // Create an empty response object
            val emptyResponse = createEmptyResponse<T>()
            
            // Pass emptyResponse to result() instead of returning it directly
            result(this, emptyResponse)
            
            globalCallbacks.onGlobalSuccess(referenceId, response = response)
            return emptyResponse
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
