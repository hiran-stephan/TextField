.navigationDestination(for: NavigationItem.self) { item in
    destination(item)
        .onAppear {
            // Print the count and the identity (pointer) of each element
            let ids = navigator.path.map { elem in
                (String(describing: type(of: elem)),
                 ObjectIdentifier(elem as AnyObject))
            }
            print("PATH IDENTITIES ->", ids)
            print("DEST APPEARED ->", String(describing: type(of: item)),
                  ObjectIdentifier(item as AnyObject), item)
        }
}
