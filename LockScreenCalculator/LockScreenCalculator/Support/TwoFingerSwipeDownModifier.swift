import SwiftUI
import UIKit

/// Secret gesture: a two-finger swipe down anywhere opens the background
/// settings sheet. SwiftUI has no built-in multi-touch gesture, so this
/// bridges a UIPanGestureRecognizer configured for exactly two touches.
struct TwoFingerSwipeDownModifier: ViewModifier {
    let action: () -> Void

    func body(content: Content) -> some View {
        content.background(TwoFingerSwipeDownView(action: action))
    }
}

private struct TwoFingerSwipeDownView: UIViewRepresentable {
    let action: () -> Void

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        let recognizer = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePan(_:)))
        recognizer.minimumNumberOfTouches = 2
        recognizer.maximumNumberOfTouches = 2
        view.addGestureRecognizer(recognizer)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(action: action)
    }

    final class Coordinator: NSObject {
        let action: () -> Void
        private var triggered = false

        init(action: @escaping () -> Void) {
            self.action = action
        }

        @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
            switch recognizer.state {
            case .began:
                triggered = false
            case .changed:
                guard !triggered else { return }
                let translation = recognizer.translation(in: recognizer.view)
                if translation.y > 70 {
                    triggered = true
                    action()
                }
            default:
                break
            }
        }
    }
}
