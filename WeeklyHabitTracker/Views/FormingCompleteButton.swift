//
//  FormingCompleteButton.swift
//  WeeklyHabitTracker
//
//  Created by Robert Parsons on 7/2/20.
//  Copyright © 2020 Robert Parsons. All rights reserved.
//

import UIKit

class FormingFinishButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureButton() {
        backgroundColor = .systemGreen
        layer.cornerRadius = 10
        
        setTitle("Complete Habit", for: .normal)
        titleLabel?.textAlignment = .center
        titleLabel?.textColor = .white
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
    }
}
