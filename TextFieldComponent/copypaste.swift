// 3) popTo: no match → no-op
@MainActor
func test_popTo_whenNoMatch_doesNothing() {
  let a = TestItem(key: "a", domain: "d")
  let b = TestItem(key: "b", domain: "d")
  let (sut, nav, _) = makeSUT(startPath: [a, b])

  // Use a different domain OR a different path so route() is different
  // Option A: different domain
  let nonMatch = TestItem(key: "zzz", domain: "other")
  // Option B: same domain, different path
  // let nonMatch = TestItem(key: "zzz", domain: "d", path: "p1")

  sut.popTo(item: nonMatch, inclusive: true)

  XCTAssertRoutesEqual(nav.path, [a, b])  // unchanged
}

// Proves popTo finds by route() and uses firstIndex (earliest match)
@MainActor
func test_popTo_withDuplicateRoutes_trimsToFirstMatch() {
  let a = TestItem(key: "a", domain: "d")         // route: cibcus://d
  let b = TestItem(key: "b", domain: "d")         // route: cibcus://d
  let (sut, nav, _) = makeSUT(startPath: [a, b])

  let target = TestItem(key: "zzz", domain: "d")  // same route → matches
  sut.popTo(item: target, inclusive: false)

  // Because popTo(where:) uses firstIndex, we keep up to the first match (a)
  XCTAssertRoutesEqual(nav.path, [a])
}

