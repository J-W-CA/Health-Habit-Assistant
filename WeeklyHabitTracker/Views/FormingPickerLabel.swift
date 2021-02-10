//
//  FormingPickerLabel.swift
//  WeeklyHabitTracker
//
//  Created by Jason Wang on 4/22/20.
//  Copyright © 2020 Jason Wang. All rights reserved.
//

import UIKit

class FormingPickerLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        layer.cornerRadius = 10
        layer.borderWidth = 0
        clipsToBounds = true
        
        textColor = .label
        tintColor = .label
        textAlignment = .center
        font = UIFont.preferredFont(forTextStyle: .headline)
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 12
        
        backgroundColor = .tertiarySystemFill
    }
}
