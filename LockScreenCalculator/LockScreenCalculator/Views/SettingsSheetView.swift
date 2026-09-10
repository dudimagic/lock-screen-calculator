import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

struct SettingsSheetView: View {
    @EnvironmentObject var appState: AppState
    @State private var bgSelection: PhotosPickerItem?
    @State private var showSoundImporter = false
    @State private var showResetConfirm = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.55)
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture { appState.showSettings = false }

            ScrollView {
                VStack(spacing: 14) {
                    Text("Lock Screen Background").font(.system(size: 16, weight: .bold)).foregroundStyle(.white)

                    Group {
                        if let bg = appState.backgroundImage {
                            Image(uiImage: bg).resizable().aspectRatio(contentMode: .fill)
                        } else {
                            Text("No custom image set")
                                .font(.system(size: 13))
                                .foregroundStyle(.white.opacity(0.36))
                                .multilineTextAlignment(.center)
                                .padding(12)
                        }
                    }
                    .frame(height: 140)
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.06))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.14)))
                    .clipped()

                    PhotosPicker(selection: $bgSelection, matching: .images) {
                        label("Choose Photo")
                    }

                    Button { appState.removeBackground() } label: {
                        label("Remove Background", ghost: true)
                    }

                    Button {
                        appState.showSettings = false
                        appState.iconEditMode = true
                    } label: {
                        label("Customize App Icons", ghost: true)
                    }

                    Button { showResetConfirm = true } label: {
                        label("Reset All Icons", ghost: true)
                    }

                    Text("Unlock on Attempt #").font(.system(size: 16, weight: .bold)).foregroundStyle(.white)

                    HStack(spacing: 8) {
                        ForEach(1...5, id: \.self) { n in
                            Button {
                                appState.requiredAttempt = n
                            } label: {
                                Text("\(n)")
                                    .font(.system(size: 15, weight: .semibold))
                                    .frame(width: 36, height: 36)
                                    .background(appState.requiredAttempt == n ? Color(hex: "8f9dff") : Color.white.opacity(0.16))
                                    .foregroundStyle(.white)
                                    .clipShape(Circle())
                            }
                        }
                    }

                    Text("Typing Sound").font(.system(size: 16, weight: .bold)).foregroundStyle(.white)

                    Button { showSoundImporter = true } label: {
                        label(appState.hasTypeSound ? "Sound Loaded — Choose Different File" : "Choose Sound File")
                    }
                    .fileImporter(isPresented: $showSoundImporter, allowedContentTypes: [.audio]) { result in
                        if case .success(let url) = result {
                            appState.setTypeSound(from: url)
                        }
                    }

                    HStack {
                        Text("Start at (seconds)")
                            .font(.system(size: 13))
                            .foregroundStyle(.white.opacity(0.62))
                        Spacer()
                        TextField("0", value: $appState.typeSoundStartTime, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .padding(8)
                            .frame(width: 72)
                            .background(Color.white.opacity(0.16))
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                    Button { appState.previewTypeSound() } label: {
                        label("Preview", ghost: true)
                    }

                    Button { appState.removeTypeSound() } label: {
                        label("Remove Typing Sound", ghost: true)
                    }

                    Button { appState.showSettings = false } label: {
                        label("Close", ghost: true)
                    }
                }
                .padding(22)
            }
            .background(Color(hex: "1c161a").opacity(0.92))
            .clipShape(RoundedRectangle(cornerRadius: 22))
            .overlay(RoundedRectangle(cornerRadius: 22).stroke(Color.white.opacity(0.14)))
            .frame(maxWidth: 320)
            .frame(maxHeight: 600)
        }
        .onChange(of: bgSelection) { _, item in
            guard let item else { return }
            Task {
                if let data = try? await item.loadTransferable(type: Data.self), let image = UIImage(data: data) {
                    appState.setBackground(image)
                }
                bgSelection = nil
            }
        }
        .alert("Reset all custom app icon pictures back to the defaults?", isPresented: $showResetConfirm) {
            Button("Cancel", role: .cancel) {}
            Button("Reset", role: .destructive) { appState.resetAllIcons() }
        } message: {
            Text("This can't be undone.")
        }
    }

    private func label(_ text: String, ghost: Bool = false) -> some View {
        Text(text)
            .font(.system(size: 15, weight: .semibold))
            .foregroundStyle(ghost ? .white.opacity(0.62) : .white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(ghost ? Color.clear : Color.white.opacity(0.16))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(ghost ? Color.clear : Color.white.opacity(0.14)))
    }
}
