suspend fun <T> retryNetworkRequest(
    times: Int,
    initialDelayMillis: Long = 1000,
    maxDelayMillis: Long = 5000,
    factor: Double = 2.0,
    block: suspend () -> T
): T {
    var currentDelay = initialDelayMillis

    repeat(times - 1) { attempt ->
        try {
            // Try executing the block
            return block()
        } catch (e: Exception) {
            println("Attempt ${attempt + 1} failed: ${e.message}")

            // Calculate and delay before retrying
            delay(currentDelay)
            currentDelay = (currentDelay * factor).toLong().coerceAtMost(maxDelayMillis)
        }
    }

    // Final attempt (no retry logic here)
    return block()
}

suspend fun fetchData(): String {
    return retryNetworkRequest(
        times = 3,
        initialDelayMillis = 1000,
        maxDelayMillis = 8000,
        factor = 2.0
    ) {
        // Simulate a network call
        if (Math.random() > 0.7) {
            "Success"
        } else {
            throw Exception("Network request failed")
        }
    }
}
