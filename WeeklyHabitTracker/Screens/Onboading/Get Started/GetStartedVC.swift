import UIKit

class GetStartedVC: UIViewController {
    
    // MARK: Properties
    private let circleImageView = LSImageView(image: Asserts.circle)
    private let heroImageView = LSImageView(image: Asserts.personOnBicycle)
    private let titleLabel = LSTitleLabel(textColor: AppColor.lightBlack, numberOfLines: 2)
    private let descriptionLabel = LSBodyLabel(text: Strings.areYouReady, textColor: AppColor.greenishBlue, numberOfLines: 3)
    private let callToActionButton = LSButton(backgroundColor: AppColor.lightBlack, title: Strings.continueString, titleColor: .white, radius: GlobalDimensions.cornerRadius)

    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}


// MARK: - Methods
private extension GetStartedVC {
    
    @objc func handleCallToAction() {
        let controller = UserDetailsVC()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    func setupUI() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor.appColor(color: .lighestGreen)
        
        view.addSubviews(circleImageView, heroImageView, titleLabel, descriptionLabel, callToActionButton)
        circleImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, size: .init(width: 35, height: 35))
        circleImageView.centerHorizontallyInSuperView()
        
        heroImageView.anchor(top: circleImageView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: view.frame.height / 2))
        
        titleLabel.attributedText = NSMutableAttributedString().normal(Strings.itsTimeToBuild, 40).bold(Strings.someHabits, 40)
        titleLabel.anchor(top: heroImageView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 20))
        
        descriptionLabel.anchor(top: titleLabel.bottomAnchor, leading: titleLabel.leadingAnchor, bottom: nil, trailing: titleLabel.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0))
        
        callToActionButton.addTarget(self, action: #selector(handleCallToAction), for: .touchUpInside)
        callToActionButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 10, right: 20), size: .init(width: 0, height: GlobalDimensions.height))
    }
}
