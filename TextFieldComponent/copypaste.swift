// 👇 Add this ON THE NavigationStack (or right after it in the chain)
        .onChange(of: navigator.path) { newPath in
            let dump = newPath.map { "\($0)" }.joined(separator: " -> ")
            print("PATH -> [\(dump)]")
        }



print("DEST ->", String(describing: type(of: item)), item)
