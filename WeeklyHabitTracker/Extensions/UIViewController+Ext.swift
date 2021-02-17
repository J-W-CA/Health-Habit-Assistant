import UIKit

extension UIViewController {
    
    func showEmptyStateView(image: UIImage, with message: String, in view: UIView) {
        let emptyStateView = LSEmptyStateView(image: image, message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
    
    
    func presentAlertOnMainTread(title: String, message: String, buttonTitle: String, action: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alertVC = LSAlertVC(title: title, message: message, buttonTitle: buttonTitle, action: action)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    
    func presentConfirmAlertOnMainTread(title: String, message: String, cancelButtonTitle: String, actionButtonTitle: String, cancel: (() -> Void)? = nil, action: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alertVC = LSConfirmAlertVC(title: title, message: message, cancelButtonTitle: cancelButtonTitle, actionButtonTitle: actionButtonTitle, cancel: cancel, action: action)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true, completion: nil)
        }
    }
}

