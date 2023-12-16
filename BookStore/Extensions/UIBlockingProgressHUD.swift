import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    private static var window: UIWindow? {
        let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let firstWindow = firstScene?.windows.first
        return firstWindow
    }

    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.colorAnimation = .black
        ProgressHUD.animationType = .dualDotSidestep
        ProgressHUD.animate()
    }

    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
