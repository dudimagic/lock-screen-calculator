import SwiftUI

struct DotsView: View {
    @EnvironmentObject var appState: AppState
    @State private var shakeOffset: CGFloat = 0

    var body: some View {
        HStack(spacing: 20) {
            ForEach(0..<appState.digitMode, id: \.self) { i in
                Circle()
                    .strokeBorder(Color.white.opacity(0.9), lineWidth: 2)
                    .background(Circle().fill(i < appState.entered.count ? Color.white : .clear))
                    .frame(width: 13, height: 13)
                    .scaleEffect(i < appState.entered.count ? 1.05 : 1)
                    .animation(.easeInOut(duration: 0.15), value: appState.entered.count)
            }
        }
        .offset(x: shakeOffset)
        .onChange(of: appState.shakeDots) { _, shaking in
            guard shaking else { return }
            runShakeSequence()
        }
    }

    /// Mimics the real iOS wrong-passcode spring shake: a sharp initial
    /// snap that decays through several oscillations.
    private func runShakeSequence() {
        let steps: [CGFloat] = [-17, 14, -12, 10, -8, 6, -4, 3, -2, 1, 0]
        var delay: Double = 0
        for step in steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeOut(duration: 0.05)) { shakeOffset = step }
            }
            delay += 0.05
        }
    }
}
