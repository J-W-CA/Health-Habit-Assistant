//
//  FormingAlertViewController.swift
//  WeeklyHabitTracker
//
//  Created by Robert Parsons on 7/31/20.
//  Copyright © 2020 Robert Parsons. All rights reserved.
//

import UIKit

class GoalReachedViewController: UIViewController {
    private let habit: Habit
    private weak var delegate: AlertViewDelegate?
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let messageOneLabel = UILabel()
    private let messageTwoLabel = UILabel()
    private let progressView = FormingProgressView()
    private let finishHabitButton = UIButton()
    private let adjustGoalButton = UIButton()
    private let continueButton = UIButton()
    
    // MARK: - Initializers
    init(habit: Habit, delegate: AlertViewDelegate) {
        self.habit = habit
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("alert view deinit")
    }
    
    // MARK: - ViewController Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        
        configureContainer()
        configureTitleLabel()
        configure(label: messageOneLabel, withText: "Congratulations on reaching your goal!")
        configure(label: messageTwoLabel, withText: "Please select how you would like to continue below.")
        configureProgressView()
        
        configure(button: finishHabitButton, withTitle: "Finish Habit", andColor: .systemGreen)
        configure(button: adjustGoalButton, withTitle: "Adjust Goal", andColor: .systemBlue)
        configure(button: continueButton, withTitle: "Continue Habit As Is", andColor: .systemGray)
        configureButtonTargets()
                
        configureConstraints()
        
        createAndStartParticles()
    }
    
    
    // MARK: - Configuration Functions
    private func configureContainer() {
        containerView.backgroundColor = .secondarySystemBackground
        containerView.layer.cornerRadius = 14
    }
    
    private func configureTitleLabel() {
        titleLabel.text = "Goal Reached!"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
    }
    
    private func configure(label: UILabel, withText text: String) {
        label.text = text
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
    }
    
    private func configureButtonTargets() {
        finishHabitButton.addTarget(self, action: #selector(finishButtonTapped), for: .touchUpInside)
        adjustGoalButton.addTarget(self, action: #selector(adjustButtonTapped), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
    }
    
    private func configureProgressView() {
        let endX = self.view.frame.width - 40 - 45
        progressView.set(trackStartX: 5.0, trackEndX: endX)
        progressView.set(progressRate: 1.0, startX: 5.0, endX: endX)
        progressView.set(percentLabel: "100%")
        progressView.set(description: "Goal Progress")
        progressView.set(infoOne: "\(self.habit.archive.completedTotal) Completed")
        progressView.set(infoTwo: "Goal: \(self.habit.goal)")
        progressView.removeInfoButton()
    }
    
    private func configure(button: UIButton, withTitle title: String, andColor color: UIColor) {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.backgroundColor = color
        button.layer.cornerRadius = 7
    }
    
    private func configureConstraints() {
        let top = containerView.topAnchor, left = containerView.leftAnchor, bottom = containerView.bottomAnchor, right = containerView.rightAnchor
        containerView.addSubview(titleLabel)
        titleLabel.anchor(top: top, left: left, bottom: nil, right: right, paddingTop: 15, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 30)
        
        containerView.addSubview(continueButton)
        continueButton.anchor(top: nil, left: left, bottom: bottom, right: right, paddingTop: 15, paddingLeft: 15, paddingBottom: 15, paddingRight: 15, width: 0, height: 40)
        containerView.addSubview(adjustGoalButton)
        adjustGoalButton.anchor(top: nil, left: left, bottom: continueButton.topAnchor, right: right, paddingTop: 15, paddingLeft: 15, paddingBottom: 15, paddingRight: 15, width: 0, height: 40)
        containerView.addSubview(finishHabitButton)
        finishHabitButton.anchor(top: nil, left: left, bottom: adjustGoalButton.topAnchor, right: right, paddingTop: 0, paddingLeft: 15, paddingBottom: 15, paddingRight: 15, width: 0, height: 40)
        
        containerView.addSubview(messageOneLabel)
        messageOneLabel.anchor(top: titleLabel.bottomAnchor, left: left, bottom: nil, right: right, paddingTop: 15, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 0)
        
        containerView.addSubview(progressView)
        progressView.anchor(top: messageOneLabel.bottomAnchor, left: left, bottom: nil, right: right, paddingTop: 20, paddingLeft: 15, paddingBottom: 15, paddingRight: 15, width: 0, height: 65)
        
        containerView.addSubview(messageTwoLabel)
        messageTwoLabel.anchor(top: nil, left: left, bottom: finishHabitButton.topAnchor, right: right, paddingTop: 0, paddingLeft: 15, paddingBottom: 30, paddingRight: 15, width: 0, height: 0)
        
        view.addSubview(containerView)
        containerView.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, y: view.centerYAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 450)
    }
    
    // MARK: - Selectors
    @objc func finishButtonTapped() {
        
    }
    
    @objc func adjustButtonTapped() {
        
    }
    
    @objc func dismissAlert() {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
}

// Protocols
protocol AlertViewDelegate: class {
    func finishButtonTapped()
}
