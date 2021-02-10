//
//  FinalHabitCell.swift
//  WeeklyHabitTracker
//
//  Created by Jason Wang on 5/11/20.
//  Copyright © 2020 Jason Wang. All rights reserved.
//

import UIKit

class HabitCell: UICollectionViewCell {
    private var habit: Habit!
    private weak var delegate: HabitCellDelegate?
    private var currentDay = CalUtility.getCurrentDay()
    private let dayNames = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    private let titleButton = UIButton()
    private let titleLabel = UILabel()
    private let checkboxStackView = UIStackView()
    private let reminderLabel = UILabel()
    private let flagLabel = UILabel()
    private let priorityLabel = UILabel()
    private var alertController: UIAlertController?
    
    private let selectionGenerator = UISelectionFeedbackGenerator()
    private let impactGenerator = UIImpactFeedbackGenerator()
    
    private let thinConfig = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 17, weight: .thin), scale: .large)
    private let regularConfig = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 15, weight: .regular), scale: .default)
    private let boldConfig = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 17, weight: .bold), scale: .small)
    private let blackConfig = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 17, weight: .black), scale: .large)
    private let priorityAttachment = NSTextAttachment()
    private let flagAttachment = NSTextAttachment()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("habit cell deinit")
    }
    
    // MARK: - Setters
    func set(delegate: HabitCellDelegate) {
        self.delegate = delegate
    }
    
    func set(habit: Habit) {
        self.habit = habit
        self.currentDay = CalUtility.getCurrentDay()
        
        configureTitleButton(withColor: FormingColors.getColor(fromValue: habit.color))
        if let title = habit.title { configureTitleLabel(withTitle: title) }
        configureTitleButton(withColor: FormingColors.getColor(fromValue: habit.color))
        configureFlagLabel(withFlag: habit.flag)
        configurePriorityLabel(withPriority: habit.priority)
        configureReminderLabel(withReminder: habit.reminder)
        
        configureStackView()
        setupCheckboxes(withDays: habit.days, withState: habit.buttonState, andStatuses: habit.statuses)
        configureConstraints()
    }
    
    // MARK: - Configuration Functions
    func configureCell() {
        layer.cornerRadius = 14
        backgroundColor = .tertiarySystemFill
        clipsToBounds = true
    }
    
    func configureTitleButton(withColor color: UIColor) {
        titleButton.backgroundColor = color
        titleButton.addTarget(self, action: #selector(titleTapped), for: .touchUpInside)
    }
    
    func configureTitleLabel(withTitle title: String) {
        titleLabel.attributedText = createAttributedText(withTitle: title)
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.textColor = .white
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.isUserInteractionEnabled = false
    }
    
    func configureFlagLabel(withFlag flag: Bool) {
        if flag {
            let flagText = NSMutableAttributedString()
            flagText.append(NSAttributedString(attachment: flagAttachment))
            flagLabel.attributedText = flagText
        } else { flagLabel.attributedText = nil }
        flagLabel.font = UIFont.systemFont(ofSize: 15)
        flagLabel.textAlignment = .center
        flagLabel.textColor = .white
        flagLabel.isUserInteractionEnabled = false
        flagAttachment.image = UIImage(named: "flag.fill", in: nil, with: regularConfig)
        flagAttachment.image = flagAttachment.image?.withTintColor(.white)
    }
    
    func configurePriorityLabel(withPriority priority: Int64) {
        let priorityText = NSMutableAttributedString()
        for _ in 0..<priority { priorityText.append(NSAttributedString(attachment: priorityAttachment)) }
        priorityLabel.attributedText = priorityText
        priorityLabel.font = UIFont.systemFont(ofSize: 15)
        priorityLabel.textAlignment = .center
        priorityLabel.textColor = .white
        priorityLabel.isUserInteractionEnabled = false
        priorityAttachment.image = UIImage(named: "exclamationmark", in: nil, with: regularConfig)
        priorityAttachment.image = priorityAttachment.image?.withTintColor(.white)
    }
    
    func configureReminderLabel(withReminder reminder: Date?) {
        if let reminderToSet = reminder {
            reminderLabel.text = "\(CalUtility.getTimeAsString(time: reminderToSet)) "
        } else {
            reminderLabel.text = ""
        }
        reminderLabel.font = UIFont.systemFont(ofSize: 15)
        reminderLabel.textColor = .white
        reminderLabel.textAlignment = .center
        reminderLabel.isUserInteractionEnabled = false
    }
    
    func configureStackView() {
        checkboxStackView.axis = .horizontal
        checkboxStackView.alignment = .fill
        checkboxStackView.distribution = .fillEqually
    }
    
    func configureConstraints() {
        addSubview(titleButton)
        titleButton.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 25)
        addSubview(reminderLabel)
        reminderLabel.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 5, width: 70, height: 25)
        addSubview(priorityLabel)
        priorityLabel.anchor(top: topAnchor, left: nil, bottom: nil, right: reminderLabel.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 20, height: 25)
        addSubview(flagLabel)
        flagLabel.anchor(top: topAnchor, left: nil, bottom: nil, right: priorityLabel.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 20, height: 25)
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: flagLabel.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 5, width: 0, height: 25)
        addSubview(checkboxStackView)
        checkboxStackView.anchor(top: titleButton.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    // MARK: - Functions
    func setupCheckboxes(withDays days: [Bool], withState state: Bool, andStatuses statuses: [Status]) {
        if !checkboxStackView.arrangedSubviews.isEmpty { for view in checkboxStackView.arrangedSubviews { view.removeFromSuperview() } }
        
        for (index, day) in days.enumerated() {
            if day && index == self.currentDay { checkboxStackView.addArrangedSubview(createTodayCheckbox(withTag: index, withState: state, andStatuses: statuses)) }
            else if day { checkboxStackView.addArrangedSubview(createCheckbox(withTag: index, andStatuses: statuses)) }
            else { checkboxStackView.addArrangedSubview(UIView()) }
        }
    }
    
    func createTodayCheckbox(withTag tag: Int, withState state: Bool, andStatuses statuses: [Status]) -> UIButton {
        let button = UIButton()
        button.isSelected = state
        button.tag = tag
        button.addTarget(self, action: #selector(todayCheckboxTapped), for: .touchUpInside)
        button.addGestureRecognizer(createLongGesture())
        button.setImage(UIImage(named: "square", in: nil, with: self.blackConfig), for: .normal)
        switch statuses[tag] {
        case .incomplete: button.imageView?.tintColor = .label
        case .completed:
            button.setImage(UIImage(named: "checkmark.square.fill", in: nil, with: self.blackConfig), for: .selected)
            button.imageView?.tintColor = .systemGreen
        case .failed:
            button.setImage(UIImage(named: "xmark.square.fill", in: nil, with: self.blackConfig), for: .selected)
            button.imageView?.tintColor = .systemRed
        default: ()
        }
        return button
    }
    
    func createCheckbox(withTag tag: Int, andStatuses statuses: [Status]) -> UIButton {
        let button = UIButton()
        button.tag = tag
        button.addTarget(self, action: #selector(checkboxTapped), for: .touchUpInside)
        button.addGestureRecognizer(createLongGesture())
        switch statuses[tag] {
        case .incomplete:
            button.setImage(UIImage(named: "square", in: nil, with: self.thinConfig), for: .normal)
            button.imageView?.tintColor = .label
        case .completed:
            button.setImage(UIImage(named: "checkmark.square", in: nil, with: self.thinConfig), for: .normal)
            button.imageView?.tintColor = .systemGreen
        case .failed:
            button.setImage(UIImage(named: "xmark.square", in: nil, with: thinConfig), for: .normal)
            button.imageView?.tintColor = .systemRed
        default: ()
        }
        return button
    }
    
    func createLongGesture() -> UILongPressGestureRecognizer {
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(checkboxLongPressed))
        longGesture.minimumPressDuration = 0.5
        return longGesture
    }
    
    func updateHabit(forIndex index: Int, andStatus status: Status, forState state: Bool? = nil) {
        let oldStatus = self.habit.statuses[index]
        self.delegate?.checkboxSelectionChanged(atIndex: index, forHabit: self.habit, fromStatus: oldStatus, toStatus: status, forState: state)
    }
    
    func replace(withCheckbox checkbox: UIButton, atIndex index: Int, withState state: Bool = false) {
        DispatchQueue.main.async {
            checkbox.removeFromSuperview()
            if index == self.currentDay {
                self.checkboxStackView.insertArrangedSubview(self.createTodayCheckbox(withTag: checkbox.tag, withState: state, andStatuses: self.habit!.statuses), at: index)
            } else {
                self.checkboxStackView.insertArrangedSubview(self.createCheckbox(withTag: checkbox.tag, andStatuses: self.habit!.statuses), at: index)
            }
        }
    }
    
    func createAlertActions(checkbox: UIButton) {
        alertController?.addAction(UIAlertAction(title: "Complete", style: .default, handler: { [weak self] (_) in
            guard let self = self else { return }
            if checkbox.tag == self.currentDay { self.updateHabit(forIndex: checkbox.tag, andStatus: .completed, forState: true) }
            else { self.updateHabit(forIndex: checkbox.tag, andStatus: .completed) }
            self.replace(withCheckbox: checkbox, atIndex: checkbox.tag, withState: true)
        }))
        alertController?.addAction(UIAlertAction(title: "Failed", style: .default, handler:{ [weak self] (_) in
            guard let self = self else { return }
            if checkbox.tag == self.currentDay { self.updateHabit(forIndex: checkbox.tag, andStatus: .failed, forState: true) }
            else { self.updateHabit(forIndex: checkbox.tag, andStatus: .failed) }
            self.replace(withCheckbox: checkbox, atIndex: checkbox.tag, withState: true)
        }))
        alertController?.addAction(UIAlertAction(title: "Incomplete", style: .default, handler: { [weak self] (_) in
            guard let self = self else { return }
            if checkbox.tag == self.currentDay { self.updateHabit(forIndex: checkbox.tag, andStatus: .incomplete, forState: false) }
            else { self.updateHabit(forIndex: checkbox.tag, andStatus: .incomplete) }
            self.replace(withCheckbox: checkbox, atIndex: checkbox.tag, withState: false)
        }))
        alertController?.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    }
    
    func createAttributedText(withTitle title: String) -> NSAttributedString {
        let symbolAttachment = NSTextAttachment()
        symbolAttachment.image = UIImage(named: "chevron.right", in: nil, with: self.boldConfig)
        symbolAttachment.image = symbolAttachment.image?.withTintColor(.white)
        let attributedTitle = NSMutableAttributedString(string: "  \(title) ", attributes: [.font: UIFont.systemFont(ofSize: 17, weight: .bold), .foregroundColor: UIColor.white])
        attributedTitle.append(NSAttributedString(attachment: symbolAttachment))
        return attributedTitle
    }
    
    // MARK: - Selectors
    @objc func titleTapped() {
        if let habit = self.habit {
            delegate?.presentNewHabitViewController(with: habit)
        }
    }
    
    @objc func todayCheckboxTapped(sender: UIButton) {
        DispatchQueue.main.async { self.selectionGenerator.selectionChanged() }
        if sender.isSelected == true {
            sender.isSelected = false
            sender.imageView?.tintColor = .label
            updateHabit(forIndex: sender.tag, andStatus: .incomplete, forState: sender.isSelected)
        } else {
            sender.isSelected = true
            if sender.image(for: .selected) == UIImage(named: "xmark.square.fill", in: nil, with: blackConfig) {
                sender.setImage(UIImage(named: "xmark.square.fill", in: nil, with: blackConfig), for: .selected)
                sender.imageView?.tintColor = .systemRed
                updateHabit(forIndex: sender.tag, andStatus: .failed, forState: sender.isSelected)
            } else {
                sender.setImage(UIImage(named: "checkmark.square.fill", in: nil, with: blackConfig), for: .selected)
                sender.imageView?.tintColor = .systemGreen
                updateHabit(forIndex: sender.tag, andStatus: .completed, forState: sender.isSelected)
            }
        }
    }
    
    @objc func checkboxTapped(sender: UIButton) {
        DispatchQueue.main.async { sender.shake() }
    }
    
    @objc func checkboxLongPressed(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            DispatchQueue.main.async { self.impactGenerator.impactOccurred() }
            guard let checkbox = gesture.view as? UIButton else { return }
            alertController = UIAlertController()
            alertController?.title = "Change \(dayNames[checkbox.tag])'s status?"
            alertController?.message = "Knowing the correct status of what you've done (e.g. completing or failing a habit) helps you to form better habits."
            alertController?.view.tintColor = .systemGreen
            createAlertActions(checkbox: checkbox)
            delegate?.presentAlertController(with: alertController!)
        }
    }
    
}

// MARK: - Protocols
protocol HabitCellDelegate: class {
    func presentNewHabitViewController(with habit: Habit)
    func checkboxSelectionChanged(atIndex index: Int, forHabit habit: Habit, fromStatus oldStatus: Status, toStatus newStatus: Status, forState state: Bool?)
    func presentAlertController(with alert: UIAlertController)
}
