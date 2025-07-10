
fun String.formatCurrencyForTextField(): String {
    // Use regex to add commas for thousands
    val parts = this.split(".")
    val integerPart = parts[0].replace(Regex("(\\d)(?=(\\d{3})+(?!\\d))"), "$1,")

    val decimalPart = if (parts.size > 1) {
        // Use only up to 2 digits for cents
        val cents = parts[1].padEnd(2, '0').take(2)
        ".$cents"
    } else {
        // If there's no decimal part, default to .00
        ".00"
    }

    return integerPart + decimalPart
}
