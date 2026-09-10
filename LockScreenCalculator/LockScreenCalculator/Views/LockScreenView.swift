import SwiftUI

struct LockScreenView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 26) {
            Spacer(minLength: 0)

            Text("יש להזין את קוד הגישה")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)
                .environment(\.layoutDirection, .rightToLeft)
                .contentShape(Rectangle())
                .onTapGesture { appState.headlineTapped() }

            DotsView()

            KeypadView()

            HStack {
                HStack(spacing: 2) {
                    Text("שיחת חירום")
                    if appState.prependOneArmed {
                        Text(".")
                    }
                }
                .foregroundStyle(.white.opacity(appState.emergencyPulse ? 1 : 0.92))
                .contentShape(Rectangle())
                .onTapGesture { appState.emergencyTapped() }

                Spacer()

                Text("ביטול")
                    .foregroundStyle(.white)
                    .contentShape(Rectangle())
                    .onTapGesture { appState.cancelTapped() }
            }
            .font(.system(size: 17, weight: .medium))
            .frame(maxWidth: 280)
            .padding(.horizontal, 10)
            .padding(.bottom, 6)
            .environment(\.layoutDirection, .leftToRight)
        }
        .padding(.top, 14)
        .padding(.bottom, 112)
    }
}
