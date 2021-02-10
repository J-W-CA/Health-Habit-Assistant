//
//  HistorySectionHeader.swift
//  WeeklyHabitTracker
//
//  Created by Jason Wang on 6/13/20.
//  Copyright © 2020 Jason Wang. All rights reserved.
//

import UIKit

class HistorySectionHeader: UICollectionViewCell {
    private let label = UILabel()
    private let collapseButton = UIButton()
    private var delegate: CollapsibleHeaderDelegate!
    private var section: HistorySection!
    private var habitCount: Int?
    private var notificationCenter: NotificationCenter!
    private let selectionGenerator = UISelectionFeedbackGenerator()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLabel()
        configureCollapseButton()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setters
    func set(title: String, andCount count: Int) {
        self.habitCount = count
        self.label.text = "\(count) \(title)"
    }
    
    func set(delegate: CollapsibleHeaderDelegate) {
        self.delegate = delegate
    }
    
    func set(section: HistorySection) {
        self.section = section
    }
    
    func set(buttonState collapse: Bool) {
        self.collapseButton.isSelected = collapse
        transform(collapse: collapse)
    }
    
    func set(notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
        self.notificationCenter.addObserver(self, selector: #selector(isSearching), name: NSNotification.Name(NotificationName.historyStartedSearching.rawValue), object: nil)
        self.notificationCenter.addObserver(self, selector: #selector(stoppedSearching), name: NSNotification.Name(NotificationName.historyStoppedSearching.rawValue), object: nil)
    }
    
    // MARK: - Configuration Functions
    func configureLabel() {
        label.textColor = .label
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    func configureCollapseButton() {
        collapseButton.setImage(UIImage(named: "chevron.down"), for: .normal)
        collapseButton.imageView?.tintColor = .label
        collapseButton.addTarget(self, action: #selector(collapseButtonTapped), for: .touchUpInside)
    }
    
    func configureConstraints() {
        addSubview(label)
        label.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        addSubview(collapseButton)
        collapseButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 35, height: 35)
    }
    
    // MARK: - Functions
    func transform(collapse: Bool) {
        if collapse {
            self.collapseButton.transform = CGAffineTransform(rotationAngle: -1.5708)
        } else {
            self.collapseButton.transform = CGAffineTransform(rotationAngle: 0)
        }
    }
    
    // MARK: - Selectors
    @objc func collapseButtonTapped(sender: UIButton) {
        self.selectionGenerator.selectionChanged()
        if sender.isSelected {
            sender.isSelected = false
            UIView.animate(withDuration: 0.25) {
                self.transform(collapse: false)
            }
            self.delegate.collapseOrExpand(action: sender.isSelected, atSection: self.section)
        } else {
            sender.isSelected = true
            UIView.animate(withDuration: 0.25) {
                self.transform(collapse: true)
            }
            self.delegate.collapseOrExpand(action: sender.isSelected, atSection: self.section)
        }
    }
    
    @objc func isSearching() {
        self.collapseButton.isEnabled = false
        collapseButton.imageView?.tintColor = .systemBackground
    }
    
    @objc func stoppedSearching() {
        self.collapseButton.isEnabled = true
        collapseButton.imageView?.tintColor = .label
    }
}

// MARK: - Protocols
protocol CollapsibleHeaderDelegate {
    func collapseOrExpand(action collapse: Bool, atSection section: HistorySection)
}
