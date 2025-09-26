class ForceUpgradeBusinessLogicImplTest {

    private val logic = ForceUpgradeBusinessLogicImpl()

    // 1) Empty blocked list -> allow
    @Test
    fun `allow when blocked list is empty`() {
        val current = "2.1.0"
        val blocked = emptyList<String>()
        assertFalse(logic.isAppVersionBlocked(current, blocked))
    }

    // 2) No applicable patterns (different major & no X) -> allow
    @Test
    fun `allow when no applicable patterns`() {
        val current = "1.0.1"
        val blocked = listOf("2.0.0", "3.1.4")
        assertFalse(logic.isAppVersionBlocked(current, blocked))
    }

    // 3) Applicable (same major&minor) but no explicit match on patch -> allow
    // e.g. current 1.0.1 vs pattern 1.0.2 (no wildcard) -> not blocked
    @Test
    fun `allow when applicable but no explicit match`() {
        val current = "1.0.1"
        val blocked = listOf("1.0.2", "2.0.0")
        assertFalse(logic.isAppVersionBlocked(current, blocked))
    }

    // 4) Exact match blocks
    @Test
    fun `block on exact pattern match`() {
        val current = "1.0.1"
        val blocked = listOf("1.0.1")
        assertTrue(logic.isAppVersionBlocked(current, blocked))
    }

    // 5) Wildcard match blocks (patch X)
    @Test
    fun `block on patch wildcard`() {
        val current = "1.0.7"
        val blocked = listOf("1.0.X")
        assertTrue(logic.isAppVersionBlocked(current, blocked))
    }

    // 6) Wildcard match blocks (minor X, patch X implicit by normalization)
    @Test
    fun `block on minor wildcard after normalization`() {
        val current = "1.7.4"
        val blocked = listOf("1.X.3")   // should normalize to 1.X.X
        assertTrue("Requires normalizePattern fix", logic.isAppVersionBlocked(current, blocked))
    }

    // 7) Major wildcard works (blocks all 3.x.y)
    @Test
    fun `block on major wildcard`() {
        val current = "3.2.5"
        val blocked = listOf("X.2.5", "X.X.X")
        assertTrue(logic.isAppVersionBlocked(current, blocked))
    }

    // 8) Mixed list: allow when there is no explicit match among applicable ones
    @Test
    fun `allow when applicable set exists but none matches`() {
        val current = "2.3.9"
        val blocked = listOf("1.X.X", "2.3.4", "3.0.0")
        assertFalse(logic.isAppVersionBlocked(current, blocked))
    }

    // 9) Sizes differ are padded with zeros (pattern 1.2 vs 1.2.0)
    @Test
    fun `pad shorter versions with zeros during compare`() {
        // Uses legacy compareVersion via patternMatchesCurrent
        val current = "1.2.0"
        val blocked = listOf("1.2")
        assertTrue(logic.isAppVersionBlocked(current, blocked))
    }

    // 10) Non-numeric parts (other than X) are treated as 0 and thus won't match incorrectly
    @Test
    fun `non numeric parts don't cause crash and typically don't match`() {
        val current = "2.0.1"
        val blocked = listOf("2.0.beta")
        assertFalse(logic.isAppVersionBlocked(current, blocked))
    }

    // --- Regression tests from your screenshots/messages ---

    // A) “current version is greater but not blocked”
    @Test
    fun `current greater but not blocked - sample 1`() {
        val current = "1.0.1"
        val blocked = listOf("1.1.0", "1.0.0", "2.0.0")
        assertFalse(logic.isAppVersionBlocked(current, blocked))
    }

    // B) “current greater but not blocked - variation”
    @Test
    fun `current greater but not blocked - sample 2`() {
        val current = "1.0.1"
        val blocked = listOf("1.1.0", "1.0.1.0", "2.0.0")
        assertFalse(logic.isAppVersionBlocked(current, blocked))
    }

    // C) “current is greater” with wildcard should block
    @Test
    fun `current greater but wildcard blocks`() {
        val current = "1.0.1"
        val blocked = listOf("1.1.0", "1.0.X", "2.0.0")
        assertTrue(logic.isAppVersionBlocked(current, blocked))
    }

    // D) Large major numbers are not accidentally matched
    @Test
    fun `do not block unrelated big major`() {
        val current = "10.1.0"
        val blocked = listOf("1.0.X", "2.0.0", "2.0.0") // from the chat example
        assertFalse(logic.isAppVersionBlocked(current, blocked))
    }
}
