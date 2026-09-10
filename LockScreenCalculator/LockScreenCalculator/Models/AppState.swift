import SwiftUI
import Combine
import AVFoundation

final class AppState: ObservableObject {
    // Lock screen
    @Published var digitMode: Int = 6
    @Published var entered: String = ""
    @Published var shakeDots: Bool = false
    @Published var zeroKeyPulse: Bool = false
    @Published var emergencyPulse: Bool = false
    @Published var prependOneArmed: Bool = false
    @Published var mailBadge: Int = 0

    // Navigation
    @Published var showHomeScreen: Bool = false
    @Published var showSettings: Bool = false
    @Published var iconEditMode: Bool = false

    // Customization
    @Published var backgroundImage: UIImage?
    @Published var customIcons: [String: UIImage] = [:]
    @Published var hasTypeSound: Bool = false

    @AppStorage("lockscreen_required_attempt") var requiredAttempt: Int = 1
    @AppStorage("lockscreen_typesound_start") var typeSoundStartTime: Double = 0

    private let store = ImageStore()
    private var audioPlayer: AVAudioPlayer?

    private var attemptCount = 0
    private var savedSubtrahend: Int?
    private var deleteWorkItem: DispatchWorkItem?
    private let doubleTapWindow: TimeInterval = 0.32
    private var cancelLastTap: Date = .distantPast
    private var emergencyLastTap: Date = .distantPast
    private var headlineLastTap: Date = .distantPast

    init() {
        backgroundImage = store.loadBackground()
        customIcons = store.loadAllIcons()
        if let url = store.typeSoundURL {
            hasTypeSound = true
            audioPlayer = try? AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
        }
        try? AVAudioSession.sharedInstance().setCategory(.playback, options: [.mixWithOthers])
        try? AVAudioSession.sharedInstance().setActive(true)
    }

    // MARK: - Keypad

    func keyTapped(_ digit: String) {
        playTypeSound()
        guard entered.count < digitMode else { return }
        entered.append(digit)
        if entered.count == digitMode {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) { [weak self] in
                self?.onCodeComplete()
            }
        }
    }

    /// Earlier attempts (below the configured required-attempt number) fake a
    /// wrong-passcode shake and clear, regardless of what was actually typed —
    /// only the configured attempt computes the real result.
    private func onCodeComplete() {
        attemptCount += 1
        if attemptCount < requiredAttempt {
            shakeDots = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) { [weak self] in
                self?.shakeDots = false
                self?.entered = ""
            }
            return
        }
        attemptCount = 0
        submit()
    }

    private func submit() {
        var codeStr = entered
        if prependOneArmed {
            codeStr = "1" + entered
            prependOneArmed = false
        }
        let n = Int(codeStr) ?? 0
        let subtrahend: Int
        if let saved = savedSubtrahend {
            subtrahend = saved
            savedSubtrahend = nil
        } else {
            subtrahend = Self.currentSubtrahend()
        }
        mailBadge = n - subtrahend

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) { [weak self] in
            withAnimation(.easeInOut(duration: 0.45)) {
                self?.showHomeScreen = true
            }
        }
    }

    private static func currentSubtrahend() -> Int {
        let now = Date()
        let cal = Calendar.current
        let h = cal.component(.hour, from: now)
        let m = cal.component(.minute, from: now)
        let year = cal.component(.year, from: now)
        return h * 100 + m + year
    }

    // MARK: - Cancel button
    // Single tap deletes (after a short delay, to allow detecting a second
    // tap). Double-tap instead snapshots the current HHmm+year so the
    // calculation uses that saved moment even if the code is typed a minute
    // or two later. Confirmation pulses the "0" key.

    func cancelTapped() {
        let now = Date()
        if now.timeIntervalSince(cancelLastTap) < doubleTapWindow {
            deleteWorkItem?.cancel()
            cancelLastTap = .distantPast
            savedSubtrahend = Self.currentSubtrahend()
            zeroKeyPulse = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
                self?.zeroKeyPulse = false
            }
        } else {
            cancelLastTap = now
            let workItem = DispatchWorkItem { [weak self] in
                guard let self, !self.entered.isEmpty else { return }
                self.entered.removeLast()
            }
            deleteWorkItem = workItem
            DispatchQueue.main.asyncAfter(deadline: .now() + doubleTapWindow, execute: workItem)
        }
    }

    // MARK: - Emergency
    // Secret gesture: double-tap toggles arming a leading "1" on the next
    // completed code (4444 -> 14444), then auto-disarms after one use.

    func emergencyTapped() {
        let now = Date()
        if now.timeIntervalSince(emergencyLastTap) < doubleTapWindow {
            emergencyLastTap = .distantPast
            prependOneArmed.toggle()
            emergencyPulse = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
                self?.emergencyPulse = false
            }
        } else {
            emergencyLastTap = now
        }
    }

    // MARK: - Headline
    // Secret gesture: double-tap switches between 4 and 6 digit mode.

    func headlineTapped() {
        let now = Date()
        if now.timeIntervalSince(headlineLastTap) < doubleTapWindow {
            digitMode = digitMode == 6 ? 4 : 6
            entered = ""
            headlineLastTap = .distantPast
        } else {
            headlineLastTap = now
        }
    }

    // MARK: - Home screen

    func mailAppTapped() {
        withAnimation(.easeInOut(duration: 0.3)) {
            showHomeScreen = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.entered = ""
        }
    }

    // MARK: - Background

    func setBackground(_ image: UIImage) {
        backgroundImage = image
        store.saveBackground(image)
    }

    func removeBackground() {
        backgroundImage = nil
        store.removeBackground()
    }

    // MARK: - Icons

    func setIcon(_ image: UIImage, for id: String) {
        customIcons[id] = image
        store.saveIcon(image, for: id)
    }

    func resetAllIcons() {
        customIcons.removeAll()
        store.resetAllIcons()
    }

    // MARK: - Typing sound

    func setTypeSound(from url: URL) {
        let accessed = url.startAccessingSecurityScopedResource()
        defer { if accessed { url.stopAccessingSecurityScopedResource() } }
        store.saveTypeSound(from: url)
        if let savedURL = store.typeSoundURL {
            audioPlayer = try? AVAudioPlayer(contentsOf: savedURL)
            audioPlayer?.prepareToPlay()
            hasTypeSound = true
        }
    }

    func removeTypeSound() {
        store.removeTypeSound()
        audioPlayer = nil
        hasTypeSound = false
    }

    func previewTypeSound() {
        playTypeSound()
    }

    private func playTypeSound() {
        guard hasTypeSound, let player = audioPlayer else { return }
        player.currentTime = typeSoundStartTime
        player.play()
    }
}
