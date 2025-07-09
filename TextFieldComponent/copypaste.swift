fun String?.toCurrencyInputFormat(locale: String = "en", currencySymbol: String = "$"): String {
    val value = this?.toDoubleOrNull() ?: 0.0
    return value.toCurrencyInputFormat(locale, currencySymbol)
}

fun Double?.toCurrencyInputFormat(locale: String = "en", currencySymbol: String = "$"): String {
    if (this == null) return "$currencySymbol0.00"

    val absValue = kotlin.math.abs(this)
    val integerPart = absValue.toLong()
    val fractionPart = ((absValue - integerPart) * 100).roundToInt()

    val formattedInteger = integerPart.toString()
        .reversed()
        .chunked(3)
        .joinToString(",")
        .reversed()

    val formattedFraction = fractionPart.toString().padStart(2, '0')

    val sign = if (this < 0) "-" else ""

    return "$sign$currencySymbol$formattedInteger.$formattedFraction"
}



val alertInputFieldValue = alertInputFieldText?.toCurrencyInputFormat() 
    ?: getThresholdValue(purposeCode).toCurrencyInputFormat()

import com.cibc.services.utilities.toCurrencyInputFormat

