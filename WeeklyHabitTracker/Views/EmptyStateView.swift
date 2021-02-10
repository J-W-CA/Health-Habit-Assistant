//
//  EmptyStateViewController.swift
//  WeeklyHabitTracker
//
//  Created by Jason Wang on 4/28/20.
//  Copyright © 2020 Jason Wang. All rights reserved.
//

import UIKit

class EmptyStateView: UIView {
    var label = UILabel()
    
    init(message: String? = nil, frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        if let text = message { configureLabel(withText: text) }
        else { configureLabel() }
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLabel(withText message: String? = nil) {
        if let text = message {
            label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            label.textColor = .secondaryLabel
            label.numberOfLines = 0
            label.text = text
        } else {
            let config = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 17, weight: .semibold), scale: .medium)
            let symbolAttachment = NSTextAttachment()
            symbolAttachment.image = UIImage(named: "plus", in: nil, with: config)
            symbolAttachment.image = symbolAttachment.image?.withTintColor(.secondaryLabel)
            let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 17, weight: .semibold), .foregroundColor: UIColor.secondaryLabel]
            let title = NSMutableAttributedString(string: "Press the ", attributes: attributes)
            title.append(NSAttributedString(attachment: symbolAttachment))
            title.append(NSAttributedString(string: " to add a new habit.", attributes: attributes))
            label.attributedText = title
        }

        label.textAlignment = .center
        label.backgroundColor = .systemBackground
    }
    
    func configureConstraints() {
        addSubview(label)
        label.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 200, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 200)
    }
}
