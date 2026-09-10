import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            LockScreenBackground()
                .overlay {
                    if let bg = appState.backgroundImage {
                        Image(uiImage: bg)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .overlay(Color.black.opacity(0.32))
                    }
                }
                .ignoresSafeArea()

            LockScreenView()
                .opacity(appState.showHomeScreen ? 0 : 1)
                .scaleEffect(appState.showHomeScreen ? 1.08 : 1)
                .allowsHitTesting(!appState.showHomeScreen)
                .animation(.easeInOut(duration: 0.4), value: appState.showHomeScreen)

            HomeScreenView()
                .opacity(appState.showHomeScreen ? 1 : 0)
                .scaleEffect(appState.showHomeScreen ? 1 : 0.9)
                .allowsHitTesting(appState.showHomeScreen)
                .animation(.easeInOut(duration: 0.45), value: appState.showHomeScreen)

            if appState.showSettings {
                SettingsSheetView()
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.25), value: appState.showSettings)
            }
        }
        .modifier(TwoFingerSwipeDownModifier {
            appState.showSettings = true
        })
        .statusBarHidden(true)
        .persistentSystemOverlays(.hidden)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
