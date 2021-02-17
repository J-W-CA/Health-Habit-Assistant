import UIKit

class LSEmptyStateView: UIView {

    // MARK: Properties
    private let messageLabel = LSTitleLabel(textColor: AppColor.lightAsh, fontSize: 28, textAlignment: .center, numberOfLines: 3)
    private let logoImageView = LSImageView(contentMode: .scaleAspectFit)
    
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    convenience init(image: UIImage, message: String) {
        self.init(frame: .zero)
        logoImageView.image = image
        messageLabel.text = message
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
}


// MARK: - Private Methods
private extension LSEmptyStateView {
    
    func setupUI() {
        let imageDimensions: CGFloat = self.frame.width * 1.3
        addSubviews(messageLabel, logoImageView)

        messageLabel.centerVerticallyInSuperView(padding: -40)
        messageLabel.anchor(top: nil, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 0, left: 15, bottom: 0, right: 15))
        logoImageView.centerHorizontallyInSuperView(padding: 20)
        logoImageView.anchor(top: nil, leading: nil, bottom: self.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 60, right: 0), size: .init(width: imageDimensions, height: imageDimensions))
    }
}
