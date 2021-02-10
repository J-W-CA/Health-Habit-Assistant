//
//  FormingStatStackView.swift
//  WeeklyHabitTracker
//
//  Created by Robert Parsons on 6/20/20.
//  Copyright © 2020 Robert Parsons. All rights reserved.
//

import UIKit

class FormingStatView: UIView {
    let numberLabel = UILabel()
    let titleLabel = UILabel()
    
    init(title: String, color: UIColor) {
        super.init(frame: .zero)
        
        configureNumberLabel(withBackground: color)
        configureTitleLabel(withTitle: title)
        configureConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureNumberLabel(withBackground color: UIColor) {
        numberLabel.textAlignment = .center
        numberLabel.textColor = .white
        numberLabel.font = UIFont.boldSystemFont(ofSize: 19)
        numberLabel.backgroundColor = color
        
        numberLabel.layer.masksToBounds = true
        numberLabel.layer.cornerRadius = 36 / 2
        numberLabel.clipsToBounds = true
    }
    
    func configureTitleLabel(withTitle title: String) {
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.text = title
    }
    
    func configureConstraints() {
        addSubview(titleLabel)
        titleLabel.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 5, paddingRight: 0, width: 0, height: 20)
        addSubview(numberLabel)
        numberLabel.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, x: centerXAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 3, paddingRight: 0, width: 36, height: 36)
    }
    
    func set(stat: Int64) {
        numberLabel.text = "\(stat)"
    }
}
