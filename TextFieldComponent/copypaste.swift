.onChange(of: navigator.path) { newPath in
    print("PATH ->", newPath.map { "\($0)" }) // see the actual items coming from KMP
}

// Inside your destination:
print("DEST ->", String(describing: type(of: item)), item)
