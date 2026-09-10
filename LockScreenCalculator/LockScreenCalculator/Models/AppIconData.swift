import SwiftUI

struct AppIconData: Identifiable, Hashable {
    let id: String
    let label: String
    let gradientColors: [Color]
    let symbolName: String
    let symbolColor: Color
    var isMail: Bool = false
}

enum AppIconCatalog {
    static let grid: [AppIconData] = [
        AppIconData(id: "calendar", label: "יומן", gradientColors: [Color(hex: "ffffff"), Color(hex: "f2f2f2"), Color(hex: "e2e2e2")], symbolName: "calendar", symbolColor: Color(hex: "ff453a")),
        AppIconData(id: "camera", label: "מצלמה", gradientColors: [Color(hex: "4a4a4c"), Color(hex: "2c2c2e"), Color(hex: "141416")], symbolName: "camera.fill", symbolColor: .white),
        AppIconData(id: "photos", label: "תמונות", gradientColors: [Color(hex: "ff9a3c"), Color(hex: "ff375f"), Color(hex: "af52de")], symbolName: "photo.fill", symbolColor: .white),
        AppIconData(id: "maps", label: "מפות", gradientColors: [Color(hex: "4cd671"), Color(hex: "2fb156"), Color(hex: "187f39")], symbolName: "location.fill", symbolColor: .white),
        AppIconData(id: "weather", label: "מזג אוויר", gradientColors: [Color(hex: "5aa8f0"), Color(hex: "2f7fe0"), Color(hex: "124fae")], symbolName: "cloud.sun.fill", symbolColor: .white),
        AppIconData(id: "podcasts", label: "פודקאסטים", gradientColors: [Color(hex: "b968e0"), Color(hex: "8e44c9"), Color(hex: "5e2a8f")], symbolName: "mic.fill", symbolColor: .white),
        AppIconData(id: "stocks", label: "מניות", gradientColors: [Color(hex: "3c3c3e"), Color(hex: "232325"), Color(hex: "0e0e10")], symbolName: "chart.line.uptrend.xyaxis", symbolColor: Color(hex: "30d158")),
        AppIconData(id: "compass", label: "מצפן", gradientColors: [Color(hex: "3c3c3e"), Color(hex: "232325"), Color(hex: "0e0e10")], symbolName: "location.north.line.fill", symbolColor: Color(hex: "ff9500")),
        AppIconData(id: "calculator", label: "מחשבון", gradientColors: [Color(hex: "a8a8ad"), Color(hex: "8e8e93"), Color(hex: "5f5f63")], symbolName: "plusminus", symbolColor: Color(hex: "ff9f0a")),
        AppIconData(id: "notes", label: "פתקים", gradientColors: [Color(hex: "ffe27a"), Color(hex: "ffcc33"), Color(hex: "e8a300")], symbolName: "note.text", symbolColor: Color(hex: "5b4400")),
        AppIconData(id: "reminders", label: "תזכורות", gradientColors: [Color(hex: "ffffff"), Color(hex: "f5f5f5"), Color(hex: "e6e6e6")], symbolName: "checklist", symbolColor: Color(hex: "ff453a")),
        AppIconData(id: "appstore", label: "App Store", gradientColors: [Color(hex: "3aa0ff"), Color(hex: "0a6ee8"), Color(hex: "0048ad")], symbolName: "arrow.down.app.fill", symbolColor: .white),
        AppIconData(id: "settings", label: "הגדרות", gradientColors: [Color(hex: "a8a8ad"), Color(hex: "8e8e93"), Color(hex: "5f5f63")], symbolName: "gearshape.fill", symbolColor: .white),
        AppIconData(id: "wallet", label: "Wallet", gradientColors: [Color(hex: "3c3c3e"), Color(hex: "232325"), Color(hex: "0e0e10")], symbolName: "wallet.pass.fill", symbolColor: Color(hex: "f2c14e")),
        AppIconData(id: "health", label: "בריאות", gradientColors: [Color(hex: "ffffff"), Color(hex: "f7f7f7"), Color(hex: "eeeeee")], symbolName: "heart.fill", symbolColor: Color(hex: "ff2d55")),
        AppIconData(id: "facetime", label: "FaceTime", gradientColors: [Color(hex: "4cd671"), Color(hex: "2fb156"), Color(hex: "187f39")], symbolName: "video.fill", symbolColor: .white),
        AppIconData(id: "contacts", label: "אנשי קשר", gradientColors: [Color(hex: "a8a8ad"), Color(hex: "8e8e93"), Color(hex: "5f5f63")], symbolName: "person.fill", symbolColor: .white),
        AppIconData(id: "files", label: "קבצים", gradientColors: [Color(hex: "3aa0ff"), Color(hex: "0a6ee8"), Color(hex: "0048ad")], symbolName: "folder.fill", symbolColor: .white),
        AppIconData(id: "mail", label: "Mail", gradientColors: [Color(hex: "6bc2ff"), Color(hex: "3b82f5"), Color(hex: "7b3fe4")], symbolName: "envelope.fill", symbolColor: .white, isMail: true),
    ]

    static let dock: [AppIconData] = [
        AppIconData(id: "phone", label: "טלפון", gradientColors: [Color(hex: "4cd671"), Color(hex: "2fb156"), Color(hex: "187f39")], symbolName: "phone.fill", symbolColor: .white),
        AppIconData(id: "safari", label: "ספארי", gradientColors: [Color(hex: "ffffff"), Color(hex: "f5f5f5"), Color(hex: "e6e6e6")], symbolName: "safari.fill", symbolColor: Color(hex: "0a84ff")),
        AppIconData(id: "messages", label: "הודעות", gradientColors: [Color(hex: "4cd671"), Color(hex: "2fb156"), Color(hex: "187f39")], symbolName: "message.fill", symbolColor: .white),
        AppIconData(id: "music", label: "מוזיקה", gradientColors: [Color(hex: "ff6688"), Color(hex: "fc3158"), Color(hex: "c81030")], symbolName: "music.note", symbolColor: .white),
    ]

    static var all: [AppIconData] { grid + dock }
}
