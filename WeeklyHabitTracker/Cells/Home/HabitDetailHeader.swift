//
//  HabitDetailHeader.swift
//  WeeklyHabitTracker
//
//  Created by Jason Wang on 7/17/20.
//  Copyright © 2020 Jason Wang. All rights reserved.
//

import UIKit

class HabitDetailHeader: UITableViewHeaderFooterView {
    private weak var delegate: HabitDetailHeaderDelegate?
    
    private let titleTextField = FormingTextField(placeholder: "Habit Title", returnKeyType: .done)
    private let daysStackView = UIStackView()
    private let daySelectionLabel = FormingSecondaryLabel(text: "Select at least one day.")
    private let topColorsStackView = UIStackView()
    private let bottomColorsStackView = UIStackView()
    private let colorSelectionLabel = FormingSecondaryLabel(text: "Select a color.")
    
    private var previousColor: Int64? = nil
    private let topColors = [FormingColors.getColor(fromValue: 0), FormingColors.getColor(fromValue: 1), FormingColors.getColor(fromValue: 2), FormingColors.getColor(fromValue: 3), FormingColors.getColor(fromValue: 4)]
    private let bottomColors = [FormingColors.getColor(fromValue: 5), FormingColors.getColor(fromValue: 6), FormingColors.getColor(fromValue: 7), FormingColors.getColor(fromValue: 8), FormingColors.getColor(fromValue: 9)]
    
    private let haptics = UISelectionFeedbackGenerator()

    // MARK: - Initializers
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        configureTitleTextField()
        configureDaysStackView()
        configureColorStackView(self.topColorsStackView, colors: self.topColors)
        configureColorStackView(self.bottomColorsStackView, colors: self.bottomColors)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("habit detail header deinit")
    }
    
    // MARK: - Configuration Functions
    func configureTitleTextField() {
        titleTextField.delegate = self
        titleTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        titleTextField.becomeFirstResponder()
    }
    
    func configureDaysStackView() {
        let days = ["Su", "M", "T", "W", "Th", "F", "Sa"]
        daysStackView.axis = .horizontal
        daysStackView.alignment = .fill
        daysStackView.distribution = .fillEqually
        daysStackView.spacing = (UIScreen.main.bounds.width - 40 - 280) / 6
        
        let heavyAttribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .heavy)]
        let thinAttribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .thin)]
        for (index, day) in days.enumerated() {
            let button = FormingDayButton(title: day, tag: index, width: 40)
            button.setAttributedTitle(NSAttributedString(string: day, attributes: thinAttribute), for: .normal)
            button.setAttributedTitle(NSAttributedString(string: day, attributes: heavyAttribute), for: .selected)
            button.setBackgroundColor(color: .secondarySystemFill, forState: .selected)
            button.addTarget(self, action: #selector(dayButtonTapped), for: .touchUpInside)
            daysStackView.addArrangedSubview(button)
        }
    }
    
    func configureColorStackView(_ stackView: UIStackView, colors: [UIColor]) {
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        var tagCounter = 0
        stackView.spacing = (UIScreen.main.bounds.width - 40 - 200) / 4
        let config = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 17, weight: .heavy))
        for (index, color) in colors.enumerated() {
            if stackView == self.bottomColorsStackView && index == 0 { tagCounter = 5 }
            let button = FormingColorButton(color: color, tag: tagCounter, width: 40)
            button.setImage(UIImage(named: "checkmark", in: nil, with: config), for: .selected)
            button.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
            stackView.addArrangedSubview(button)
            tagCounter += 1
        }
    }
    
    func configureConstraints() {
        addSubview(titleTextField)
        titleTextField.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 40)
        
        addSubview(daysStackView)
        daysStackView.anchor(top: titleTextField.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 40)
        addSubview(daySelectionLabel)
        daySelectionLabel.anchor(top: daysStackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 25)
        
        addSubview(topColorsStackView)
        topColorsStackView.anchor(top: daySelectionLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 40)
        addSubview(bottomColorsStackView)
        bottomColorsStackView.anchor(top: topColorsStackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 40)
        addSubview(colorSelectionLabel)
        colorSelectionLabel.anchor(top: bottomColorsStackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 25)
    }
    
    // MARK: - Setters
    func set(delegate: HabitDetailHeaderDelegate) {
        self.delegate = delegate
    }
    
    func set(title: String?) {
        self.titleTextField.text = title
        self.titleTextField.resignFirstResponder()
    }
    
    func set(days: [Bool]) {
        for (index, day) in days.enumerated() {
            if day {
                if let dayButton = self.daysStackView.arrangedSubviews[index] as? FormingDayButton {
                    dayButton.isSelected = true
                }
            }
        }
    }
    
    func set(color: Int64) {
        self.previousColor = color
        if color < 5 {
            if let colorButton = self.topColorsStackView.arrangedSubviews[Int(color)] as? FormingColorButton {
                colorButton.isSelected = true
            }
        } else {
            if let colorButton = self.bottomColorsStackView.arrangedSubviews[Int(color) - 5] as? FormingColorButton {
                colorButton.isSelected = true
            }
        }
    }
    
    // MARK: - Selectors
    @objc func dayButtonTapped(sender: UIButton) {
        if self.titleTextField.isFirstResponder { self.titleTextField.resignFirstResponder() }
        DispatchQueue.main.async { self.haptics.selectionChanged() }
        let tag = sender.tag
        
        if sender.isSelected == true {
            sender.isSelected = false
            self.delegate!.send(day: tag, andFlag: sender.isSelected)
        } else {
            sender.isSelected = true
            self.delegate!.send(day: tag, andFlag: sender.isSelected)
        }
    }
    
    @objc func colorButtonTapped(sender: UIButton) {
        if self.titleTextField.isFirstResponder { self.titleTextField.resignFirstResponder() }
        DispatchQueue.main.async { self.haptics.selectionChanged() }
        let tag = sender.tag
        
        if sender.isSelected == true {
            sender.isSelected = false
            self.previousColor = nil
            self.delegate!.send(color: nil)
        } else {
            if let previous = self.previousColor {
                if previous < 5 {
                    if let colorButton = self.topColorsStackView.arrangedSubviews[Int(previous)] as? FormingColorButton {
                        colorButton.isSelected = false
                    }
                } else {
                    if let colorButton = self.bottomColorsStackView.arrangedSubviews[Int(previous - 5)] as? FormingColorButton {
                        colorButton.isSelected = false
                    }
                }
                sender.isSelected = true
                self.delegate!.send(color: Int64(tag))
                self.previousColor = Int64(tag)
            } else {
                sender.isSelected = true
                self.delegate!.send(color: Int64(tag))
                self.previousColor = Int64(tag)
            }
        }
    }
}

// MARK: Delegates
extension HabitDetailHeader: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        self.delegate!.send(title: textField.text?.trimmingCharacters(in: .whitespaces))
    }
}

// MARK: Protocols
protocol HabitDetailHeaderDelegate: class {
    func send(title: String?)
    func send(day: Int, andFlag flag: Bool)
    func send(color: Int64?)
}
