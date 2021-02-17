import UIKit

class LSTextField: UITextField {
    
    // MARK: Properties
    fileprivate var padding: CGFloat = 0
    
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    convenience init(text: String = "", backgroundColor: UIColor = .white, textColor: UIColor = .black, textSize: CGFloat, borderStyle: UITextField.BorderStyle = .none, padding: CGFloat = 0, placeholderText: String = "") {
        self.init()
        self.text = text
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.font = UIFont(name: "AvenirNext-Regular", size: textSize)
        self.borderStyle = borderStyle
        self.padding = padding
        self.placeholder = placeholderText
    }
    
    
    required init?(coder: NSCoder) { fatalError() }

    
    // MARK: Overridden Methods
    override func editingRect(forBounds bounds: CGRect) -> CGRect { return bounds.insetBy(dx: padding, dy: 0) }
    
    
    override func textRect(forBounds bounds: CGRect) -> CGRect { return bounds.insetBy(dx: padding, dy: 0) }
}
