.onChange(of: isEditingNickname) { newValue in
            if newValue {
                fetchNicknameData()
            }
        }
