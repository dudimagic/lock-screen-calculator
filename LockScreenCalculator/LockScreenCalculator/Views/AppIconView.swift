import SwiftUI
import PhotosUI

struct AppIconView: View {
    @EnvironmentObject var appState: AppState
    let icon: AppIconData
    var isDock: Bool = false

    @State private var photoSelection: PhotosPickerItem?

    private var size: CGFloat { isDock ? 62 : 66 }

    var body: some View {
        VStack(spacing: 6) {
            ZStack(alignment: .topTrailing) {
                if appState.iconEditMode {
                    PhotosPicker(selection: $photoSelection, matching: .images) {
                        iconFace
                    }
                } else {
                    iconFace
                }

                if icon.isMail {
                    Text("\(appState.mailBadge)")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 6)
                        .frame(minWidth: 25, minHeight: 25)
                        .background(Color(hex: "ff3b30"), in: Capsule())
                        .overlay(Capsule().stroke(Color.black.opacity(0.12), lineWidth: 2))
                        .offset(x: 10, y: -8)
                }
            }
            if !isDock {
                Text(icon.label)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.white)
                    .lineLimit(1)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            guard !appState.iconEditMode, icon.isMail else { return }
            appState.mailAppTapped()
        }
        .onChange(of: photoSelection) { _, item in
            guard let item else { return }
            Task {
                if let data = try? await item.loadTransferable(type: Data.self), let image = UIImage(data: data) {
                    appState.setIcon(image, for: icon.id)
                }
                photoSelection = nil
            }
        }
    }

    @ViewBuilder
    private var iconFace: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(LinearGradient(colors: icon.gradientColors, startPoint: .topLeading, endPoint: .bottomTrailing))

            if let custom = appState.customIcons[icon.id] {
                Image(uiImage: custom)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
                    .clipped()
            } else if icon.id == "calendar" {
                CalendarIconView(size: size)
            } else {
                Image(systemName: icon.symbolName)
                    .font(.system(size: size * 0.42))
                    .foregroundStyle(icon.symbolColor)
            }

            RoundedRectangle(cornerRadius: 15)
                .fill(LinearGradient(colors: [.white.opacity(0.32), .clear, .black.opacity(0.1)], startPoint: .top, endPoint: .bottom))
                .allowsHitTesting(false)
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: .black.opacity(0.35), radius: 4, y: 2)
    }
}
