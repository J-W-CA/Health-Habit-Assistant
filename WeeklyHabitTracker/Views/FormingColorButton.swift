//
//  FormingColorButton.swift
//  WeeklyHabitTracker
//
//  Created by Jason Wang on 4/15/20.
//  Copyright © 2020 Jason Wang. All rights reserved.
//

import UIKit

class FormingColorButton: UIButton {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(color: UIColor, tag: Int, width: CGFloat) {
        super.init(frame: .zero)
        configure(color: color, tag: tag, width: width)
    }
    
    func configure(color: UIColor, tag: Int, width: CGFloat) {
        self.imageView?.tintColor = .white
        self.tag = tag
        
        backgroundColor = color
        layer.masksToBounds = true
        layer.cornerRadius = width / 2
        clipsToBounds = true
    }

}
