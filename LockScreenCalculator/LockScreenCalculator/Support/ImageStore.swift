import UIKit

/// Persists user-supplied images/audio to the app's Documents directory —
/// the native equivalent of the web version's localStorage data-URL cache.
final class ImageStore {
    private let fm = FileManager.default
    private var docs: URL { fm.urls(for: .documentDirectory, in: .userDomainMask)[0] }

    private var backgroundURL: URL { docs.appendingPathComponent("lock_background.jpg") }
    private func iconURL(_ id: String) -> URL { docs.appendingPathComponent("icon_\(id).jpg") }
    private var typeSoundFileURL: URL { docs.appendingPathComponent("type_sound") }

    var typeSoundURL: URL? {
        fm.fileExists(atPath: typeSoundFileURL.path) ? typeSoundFileURL : nil
    }

    func loadBackground() -> UIImage? {
        guard let data = try? Data(contentsOf: backgroundURL) else { return nil }
        return UIImage(data: data)
    }

    func saveBackground(_ image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.82) else { return }
        try? data.write(to: backgroundURL)
    }

    func removeBackground() {
        try? fm.removeItem(at: backgroundURL)
    }

    func loadAllIcons() -> [String: UIImage] {
        var result: [String: UIImage] = [:]
        for icon in AppIconCatalog.all {
            if let data = try? Data(contentsOf: iconURL(icon.id)), let image = UIImage(data: data) {
                result[icon.id] = image
            }
        }
        return result
    }

    func saveIcon(_ image: UIImage, for id: String) {
        guard let data = image.jpegData(compressionQuality: 0.85) else { return }
        try? data.write(to: iconURL(id))
    }

    func resetAllIcons() {
        for icon in AppIconCatalog.all {
            try? fm.removeItem(at: iconURL(icon.id))
        }
    }

    func saveTypeSound(from sourceURL: URL) {
        try? fm.removeItem(at: typeSoundFileURL)
        try? fm.copyItem(at: sourceURL, to: typeSoundFileURL)
    }

    func removeTypeSound() {
        try? fm.removeItem(at: typeSoundFileURL)
    }
}
