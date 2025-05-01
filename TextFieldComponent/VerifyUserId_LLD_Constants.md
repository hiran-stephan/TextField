
# Low-Level Design: RecoverUserId Domain Constants and Models

---

## 📦 Domain Models

| Data Class Name        | Properties                                      | Description                                                 |
|------------------------|--------------------------------------------------|-------------------------------------------------------------|
| `RecoverUserIdData`    | `friendlyId: String?`                            | Holds the friendly ID for recovered user                    |
| `ContentResources`     | `content: ContentFile`                           | Wrapper for downloadable content used in localization       |

---

## 🧩 RecoverUserIdConstants

These constants are used for validating inputs, character limits, account types, and routing.

| Constant Name                             | Value                         | Description                                            |
|-------------------------------------------|-------------------------------|--------------------------------------------------------|
| `RECOVERUSERID_ROUTER_SCOPE`              | `"recoveruserid-router"`      | Scope for dependency injection                        |
| `NORTH_AMERICAN_PHONE_NUMBER`             | `"NORTH_AMERICAN"`            | Enum value for North American phone type              |
| `INTERNATIONAL_PHONE_NUMBER`              | `"INTERNATIONAL"`             | Enum value for International phone type               |
| `SSN`                                     | `"SSN"`                       | SSN input type constant                               |
| `SIN`                                     | `"SIN"`                       | SIN input type constant                               |
| `PHONE_NUMBER_NORTH_AMERICAN_CHARACTER_LIMIT` | `10`                        | Character limit for North American phone numbers      |
| `PHONE_NUMBER_INTERNATIONAL_CHARACTER_LIMIT`  | `16`                        | Character limit for International phone numbers       |
| `ACCOUNT_NUMBER_CHARACTER_LIMIT`          | `11`                           | Account number length constraint                      |
| `LOAN_NUMBER_CHARACTER_LIMIT`             | `16`                           | Loan number length constraint                         |
| `CARD_NUMBER_CHARACTER_LIMIT`             | `16`                           | Card number length constraint                         |
| `SSN_CHARACTER_LIMIT`                     | `9`                            | SSN length                                             |
| `SIN_CHARACTER_LIMIT`                     | `9`                            | SIN length                                             |
| `USER_AND_DEPOSIT_CARD_INFO`             | `"UserAndDepositAccountInfo"` | Authentication type enum                              |
| `USER_AND_DEBIT_CARD_INFO`               | `"UserAndDebitCardInfo"`      | Authentication type enum                              |
| `USER_AND_LOAN_CARD_INFO`                | `"UserAndLoanAccountInfo"`    | Authentication type enum                              |
| `DEPOSIT`                                 | `"DEPOSIT"`                   | Account type                                           |
| `LOAN`                                    | `"LOAN"`                      | Account type                                           |
| `CARD`                                    | `"CARD"`                      | Account type                                           |

---

## 🗂️ ContentConstants

These constants are used for retrieving UI text and accessibility labels from localized content files.

### 🔐 Common Content Keys

| Constant Name                                              | Value                                                       |
|------------------------------------------------------------|-------------------------------------------------------------|
| `RECOVER_USER_ID_TITLE`                                   | `"recover_userid_title"`                                    |
| `RECOVER_USER_ID_MASTHEAD_SHIELD_ACCESSIBILITY_TEXT`      | `"shield_icon_accessibility_text"`                          |
| `PHONE_NUMBER_LABEL_TEXT`                                 | `"phone_number_label_text"`                                 |
| `PHONE_NUMBER_CHECKBOX_LABEL_TEXT`                        | `"phone_number_checkbox_label_text"`                        |
| `PHONE_NUMBER_TOOLTIP_DIALOG_BODY_TEXT`                   | `"phone_number_tooltip_dialog_body_text"`                   |
| `PHONE_NUMBER_TOOLTIP_DIALOG_BUTTON_TEXT`                 | `"phone_number_tooltip_dialog_button_text"`                 |
| `PHONE_NUMBER_TOOLTIP_ICON_ACCESSIBILITY_TEXT`            | `"phone_number_tooltip_icon_accessibility_text"`            |
| `RADIO_BUTTON_GROUP_LABEL_TEXT`                           | `"radio_button_group_label_text"`                           |
| `RADIO_BUTTON_GROUP_TOOLTIP_ICON_ACCESSIBILITY_TEXT`      | `"radio_button_group_tooltip_icon_accessibility_text"`      |
| `RADIO_BUTTON_GROUP_TOOLTIP_DIALOG_BODY_TEXT`             | `"radio_button_group_tooltip_dialog_body_text"`             |
| `RADIO_BUTTON_GROUP_TOOLTIP_DIALOG_BUTTON_TEXT`           | `"radio_button_group_tooltip_dialog_button_text"`           |
| `SSN_TIN_RADIO_BUTTON_LABEL_TEXT`                         | `"ssn_tin_radio_button_label_text"`                         |
| `SSN_RADIO_BUTTON_LABEL_TEXT`                             | `"ssn_radio_button_label_text"`                             |
| `SSN_TIN_INPUT_FIELD_LABEL_TEXT`                          | `"ssn_tin_input_field_label_text"`                          |
| `SSN_INPUT_FIELD_LABEL_TEXT`                              | `"ssn_input_field_label_text"`                              |
| `ACCOUNT_TYPE_DROPDOWN_MENU_LABEL_TEXT`                   | `"account_type_dropdown_menu_label_text"`                   |
| `DROPDOWN_MENU_ITEM_DEFAULT_VALUE`                        | `"dropdown_menu_item_default_value"`                        |
| `ACCOUNT_NUMBER_INPUT_FIELD_LABEL_TEXT`                   | `"account_number_input_field_label_text"`                   |
| `LOAN_ACCOUNT_NUMBER_INPUT_FIELD_LABEL_TEXT`              | `"loan_account_number_input_field_label_text"`              |
| `LAST_FOUR_DIGITS_OF_CARD_NUMBER_LABEL_TEXT`             | `"last_four_digits_of_card_number_label_text"`             |
| `ACCOUNT_NUMBER_TOOLTIP_ICON_ACCESSIBILITY_TEXT`          | `"account_number_tooltip_icon_accessibility_text"`          |
| `ACCOUNT_NUMBER_TOOLTIP_DIALOG_BODY_TEXT`                 | `"account_number_tooltip_dialog_body_text"`                 |
| `ACCOUNT_NUMBER_TOOLTIP_DIALOG_BUTTON_TEXT`               | `"account_number_tooltip_dialog_button_text"`               |

### 🧪 VerifyUserId Specific Keys

| Constant Name                                              | Value                                                       |
|------------------------------------------------------------|-------------------------------------------------------------|
| `VERIFY_USERID_TITLE`                                      | `"verify_userid_title"`                                     |
| `VERIFY_USERID_ALERT_MESSAGE`                              | `"verify_userid_alert_message"`                             |
| `VERIFY_USERID_DROPDOWN_FIELD_LABEL`                       | `"verify_userid_dropdown_field_label"`                      |
| `VERIFY_USERID_DROPDOWN_FIELD_ICON_ACCESSIBILITY_TEXT`     | `"verify_userid_dropdown_field_icon_accessibility_text"`    |
| `PRIMARY_BUTTON_TEXT`                                      | `"primary_button_text"`                                     |
| `SECONDARY_BUTTON_TEXT`                                    | `"secondary_button_text"`                                   |
| `PRIVACY_LINK`                                             | `"privacy_link"`                                            |
