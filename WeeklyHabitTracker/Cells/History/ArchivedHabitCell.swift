//
//  ArchivedHabitCell.swift
//  WeeklyHabitTracker
//
//  Created by Jason Wang on 6/12/20.
//  Copyright © 2020 Jason Wang. All rights reserved.
//

import UIKit

class ArchivedHabitCell: UICollectionViewCell {
    private var archivedHabit: ArchivedHabit?
    private weak var delegate: ArchivedHabitCellDelegate?
    
    private let titleButton = UIButton()
    private let statusStackView = UIStackView()
    private var alertController: UIAlertController?

    private let regularConfig = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 17, weight: .regular), scale: .large)
    private let boldConfig = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 17, weight: .bold), scale: .small)
    private let impactGenerator = UIImpactFeedbackGenerator()
    private var attributed: Bool = true
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setters
    func set(archivedHabit: ArchivedHabit, attributed: Bool = true, buttonEnabled: Bool) {
        self.archivedHabit = archivedHabit
        self.attributed = attributed
        
        configureCell()
        configureTitleButton()
        configureStatusStackView(withStatuses: archivedHabit.statuses, andButtonEnabled: buttonEnabled)
        
        configureConstraints()
    }
    
    func set(delegate: ArchivedHabitCellDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Configuration Functions
    private func configureCell() {
        layer.cornerRadius = 14
        backgroundColor = .tertiarySystemFill
        clipsToBounds = true
    }
    
    private func configureTitleButton() {
        titleButton.contentHorizontalAlignment = .left
        titleButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        titleButton.titleLabel?.textColor = .white
        titleButton.addTarget(self, action: #selector(titleTapped), for: .touchUpInside)
        if let color = self.archivedHabit?.archive.color {
            titleButton.backgroundColor = FormingColors.getColor(fromValue: color)
        }
        if let startDate = archivedHabit?.startDate, let endDate = archivedHabit?.endDate {
            if self.attributed {
                let symbolAttachment = NSTextAttachment()
                symbolAttachment.image = UIImage(named: "chevron.right", in: nil, with: boldConfig)
                symbolAttachment.image = symbolAttachment.image?.withTintColor(.white)
                let dateTitle = "\(CalUtility.getDateAsString(date: startDate)) - \(CalUtility.getDateAsString(date: endDate))"
                let attributedTitle = NSMutableAttributedString(string: "  \(dateTitle) ", attributes: [.font: UIFont.systemFont(ofSize: 17, weight: .bold), .foregroundColor: UIColor.white])
                attributedTitle.append(NSAttributedString(attachment: symbolAttachment))
                titleButton.setAttributedTitle(attributedTitle, for: .normal)
            } else {
                let dateTitle = "\(CalUtility.getDateAsString(date: startDate)) - \(CalUtility.getDateAsString(date: endDate))"
                let attributedTitle = NSMutableAttributedString(string: "  \(dateTitle) ", attributes: [.font: UIFont.systemFont(ofSize: 17, weight: .bold), .foregroundColor: UIColor.white])
                titleButton.setAttributedTitle(attributedTitle, for: .normal)
            }
        }
    }
    
    private func configureStatusStackView(withStatuses statuses: [Status], andButtonEnabled enabled: Bool) {
        if !statusStackView.arrangedSubviews.isEmpty { for view in statusStackView.arrangedSubviews { view.removeFromSuperview() } }
        statusStackView.axis = .horizontal
        statusStackView.alignment = .fill
        statusStackView.distribution = .fillEqually
        for (index, status) in statuses.enumerated() {
            let button = UIButton()
            button.isEnabled = enabled
            button.tag = index
            switch status {
            case .incomplete: button.setImage(UIImage(named: "square", in: nil, with: regularConfig), for: .normal); button.imageView?.tintColor = .label
            case .completed: button.setImage(UIImage(named: "checkmark.square", in: nil, with: regularConfig), for: .normal); button.imageView?.tintColor = .systemGreen
            case .failed: button.setImage(UIImage(named: "xmark.square", in: nil, with: regularConfig), for: .normal); button.imageView?.tintColor = .systemRed
            case .empty: ()
            }
            
            if enabled {
                button.addGestureRecognizer(createLongGesture())
            }
            
            statusStackView.addArrangedSubview(button)
        }
    }
    
    private func configureConstraints() {
        addSubview(titleButton)
        titleButton.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 25)
        addSubview(statusStackView)
        statusStackView.anchor(top: titleButton.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    // MARK: - Functions
    func createLongGesture() -> UILongPressGestureRecognizer {
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(checkboxLongPressed))
        longGesture.minimumPressDuration = 0.5
        return longGesture
    }
    
    func createAlertActions(checkbox: UIButton) {
        alertController?.addAction(UIAlertAction(title: "Complete", style: .default, handler: { [weak self] (_) in
            guard let self = self else { return }
            guard let oldStatus = self.archivedHabit?.statuses[checkbox.tag] else { return }
            self.delegate?.selectionChanged(atIndex: checkbox.tag, fromStatus: oldStatus, toStatus: .completed, forState: checkbox.tag == CalUtility.getCurrentDay() ? true : nil)
            self.delegate?.save()
        }))
        alertController?.addAction(UIAlertAction(title: "Failed", style: .default, handler:{ [weak self] (_) in
            guard let self = self else { return }
            guard let oldStatus = self.archivedHabit?.statuses[checkbox.tag] else { return }
            self.delegate?.selectionChanged(atIndex: checkbox.tag, fromStatus: oldStatus, toStatus: .failed, forState: checkbox.tag == CalUtility.getCurrentDay() ? true : nil)
            self.delegate?.save()
        }))
        alertController?.addAction(UIAlertAction(title: "Incomplete", style: .default, handler: { [weak self] (_) in
            guard let self = self else { return }
            guard let oldStatus = self.archivedHabit?.statuses[checkbox.tag] else { return }
            self.delegate?.selectionChanged(atIndex: checkbox.tag, fromStatus: oldStatus, toStatus: .incomplete, forState: checkbox.tag == CalUtility.getCurrentDay() ? false : nil)
            self.delegate?.save()
        }))
        alertController?.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    }
    
    // MARK: - Selectors
    @objc func titleTapped() {
        guard let archivedHabit = self.archivedHabit else { return }
        delegate?.pushViewController(with: archivedHabit)
    }
    
    @objc func checkboxLongPressed(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            DispatchQueue.main.async { self.impactGenerator.impactOccurred() }
            guard let checkbox = gesture.view as? UIButton else { return }
            alertController = UIAlertController()
            alertController?.title = "Change status to:"
            alertController?.view.tintColor = .systemGreen
            createAlertActions(checkbox: checkbox)
            delegate?.presentAlertController(with: alertController!)
        }
    }
}

// MARK: - Protocols
protocol ArchivedHabitCellDelegate: class {
    func pushViewController(with archivedHabit: ArchivedHabit)
    func presentAlertController(with alert: UIAlertController)
    func selectionChanged(atIndex index: Int, fromStatus oldStatus: Status, toStatus newStatus: Status, forState state: Bool?)
    func save()
}
