//
//  EmptyStateViewController.swift
//  WeeklyHabitTracker
//
//  Created by Robert Parsons on 4/28/20.
//  Copyright © 2020 Robert Parsons. All rights reserved.
//

import UIKit

class EmptyStateView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemPurple
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
