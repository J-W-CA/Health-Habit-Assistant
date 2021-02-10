//
//  FormingStatStackView.swift
//  WeeklyHabitTracker
//
//  Created by Jason Wang on 6/20/20.
//  Copyright © 2020 Jason Wang. All rights reserved.
//

import UIKit

class FormingStatView: UIView {
    let numberLabel = UILabel()
    let titleLabel = UILabel()
    
    init(title: String, color: UIColor) {
        super.init(frame: .zero)
        
        configureNumberLabel(withBackground: color, andTitle: title)
        configureTitleLabel(withTitle: title)
        configureConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureNumberLabel(withBackground color: UIColor, andTitle title: String) {
        numberLabel.textAlignment = .center
        numberLabel.font = UIFont.boldSystemFont(ofSize: 20)
        numberLabel.backgroundColor = color
        
        numberLabel.layer.masksToBounds = true
        numberLabel.layer.cornerRadius = 40 / 2
        numberLabel.clipsToBounds = true
    }
    
    func configureTitleLabel(withTitle title: String) {
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.text = title
    }
    
    func configureConstraints() {
        addSubview(numberLabel)
        numberLabel.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, x: centerXAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        addSubview(titleLabel)
        titleLabel.anchor(top: numberLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 3, paddingLeft: 0, paddingBottom: 5, paddingRight: 0, width: 0, height: 20)
    }
    
    func set(stat: Int64) {
        if stat >= 100 {
            numberLabel.font = UIFont.boldSystemFont(ofSize: 16)
        }
        numberLabel.text = "\(stat)"
    }
}
