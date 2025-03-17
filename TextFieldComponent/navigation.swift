class AdobeAnalyticsWrapperImpl: AdobeAnalyticsWrapper {
    
    func removeCachedIdentities(namespace: String) {
        Identity.getIdentities { identities, error in
            guard let identities = identities else { return }
            let items = identities.getIdentityItems(forNamespace: namespace)
            for item in items {
                Identity.removeIdentity(item, namespace: namespace)
            }
        }
    }

    func syncIdentifiers(namespace: String, ucid: String) -> Bool {
        let item = IdentityItem(id: ucid, authenticatedState: .authenticated, primary: false)

        let identityMap = IdentityMap()
        identityMap.addItem(item, forNamespace: namespace)
        Identity.updateIdentities(identityMap)
        
        return true
    }
}
