@Test fun `valid usernames should pass`() {
    val validSamples = listOf(
        "Amacedo02",
        "John_Doe19",
        "Jane99Doe",
        "TestUser12!",
        "Alpha77_Z",
        "MyUser_2025",
        "Valid01!@",
        "CoolName55;"
    )
    validSamples.forEach {
        val result = inputValidator.validate(it)
        assertTrue(result.all { it.status == ValidationStatus.VALID }, it)
    }
}

@Test fun `invalid usernames should fail`() {
    val invalidSamples = listOf(
        "Ab12",
        "VeryLongUsername123456789",
        "12345678",
        "abcdefgh",
        "Abcdef12",
        "User(Name)01",
        "Name%1234",
        "Name\\1234",
        "User<2025>",
        "ab1234@#",
        "user__1234",
        "john..99"
    )
    invalidSamples.forEach {
        val result = inputValidator.validate(it)
        assertTrue(result.any { it.status == ValidationStatus.INVALID }, it)
    }
}
