import UIKit

class LSConfirmAlertVC: UIViewController {
    
    // MARK: Properties
    private let containerView = LSAlertContainerView()
    private let titleLabel = LSTitleLabel(fontSize: 20, textAlignment: .center, numberOfLines: 0)
    private let messageLabel = LSBodyLabel(textAlignment: .center)
    private let cancelButton = LSButton(backgroundColor: UIColor.appColor(color: .lightBlack), titleColor: .white, radius: GlobalDimensions.cornerRadius)
    private let actionButton = LSButton(backgroundColor: UIColor.appColor(color: .pinkishRed), titleColor: .white, radius: GlobalDimensions.cornerRadius)
    
    private var alertTitle: String?
    private var message: String?
    private var cancelButtonTitle: String?
    private var actionButtonTitle: String?
    private let padding: CGFloat = 20
    private var cancel: (() -> Void)? = nil
    private var action: (() -> Void)? = nil
    
    
    // MARK: Initializers
    init(title: String, message: String, cancelButtonTitle: String, actionButtonTitle: String, cancel: (() -> Void)? = nil, action: (() -> Void)? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = title
        self.message = message
        self.cancelButtonTitle = cancelButtonTitle
        self.actionButtonTitle = actionButtonTitle
        self.cancel = cancel
        self.action = action
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
    
    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

// MARK: - Objc Methods
private extension LSConfirmAlertVC {
    
    @objc func cancelTapped() {
        dismiss(animated: true, completion: cancel)
    }
    
    
    @objc func actionTapped() {
        dismiss(animated: true, completion: action)
    }
}


// MARK: - Private Methods
private extension LSConfirmAlertVC {
    
    func configureUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        titleLabel.text = alertTitle ?? Strings.somethingWentWrong
        
        cancelButton.setTitle(cancelButtonTitle ?? Strings.cancel, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        actionButton.setTitle(actionButtonTitle ?? Strings.delete, for: .normal)
        actionButton.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)
        
        messageLabel.text = message ?? Strings.unableToCompleteRequest
        messageLabel.numberOfLines = 4
        
        
        let buttonStackView = UIStackView(arrangedSubviews: [cancelButton, actionButton])
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 20

        view.addSubviews(containerView, titleLabel, messageLabel, buttonStackView)
        
        containerView.centerInSuperview(size: .init(width: 280, height: 230))
        titleLabel.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor, padding: .init(top: padding, left: padding, bottom: 0, right: padding))
        buttonStackView.anchor(top: nil, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, trailing: containerView.trailingAnchor, padding: .init(top: 0, left: padding, bottom: padding, right: padding), size: .init(width: 0, height: GlobalDimensions.height))
        messageLabel.anchor(top: titleLabel.bottomAnchor, leading: containerView.leadingAnchor, bottom: buttonStackView.topAnchor, trailing: containerView.trailingAnchor, padding: .init(top: 8, left: padding, bottom: 12, right: padding))
    }
}
