import SwiftUI

/// Live date display for the calendar icon face, mirroring the original's
/// dynamic day-of-month + Hebrew weekday abbreviation.
struct CalendarIconView: View {
    let size: CGFloat

    private static let heDayAbbr = ["יום א'", "יום ב'", "יום ג'", "יום ד'", "יום ה'", "יום ו'", "שבת"]

    private var day: String {
        String(Calendar.current.component(.day, from: Date()))
    }

    private var weekday: String {
        let idx = Calendar.current.component(.weekday, from: Date()) - 1
        return Self.heDayAbbr[idx]
    }

    var body: some View {
        VStack(spacing: 0) {
            Text(weekday)
                .font(.system(size: size * 0.16, weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, size * 0.07)
                .background(Color(hex: "ff453a"))

            Text(day)
                .font(.system(size: size * 0.42, weight: .semibold))
                .foregroundStyle(Color(hex: "1c1c1e"))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
        }
    }
}
