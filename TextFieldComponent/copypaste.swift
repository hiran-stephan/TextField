Added KDoc + inline comments for methods and rules.

Fixed normalization: if minor = X and patch not X, force patch → X (M.X.P → M.X.X).

Refactored applicability check into patternAppliesToCurrent() (major/minor must match or be X).

Refactored explicit match check into patternMatchesCurrent() (walk parts, pad with 0, X matches anything).

Left compareVersion() as legacy helper, clarified handling of X, missing parts = 0, and hyphenated parts.

Cleaned up logic in isAppVersionBlocked() → normalize → filter → match.
