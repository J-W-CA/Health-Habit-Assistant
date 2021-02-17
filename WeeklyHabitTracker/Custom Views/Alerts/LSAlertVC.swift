import UIKit

class LSAlertVC: UIViewController {
    
    // MARK: Properties
    private let containerView = LSAlertContainerView()
    private let titleLabel = LSTitleLabel(fontSize: 20, textAlignment: .center)
    private let messageLabel = LSBodyLabel(textAlignment: .center)
    private let actionButton = LSButton(backgroundColor: UIColor.appColor(color: .lightBlack), titleColor: .white, radius: GlobalDimensions.cornerRadius)
    
    private var alertTitle: String?
    private var message: String?
    private var buttonTitle: String?
    private let padding: CGFloat = 20
    private var action: (() -> Void)? = nil
    
    
    // MARK: Initializers
    init(title: String, message: String, buttonTitle: String, action: (() -> Void)? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.action = action
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
    
    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}


// MARK: - Private Methods
private extension LSAlertVC {
    
    @objc func dismissAlert() {
        dismiss(animated: true, completion: action)
    }
    
    
    func configureUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        titleLabel.text = alertTitle ?? Strings.somethingWentWrong
        actionButton.setTitle(buttonTitle ?? Strings.ok, for: .normal)
        actionButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        messageLabel.text = message ?? Strings.unableToCompleteRequest
        messageLabel.numberOfLines = 4

        view.addSubviews(containerView, titleLabel, messageLabel, actionButton)
        
        containerView.centerInSuperview(size: .init(width: 280, height: 230))
        titleLabel.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor, padding: .init(top: padding, left: padding, bottom: 0, right: padding), size: .init(width: 0, height: 28))
        actionButton.anchor(top: nil, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, trailing: containerView.trailingAnchor, padding: .init(top: 0, left: padding, bottom: padding, right: padding), size: .init(width: 0, height: GlobalDimensions.height))
        messageLabel.anchor(top: titleLabel.bottomAnchor, leading: containerView.leadingAnchor, bottom: actionButton.topAnchor, trailing: containerView.trailingAnchor, padding: .init(top: 8, left: padding, bottom: 12, right: padding))
    }
}
