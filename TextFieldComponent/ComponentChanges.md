
# Component Changes

## 1. `AccountNicknameFormView`
**Purpose**: Allows users to edit account nicknames with inline validation and contextual messaging.  
**Includes**:
- Text input field for nickname.
- Primary and secondary buttons.
- Inline message display and accessibility support.

## 2. `AccountNicknameView`
**Purpose**: Displays the nickname or fallback button to add/edit, depending on account state.  
**Behavior**:
- Conditionally shows nickname or `TextLinkButton` based on `isNicknameRetrieved` and `hasNickname`.

## 3. `AccountPreferenceCard`
**Purpose**: Displays an account preference option as a tappable card.  
**Includes**:
- Primary and secondary text.
- Optional badge indicators.
- Optional chevron and debit card display.

## 4. `AccountPreferenceCardContainerView`
**Purpose**: Wraps account preference components with an optional section header and info tooltip.  
**Features**:
- Configurable header with accessibility text.
- Optional info alert (via `TooltipAlertModifier`).

## 5. `AccountPreferenceHeader`
**Purpose**: Displays a header with badges and title text for grouped preferences.  
**Behavior**:
- Adjusts layout based on badge visibility and text frame.

## 6. `AccountTextSection`
**Purpose**: Reusable text view showing a primary and secondary label.  
**Style Variants**:
- `list` and `header` styles with different fonts, alignment, and colors using `AccountTextSectionStyle`.
