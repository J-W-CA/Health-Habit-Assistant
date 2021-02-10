//
//  FormingSecondaryLabel.swift
//  WeeklyHabitTracker
//
//  Created by Jason Wang on 7/2/20.
//  Copyright © 2020 Jason Wang. All rights reserved.
//

import UIKit

class FormingSecondaryLabel: UILabel {

    init(text: String) {
        super.init(frame: .zero)
        
        configureLabel()
        set(text: text)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(text: String) {
        self.text = text
    }
    
    func configureLabel() {
        self.text = text
        self.textAlignment = .center
        self.numberOfLines = 0
        
        self.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        self.textColor = .secondaryLabel
    }
}
