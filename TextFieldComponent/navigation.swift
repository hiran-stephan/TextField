suspend fun <T> retryNetworkRequest(
    times: Int = 2, // Default to 2 attempts
    delayMillis: Long = 2000, // 2-second gap between retries
    block: suspend () -> T
): T {
    repeat(times - 1) { attempt -> // Retry `times - 1` times
        try {
            // Try executing the block
            return block()
        } catch (e: Exception) {
            println("Attempt ${attempt + 1} failed: ${e.message}")

            // If this is the last retry, rethrow the exception
            if (attempt == times - 1) throw e

            // Delay for the specified gap
            delay(delayMillis)
        }
    }

    // Final attempt (no retry logic)
    return block()
}


suspend fun fetchData(): String {
    return retryNetworkRequest(
        times = 2, // Retry twice
        delayMillis = 2000 // 2-second gap between retries
    ) {
        // Simulate a network request
        if (Math.random() > 0.7) {
            "Success"
        } else {
            throw Exception("Network error")
        }
    }
}

// Call fetchData in your coroutine
