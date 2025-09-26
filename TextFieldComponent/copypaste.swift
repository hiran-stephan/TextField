package com.cibc.app.configuration

/**
 * Force-upgrade evaluator.
 *
 * ## Semantics
 * 1) **Empty list → allow** (no force upgrade).
 * 2) **Normalization:** If a pattern’s *minor* is `X`, we force the *patch* to `X` as well:
 *    - `M.X.P  →  M.X.X`
 *    - `M.X.X` stays as-is.
 * 3) **Applicability (coarse filter):**
 *    - A pattern is *applicable* to the current version when:
 *      - `major` is equal **or** `X`, **and**
 *      - `minor` is equal **or** `X`.
 *    - Patch is **ignored** for applicability.
 * 4) **Explicit match (final check):**
 *    - Compare parts left→right (`major.minor.patch…`) with **missing parts treated as `0`**.
 *    - `X` matches anything at that position.
 *    - If **any** applicable pattern explicitly matches the current version → **blocked**.
 *    - Otherwise → **allow**.
 *
 * ## Examples
 * - current `1.0.7` vs pattern `1.0.X` → match → blocked.
 * - current `1.7.4` vs pattern `1.X.3` → normalized to `1.X.X` → match → blocked.
 * - current `1.0.1` vs pattern `1.0.1.0` → equal (missing parts = 0) → blocked.
 * - current `2.3.9` vs patterns `[1.X.X, 2.3.4, 3.0.0]` → applicable found (2.3.*) but no explicit match → allow.
 */
class ForceUpgradeBusinessLogicImpl :
    SplashForceUpgradeBusinessLogic,
    AuthenticationForceUpgradeBusinessLogic,
    KoinComponent {

    /**
     * Returns `true` if the **currentVersion** must be blocked by **any** of the blocked version patterns.
     */
    override fun isAppVersionBlocked(
        currentVersion: String,
        blockedVersions: List<String>,
    ): Boolean {
        // FU-EMPTY-1: No patterns → allow
        if (blockedVersions.isEmpty()) return false

        // FU-NORM-1: Normalize patterns (e.g., M.X.P → M.X.X)
        val normalized = blockedVersions.map(::normalizePattern)

        // FU-APPLY-1: keep only patterns that *apply* to current (major/minor equal or X)
        val applicable = normalized.filter { patternAppliesToCurrent(it, currentVersion) }

        // If nothing applies, allow
        if (applicable.isEmpty()) return false

        // FU-MATCH-1: block only if at least one applicable pattern *explicitly* matches current
        return applicable.any { patternMatchesCurrent(it, currentVersion) }
    }

    // -------------------------------------------------------------------------
    // Legacy comparator (kept for potential ordering/equality checks).
    // Pads missing parts with 0 and treats 'X' as wildcard at that position.
    // Returns:
    //   < 0 if oldVersion < newVersion, 0 if equal, > 0 if oldVersion > newVersion
    // -------------------------------------------------------------------------
    fun compareVersion(
        oldVersion: String,
        newVersion: String,
    ): Int {
        // Split on '.' and '-', trim empties; keeps compatibility with strings like "1.2.3-rc1"
        val oldVersionParts = oldVersion
            .split(".")
            .flatMap { it.split("-") }
            .filter { it.isNotEmpty() }

        val newVersionParts = newVersion.split(".")

        val maxLength = maxOf(oldVersionParts.size, newVersionParts.size)
        for (i in 0 until maxLength) {
            val oldPartStr = oldVersionParts.getOrElse(i) { "0" }
            val newPartStr = newVersionParts.getOrElse(i) { "0" }

            // Wildcard segment: treat as equal at this position
            if (oldPartStr.equals("X", ignoreCase = true) ||
                newPartStr.equals("X", ignoreCase = true)
            ) continue

            val oldPart = oldPartStr.toIntOrNull() ?: 0
            val newPart = newPartStr.toIntOrNull() ?: 0

            if (oldPart != newPart) return oldPart.compareTo(newPart)
        }
        return 0
    }

    // -------------------------------------------------------------------------
    // Helpers
    // -------------------------------------------------------------------------

    /**
     * FU-NORM-1: If minor is a wildcard, force patch to wildcard too.
     *   M.X.P  →  M.X.X
     *   M.X.X  →  M.X.X (idempotent)
     */
    private fun normalizePattern(pattern: String): String {
        val parts = pattern.split('.').toMutableList()
        if (parts.size < 3) return pattern

        val minor = parts[1]
        val patch = parts[2]

        if (minor.equals("x", true) && !patch.equals("x", true)) {
            parts[2] = "X"
        }
        return parts.joinToString(".")
    }

    /**
     * Coarse filter: pattern is *applicable* if (major == current.major OR X)
     * and (minor == current.minor OR X). Patch is ignored here.
     */
    private fun patternAppliesToCurrent(
        pattern: String,
        current: String,
    ): Boolean {
        val pParts = pattern.split('.')
        val cParts = current.split('.')

        val pMajor = pParts.getOrNull(0) ?: return false
        val pMinor = pParts.getOrNull(1) ?: return false

        val cMajor = cParts.getOrNull(0) ?: return false
        val cMinor = cParts.getOrNull(1) ?: return false

        if (!pMajor.equals("X", true) && pMajor != cMajor) return false
        if (!pMinor.equals("X", true) && pMinor != cMinor) return false

        return true
    }

    /**
     * Explicit match check against the **current** version.
     * - Walk parts left→right; missing parts are treated as `0`.
     * - `X` matches anything at that position.
     * - All non-wildcard numeric parts must be equal; otherwise no match.
     */
    private fun patternMatchesCurrent(
        pattern: String,
        current: String,
    ): Boolean {
        val p = pattern.split('.')
        val c = current.split('.')

        val max = maxOf(p.size, c.size)
        for (i in 0 until max) {
            val pp = p.getOrElse(i) { "0" }
            val cp = c.getOrElse(i) { "0" }

            if (pp.equals("X", true)) continue

            val ppNum = pp.toIntOrNull() ?: 0
            val cpNum = cp.toIntOrNull() ?: 0

            if (ppNum != cpNum) return false
        }
        return true
    }
}
