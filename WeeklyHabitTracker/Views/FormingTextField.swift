//
//  FormingTextField.swift
//  WeeklyHabitTracker
//
//  Created by Jason Wang on 4/15/20.
//  Copyright © 2020 Jason Wang. All rights reserved.
//

import UIKit

class FormingTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(placeholder: String, textAlignment: NSTextAlignment = .center, keyboardType: UIKeyboardType = .default, returnKeyType: UIReturnKeyType) {
        super.init(frame: .zero)
        self.returnKeyType = returnKeyType
        self.placeholder = placeholder
        self.textAlignment = textAlignment
        self.keyboardType = keyboardType
        configure()
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 10
        layer.borderWidth = 0
        
        textColor = .label
        tintColor = .label
        font = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12

        backgroundColor = .tertiarySystemFill
        autocapitalizationType = .words
        autocorrectionType = .default
    }

}
