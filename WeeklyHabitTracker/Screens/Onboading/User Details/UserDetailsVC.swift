import UIKit

class UserDetailsVC: UIViewController {

    // MARK: Properties
    private let heroImageContainer = UIView()
    private let detailsContainer = UIView()
    private let circleImageView = LSImageView(image: Asserts.circle)
    private let heroImageView = LSImageView(image: Asserts.personOnScooter)
    
    private let nextButton = LSButton(backgroundColor: AppColor.lightBlack, title: Strings.continueString, titleColor: .white, radius: GlobalDimensions.cornerRadius)
    private let backButton = LSButton(backgroundColor: AppColor.darkestAsh, title: Strings.back, titleColor: UIColor.appColor(color: .lightAsh), radius: GlobalDimensions.cornerRadius)
    
    private let questionLabel = LSBodyLabel(text: Strings.nameQuestion, textColor: .white, fontSize: 25, textAlignment: .left, numberOfLines: 2)
    private let placeholderLabel = LSBodyLabel(text: Strings.enterYourName, textColor: AppColor.lightAsh, fontSize: 16, textAlignment: .left)
    private let nameTextField = LSTextField(backgroundColor: AppColor.darkestAsh, textColor: .white, textSize: 20, padding: 15)

    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotifications()
        setupUI()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}


// MARK: - Objc Methods
private extension UserDetailsVC {
    
    @objc func handleNext() {
        guard let name = nameTextField.text, !name.isEmpty else { return }
        DataStore.shared.setUserStatus(isExistingUser: true)
        UIApplication.shared.windows.first?.rootViewController = MainTabBarController()
    }
    
    
    @objc func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    
    @objc func handleKeyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
    }
    
    
    @objc func handleKeyboardShow(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        let bottomSpace = view.frame.height - nameTextField.frame.origin.y - nameTextField.frame.height
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: (difference))
    }
}


// MARK: - Methods
private extension UserDetailsVC {
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    func setupUI() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        
        heroImageContainer.backgroundColor = UIColor.appColor(color: .lighestGreen)
        detailsContainer.backgroundColor = UIColor.appColor(color: .darkestAsh)
        
        view.addSubviews(heroImageContainer, detailsContainer)
        heroImageContainer.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.centerYAnchor, trailing: view.trailingAnchor)
        detailsContainer.anchor(top: view.centerYAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        heroImageContainer.addSubviews(circleImageView, heroImageView)
        circleImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, size: .init(width: 35, height: 35))
        circleImageView.centerHorizontallyInSuperView()
        heroImageView.anchor(top: circleImageView.bottomAnchor, leading: view.leadingAnchor, bottom: heroImageContainer.bottomAnchor, trailing: view.trailingAnchor)
        
        nameTextField.setHeight(GlobalDimensions.height)
        nameTextField.setRoundedBorder(borderColor: UIColor.appColor(color: .lightAsh), borderWidth: GlobalDimensions.borderWidth, radius: GlobalDimensions.cornerRadius)
        
        let questionStackView = UIStackView(arrangedSubviews: [questionLabel, placeholderLabel, nameTextField])
        questionStackView.axis = .vertical
        questionStackView.spacing = 10
        questionStackView.setCustomSpacing(20, after: placeholderLabel)
        detailsContainer.addSubview(questionStackView)
        questionStackView.anchor(top: detailsContainer.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 20, left: 30, bottom: 0, right: 30))
        
        detailsContainer.addSubviews(nextButton, backButton)
        nextButton.anchor(top: nil, leading: view.centerXAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 10, right: 20), size: .init(width: 0, height: GlobalDimensions.height))
        backButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 10, bottom: 10, right: 0), size: .init(width: 100, height: GlobalDimensions.height))
    }
}
