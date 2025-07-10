fun String.formatDecimalPart(): String {
    val parts = this.split(".")

    val decimalPart = if (parts.size > 1) {
        val cents = parts[1].padEnd(2, '0').take(2)
        ".$cents"
    } else {
        ".00"
    }

    return parts[0] + decimalPart
}
