let sorted = groupedConsents.sorted { (l, r) in (Int(l.key) ?? 0) < (Int(r.key) ?? 0) }
ForEach(sorted, id: \.0) { key, values in
    let presenter = viewModel.createConsentSectionPresenter(sectionIndex: key, documentList: values)
    let section = presenter.toSectionData()
    // render…
}
