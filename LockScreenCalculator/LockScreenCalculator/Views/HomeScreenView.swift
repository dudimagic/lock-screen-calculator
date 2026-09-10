import SwiftUI

struct HomeScreenView: View {
    @EnvironmentObject var appState: AppState

    private let columns = Array(repeating: GridItem(.flexible()), count: 4)

    var body: some View {
        VStack(spacing: 0) {
            if appState.iconEditMode {
                Text("Tap an icon to replace its picture · Tap here when done")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(Color.black.opacity(0.55), in: RoundedRectangle(cornerRadius: 14))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.18)))
                    .padding(.top, 10)
                    .contentShape(Rectangle())
                    .onTapGesture { appState.iconEditMode = false }
                    .transition(.opacity)
            }

            LazyVGrid(columns: columns, spacing: 22) {
                ForEach(AppIconCatalog.grid) { icon in
                    AppIconView(icon: icon)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 22)
            .environment(\.layoutDirection, .leftToRight)

            Spacer(minLength: 0)

            HStack(spacing: 7) {
                ForEach(0..<9, id: \.self) { i in
                    Circle()
                        .fill(i == 8 ? Color.white.opacity(0.95) : Color.white.opacity(0.4))
                        .frame(width: 6, height: 6)
                }
            }
            .padding(.vertical, 10)

            HStack {
                ForEach(AppIconCatalog.dock) { icon in
                    AppIconView(icon: icon, isDock: true)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(12)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 32))
            .overlay(RoundedRectangle(cornerRadius: 32).stroke(Color.white.opacity(0.16)))
            .padding(.horizontal, 16)
            .environment(\.layoutDirection, .leftToRight)
        }
        .padding(.bottom, 4)
        .animation(.easeInOut(duration: 0.2), value: appState.iconEditMode)
    }
}
