


if let derivedDataPath = ProcessInfo.processInfo.environment["SOURCE_ROOT"] {
    let targetPath = (derivedDataPath as NSString).appendingPathComponent("Target/Common/Key.plist")
    print("Dynamic Target Path: \(targetPath)")
}
