val problemsList = error?.toProblemsData().orEmpty()

val isNicknameRetrieved: Boolean = problemsList.none { it.message == ERROR_CODE_NICKNAME_NOT_RETRIEVED }
val isShowHideRetrieved: Boolean = problemsList.none { it.message == ERROR_CODE_SHOW_HIDE_NOT_RETRIEVED }
