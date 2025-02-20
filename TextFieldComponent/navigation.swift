extension ConsentStyle: Equatable {
    static func == (lhs: ConsentStyle, rhs: ConsentStyle) -> Bool {
        return lhs.uncheckedIcon === rhs.uncheckedIcon &&
               lhs.checkedIcon === rhs.checkedIcon &&
               lhs.typography == rhs.typography &&
               lhs.backgroundColor == rhs.backgroundColor &&
               lhs.borderColor == rhs.borderColor &&
               lhs.alignment == rhs.alignment
    }
}
