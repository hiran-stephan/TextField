Added KDoc + inline comments for methods and rules.

Fixed normalization: if minor = X and patch not X, force patch → X (M.X.P → M.X.X).

Refactored applicability check into patternAppliesToCurrent() (major/minor must match or be X).

Refactored explicit match check into patternMatchesCurrent() (walk parts, pad with 0, X matches anything).

Left compareVersion() as legacy helper, clarified handling of X, missing parts = 0, and hyphenated parts.

Cleaned up logic in isAppVersionBlocked() → normalize → filter → match.


                                    Rating & Justification: 4.5 / 5 (Exceeds Expectations)

                                    I am rating myself 4.5 out of 5 for this performance cycle.

                                    I consistently delivered on key deliverables across multiple phases of the project, ensuring quality and timely execution.

                                    I demonstrated ownership by providing production support, resolving issues promptly, and adapting to evolving business priorities.

                                    My collaboration with cross-functional partners ensured alignment and smooth execution, while my contributions to process improvements supported long-term team efficiency.

                                    While I met and often exceeded expectations, I acknowledge there is always room for further growth, particularly in expanding leadership influence and driving even greater innovation at the team level.

                                    Overall, my contributions added measurable value to both the project and the organization, aligning with business objectives and strengthening delivery outcomes.
