//
//  FormingDayButton.swift
//  WeeklyHabitTracker
//
//  Created by Jason Wang on 4/16/20.
//  Copyright © 2020 Jason Wang. All rights reserved.
//

import UIKit

class FormingDayButton: UIButton {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String, tag: Int, width: CGFloat) {
        super.init(frame: .zero)
        configure(title: title, tag: tag, width: width)
    }
    
    func configure(title: String, tag: Int, width: CGFloat) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(.label, for: .normal)
        self.tag = tag
        
        layer.masksToBounds = true
        layer.cornerRadius = width / 2
        clipsToBounds = true
    }
    
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: forState)
    }
}
