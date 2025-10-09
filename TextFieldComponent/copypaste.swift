
1) Add tiny helper (TransfersDateCodec.swift)

import Foundation

enum TransferPolicy { case externalUTC, internalET }

enum TransfersDateCodec {
    private static let gregorian = Calendar(identifier: .gregorian)

    private static func tz(_ p: TransferPolicy) -> TimeZone {
        switch p {
        case .externalUTC: return TimeZone(secondsFromGMT: 0)!              // UTC
        case .internalET:  return TimeZone(identifier: "America/Toronto")!  // ET
        }
    }

    /// UI fix: lock to *local* midnight to avoid +1 day drift in SwiftUI.
    static func normalizeUI(_ date: Date) -> Date {
        Calendar.current.startOfDay(for: date)
    }

    /// Convert UI date -> epoch millis at start-of-day in policy zone (what API wants).
    static func toEpochMillis(_ uiDate: Date, policy: TransferPolicy) -> Int64 {
        var cal = gregorian
        cal.timeZone = tz(policy)
        let comps = cal.dateComponents([.year, .month, .day], from: uiDate)
        let start = cal.date(from: comps)!
        return Int64(start.timeIntervalSince1970 * 1000)
    }
}

2) Patch your DatePicker setter (in TextFieldDate*)

DatePicker(selection: Binding(
-   get: { selectedDate ?? .now },
-   set: { selectedDate = $0 }
+   get: { selectedDate ?? .now },
+   set: { selectedDate = TransfersDateCodec.normalizeUI($0) } // <-- stop drift
), displayedComponents: .date) {
    EmptyView()
}

// External transfer (UTC from FE)
func makeExternalTransferRequest(uiDate: Date) -> ExternalTransferRequest {
    let millis = TransfersDateCodec.toEpochMillis(uiDate, policy: .externalUTC)
    return ExternalTransferRequest(dateEpochMillis: millis /*, ... */)
}

// Internal transfer (ET from FE)
func makeInternalTransferRequest(uiDate: Date) -> InternalTransferRequest {
    let millis = TransfersDateCodec.toEpochMillis(uiDate, policy: .internalET)
    return InternalTransferRequest(dateEpochMillis: millis /*, ... */)
}
