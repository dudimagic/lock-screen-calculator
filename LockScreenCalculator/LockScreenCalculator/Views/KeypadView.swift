import SwiftUI

private enum KeyModel: Hashable {
    case digit(String, he: String, en: String, noSub: Bool)
    case ghost(Int)
}

struct KeypadView: View {
    private let columns = Array(repeating: GridItem(.fixed(76), spacing: 22), count: 3)

    private let keyModels: [KeyModel] = [
        .digit("1", he: "", en: "", noSub: false),
        .digit("2", he: "דהו", en: "ABC", noSub: false),
        .digit("3", he: "אבג", en: "DEF", noSub: false),
        .digit("4", he: "מנ", en: "GHI", noSub: false),
        .digit("5", he: "יכל", en: "JKL", noSub: false),
        .digit("6", he: "זחט", en: "MNO", noSub: false),
        .digit("7", he: "רשת", en: "PQRS", noSub: false),
        .digit("8", he: "צק", en: "TUV", noSub: false),
        .digit("9", he: "סעפ", en: "WXYZ", noSub: false),
        .ghost(0),
        .digit("0", he: "", en: "", noSub: true),
        .ghost(1),
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 22) {
            ForEach(keyModels, id: \.self) { model in
                switch model {
                case .ghost:
                    Color.clear.frame(width: 76, height: 76)
                case .digit(let d, let he, let en, let noSub):
                    KeypadButton(digit: d, he: he, en: en, noSub: noSub)
                }
            }
        }
        .environment(\.layoutDirection, .leftToRight)
    }
}

private struct PressReportingButtonStyle: ButtonStyle {
    @Binding var pressed: Bool
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) { _, newValue in
                pressed = newValue
            }
    }
}

struct KeypadButton: View {
    @EnvironmentObject var appState: AppState
    let digit: String
    let he: String
    let en: String
    let noSub: Bool

    @State private var pressed = false

    var body: some View {
        Button {
            appState.keyTapped(digit)
        } label: {
            VStack(spacing: 1) {
                Text(digit)
                    .font(.system(size: 36))
                    .foregroundStyle(.white)
                if !noSub {
                    VStack(spacing: 1) {
                        Text(he)
                            .font(.system(size: 9, weight: .semibold))
                            .tracking(1)
                            .foregroundStyle(.white.opacity(0.62))
                        Text(en)
                            .font(.system(size: 8, weight: .semibold))
                            .tracking(1.5)
                            .foregroundStyle(.white.opacity(0.36))
                    }
                    .frame(height: 20)
                }
            }
            .frame(width: 76, height: 76)
        }
        .background(
            Circle().fill(.ultraThinMaterial)
                .overlay(Circle().fill(pressed ? Color.white.opacity(0.34) : Color.white.opacity(0.02)))
        )
        .overlay(
            Circle().stroke(
                Color.white.opacity(digit == "0" && appState.zeroKeyPulse ? 0.55 : 0.2),
                lineWidth: 1
            )
        )
        .clipShape(Circle())
        .buttonStyle(PressReportingButtonStyle(pressed: $pressed))
        .animation(.easeInOut(duration: 0.2), value: appState.zeroKeyPulse)
    }
}
