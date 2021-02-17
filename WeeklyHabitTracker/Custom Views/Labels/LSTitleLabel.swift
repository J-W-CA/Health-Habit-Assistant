import UIKit

class LSTitleLabel: UILabel {

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) { fatalError() }

    
    convenience init(text: String = "", textColor: UIColor = .black, fontSize: CGFloat = 18, textAlignment: NSTextAlignment = .center, numberOfLines: Int = 1) {
        self.init(frame: .zero)
        
        let traits = [UIFontDescriptor.TraitKey.weight: UIFont.Weight.bold]
        var descriptor = UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.family: Fonts.avenirNext])
        descriptor = descriptor.addingAttributes([UIFontDescriptor.AttributeName.traits: traits])
        
        self.text = text
        self.textColor = textColor
        self.font = UIFont(descriptor: descriptor, size: fontSize)
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
    }
}


// MARK: - Private Methods
extension LSTitleLabel {
    
    private func configure() {
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        lineBreakMode = .byTruncatingTail
    }
}
