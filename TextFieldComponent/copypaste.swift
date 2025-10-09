
On Android, the date picker works with pure date values.
When the user selects a date, Android converts it using LocalDate.toEpochMillisAtStartOfDay() which always gives the start of that day in UTC.
That means the stored and transmitted value has no local timezone offset — it’s a clean UTC midnight timestamp, so it never shifts when converted or displayed again.

On iOS, SwiftUI’s DatePicker binds to a full Date object which always carries a time component internally stored in UTC.
When the user selects “Oct 10”, SwiftUI actually stores 2025-10-10 00:00 UTC.
If the device is in a different timezone, for example Eastern Time (UTC−4), that same moment corresponds to 2025-10-09 20:00 local time.
When the system converts that Date back to local time for display or formatting, it becomes the previous or next day — causing the “+1 day” issue.

So in short:
Android stripped time and timezone completely by converting the LocalDate to epoch UTC midnight.
iOS kept the time zone conversion active because Date always includes UTC time, and SwiftUI automatically adjusts it.

The fix is to normalize the picked date to local midnight right after selection (Calendar.current.startOfDay(for:)) and convert explicitly to UTC or ET midnight only when sending it to the backend.



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

3) Build transfer payloads

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



