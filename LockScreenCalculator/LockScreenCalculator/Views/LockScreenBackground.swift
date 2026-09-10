import SwiftUI

/// Deep-blue iOS-style wallpaper gradient, matching the original CSS
/// radial/linear gradient stack.
struct LockScreenBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "0a1442"), Color(hex: "071033"), Color(hex: "050a20"), Color(hex: "02040c"), .black],
                startPoint: .top, endPoint: .bottom
            )
            RadialGradient(colors: [Color(hex: "16297e").opacity(0.9), .clear], center: UnitPoint(x: 0.22, y: 0.55), startRadius: 10, endRadius: 260)
            RadialGradient(colors: [Color(hex: "2447c4").opacity(0.9), .clear], center: UnitPoint(x: 0.84, y: 0.40), startRadius: 10, endRadius: 260)
            RadialGradient(colors: [Color(hex: "3b6bef").opacity(0.9), .clear], center: UnitPoint(x: 0.16, y: 0.18), startRadius: 10, endRadius: 260)
            RadialGradient(colors: [Color(hex: "6ea8ff").opacity(0.9), .clear], center: UnitPoint(x: 0.72, y: 0.05), startRadius: 10, endRadius: 220)
        }
    }
}
