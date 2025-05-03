import SwiftUI
import UIKit

struct KeyboardListenerView: UIViewRepresentable {
    var onKeyPressed: (Direction) -> Void
    var onKeyReleased: () -> Void

    func makeUIView(context: Context) -> KeyboardUIView {
        let view = KeyboardUIView()
        view.onKeyPressed = onKeyPressed
        view.onKeyReleased = onKeyReleased
        return view
    }

    func updateUIView(_ uiView: KeyboardUIView, context: Context) {}
}

class KeyboardUIView: UIView {
    var onKeyPressed: ((Direction) -> Void)?
    var onKeyReleased: (() -> Void)?

    override var canBecomeFirstResponder: Bool { true }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        becomeFirstResponder()
    }

    override var keyCommands: [UIKeyCommand]? {
        return [
            UIKeyCommand(input: UIKeyCommand.inputUpArrow, modifierFlags: [], action: #selector(up)),
            UIKeyCommand(input: UIKeyCommand.inputDownArrow, modifierFlags: [], action: #selector(down)),
            UIKeyCommand(input: UIKeyCommand.inputLeftArrow, modifierFlags: [], action: #selector(left)),
            UIKeyCommand(input: UIKeyCommand.inputRightArrow, modifierFlags: [], action: #selector(right))
        ]
    }


    // Tuşa basıldığında
    @objc func up() { onKeyPressed?(.up) }
    @objc func down() { onKeyPressed?(.down) }
    @objc func left() { onKeyPressed?(.left) }
    @objc func right() { onKeyPressed?(.right) }

    //  Tuş bırakıldığında
    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        super.pressesEnded(presses, with: event)
        onKeyReleased?()
    }
}
