//
//  HomeHeaderCell.swift
//  WeeklyHabitTracker
//
//  Created by Jason Wang on 4/14/20.
//  Copyright © 2020 Jason Wang. All rights reserved.
//

import UIKit

class HomeHeaderCell: UICollectionViewCell {
    let dayNames = ["Su", "M", "T", "W", "Th", "F", "Sa"]
    let dayNamesStackView = UIStackView()
    var dayNums: [String]?
    let dayNumsStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        configureDayNums()
        configureStackView(dayNamesStackView, withArray: dayNames)
        guard let dayNumbers = self.dayNums else { return }
        configureStackView(dayNumsStackView, withArray: dayNumbers)
        configureConstraints()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCalendar), name: NSNotification.Name(NotificationName.newDay.rawValue), object: nil)
    }
    
    func configureDayNums() {
        dayNums = CalUtility.getCurrentWeek()
    }
    
    func configureStackView(_ stackView : UIStackView, withArray array: [String]) {
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        for item in array {
            let label = UILabel()
            label.text = item
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 20, weight: .thin)
            stackView.addArrangedSubview(label)
        }
        
        let label = stackView.arrangedSubviews[CalUtility.getCurrentDay()] as? UILabel
        label?.font = UIFont.systemFont(ofSize: 20, weight: .black)
    }
    
    func configureConstraints() {
        addSubview(dayNamesStackView)
        dayNamesStackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: frame.height / 2, paddingRight: 15, width: 0, height: 0)
        
        addSubview(dayNumsStackView)
        dayNumsStackView.anchor(top: dayNamesStackView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: 10, paddingRight: 15, width: 0, height: 0)
    }
    
    @objc func updateCalendar() {
        DispatchQueue.main.async {
            // create fonts and reset all fonts in stackviews to thin
            let newDay = CalUtility.getCurrentDay()
            let newWeek = CalUtility.getCurrentWeek()
            let thinFont = UIFont.systemFont(ofSize: 20, weight: .thin)
            let blackFont = UIFont.systemFont(ofSize: 20, weight: .black)
            
            if newDay == 0 {
                for (index, view) in self.dayNumsStackView.arrangedSubviews.enumerated() {
                    if let label = view as? UILabel {
                        label.text = newWeek[index]
                    }
                }
            }
            
            for (day, num) in zip(self.dayNamesStackView.arrangedSubviews, self.dayNumsStackView.arrangedSubviews) {
                let dayLabel = day as! UILabel
                let numLabel = num as! UILabel
                dayLabel.font = thinFont
                numLabel.font = thinFont
            }
            
            // set the new current location
            let dayNameLabel = self.dayNamesStackView.arrangedSubviews[newDay] as? UILabel
            dayNameLabel?.font = blackFont
            let dayNumLabel = self.dayNumsStackView.arrangedSubviews[newDay] as? UILabel
            dayNumLabel?.font = blackFont
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
