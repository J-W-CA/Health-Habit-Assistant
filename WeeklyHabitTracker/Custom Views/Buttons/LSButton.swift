import UIKit

class LSButton: UIButton {

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder: NSCoder) {  fatalError() }
    
    
    convenience init(backgroundColor: UIColor = .white, title: String = "", titleColor: UIColor = .black, radius: CGFloat = 0, fontSize: CGFloat = 16) {
        self.init(frame: .zero)
        
        let traits = [UIFontDescriptor.TraitKey.weight: UIFont.Weight.regular]
        var descriptor = UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.family: Fonts.avenirNext])
        descriptor = descriptor.addingAttributes([UIFontDescriptor.AttributeName.traits: traits])
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        self.imageView?.contentMode = .scaleAspectFill
        self.titleLabel?.font = UIFont(descriptor: descriptor, size: fontSize)
    }
}
