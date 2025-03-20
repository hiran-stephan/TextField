let bundlePath = Bundle.main.bundlePath
let targetPath = (bundlePath as NSString).deletingLastPathComponent // Moves up one level
let commonPath = (targetPath as NSString).appendingPathComponent("Common/Key.plist")

print("Dynamically Generated Path: \(commonPath)")
