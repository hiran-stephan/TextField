@Test
    fun lettersAscending_detects_run() {
        assertTrue("xxabcxx".hasSequentialRun())         // abc
        assertTrue("AbCdE".hasSequentialRun())           // case-insensitive
    }

    @Test
    fun lettersDescending_detects_run() {
        assertTrue("zzcbaqq".hasSequentialRun())         // cba
        assertTrue("XyZcBa".hasSequentialRun())          // case-insensitive
    }

    @Test
    fun digitsAscending_detects_run() {
        assertTrue("id123ok".hasSequentialRun())         // 123
        assertTrue("0a456b".hasSequentialRun())          // 456
    }

    @Test
    fun digitsDescending_detects_run() {
        assertTrue("pin987x".hasSequentialRun())         // 987
        assertTrue("code321end".hasSequentialRun())      // 321
    }

    @Test
    fun respectsMinLen_parameter() {
        assertFalse("abc".hasSequentialRun(minLen = 4))  // only 3 long
        assertTrue("abcd".hasSequentialRun(minLen = 4))  // 4 long
    }

    @Test
    fun resetsAcrossClasses_andSymbols() {
        assertFalse("ab1cd".hasSequentialRun())          // never reaches 3 contiguously
        assertFalse("ab-cd".hasSequentialRun())          // dash breaks the run
    }

    @Test
    fun doesNotWrapAroundDigits() {
        // 8→9 is ascending, 9→0 is not; never hits length 3
        assertFalse("890".hasSequentialRun())
        assertFalse("901".hasSequentialRun())
    }

    @Test
    fun identicalCharsAreNotSequential() {
        assertFalse("aaab".hasSequentialRun())           // repetition is a different rule
        assertFalse("111".hasSequentialRun())
    }

    @Test
    fun realExample_catches_descending_cba() {
        assertTrue("Cibcbankingworld@720".hasSequentialRun()) // contains "cba"
    }

    @Test
    fun shortStrings_returnFalse() {
        assertFalse("".hasSequentialRun())
        assertFalse("a".hasSequentialRun())
        assertFalse("ab".hasSequentialRun())
    }
