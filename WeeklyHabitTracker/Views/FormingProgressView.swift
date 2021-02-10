//
//  FormingProgressView.swift
//  WeeklyHabitTracker
//
//  Created by Jason Wang on 6/23/20.
//  Copyright © 2020 Jason Wang. All rights reserved.
//

import UIKit

class FormingProgressView: UIView {
    private weak var delegate: FormingProgressViewDelegate?
    
    private let percentLabel = UILabel()
    private let descriptionLabel = FormingSecondaryLabel()
    private let infoButton = UIButton()
    private let progressContainer = UIView()
    private let infoLabelOne = FormingSecondaryLabel()
    private let infoLabelTwo = FormingSecondaryLabel()
    
    private let trackLayer = CAShapeLayer()
    private let trackPath = UIBezierPath()
    private let progressLayer = CAShapeLayer()
    private let progressPath = UIBezierPath()
    private let failedLayer = CAShapeLayer()
    private let failedPath = UIBezierPath()
    
    private let yPosition: CGFloat = 5.0
    private var reload: Bool = false
    private var compensate: Bool = false
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configurePercentLabel()
        configureInfoButton()
        configureProgressContainer()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("progress view deinit")
    }
    
    // MARK: - Configuration Functions
    private func configurePercentLabel() {
        percentLabel.textAlignment = .center
        percentLabel.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
    }
    
    private func configureInfoButton() {
        infoButton.addTarget(nil, action: #selector(infoButtonPressed), for: .touchUpInside)
        infoButton.setImage(UIImage(named: "info.circle"), for: .normal)
        infoButton.tintColor = .label
    }
    
    private func configureProgressContainer() {
        progressContainer.layer.addSublayer(self.trackLayer)
        progressContainer.layer.addSublayer(self.progressLayer)
        progressContainer.layer.addSublayer(self.failedLayer)
    }
    
    private func configureLayer(_ layer: CAShapeLayer, path: UIBezierPath, startX: CGFloat, endX: CGFloat, andColor color: UIColor) {
        path.move(to: CGPoint(x: startX, y: self.yPosition))
        path.addLine(to: CGPoint(x: endX, y: self.yPosition))
        
        layer.frame = path.bounds
        layer.path = path.cgPath
        layer.strokeColor = color.cgColor
        layer.lineWidth = 15
        layer.lineCap = .round
    }
    
    private func configureConstraints() {
        addSubview(percentLabel)
        percentLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(progressContainer)
        progressContainer.anchor(top: percentLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        
        addSubview(descriptionLabel)
        descriptionLabel.anchor(top: nil, left: percentLabel.rightAnchor, bottom: progressContainer.topAnchor, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 7, paddingRight: 0, width: 0, height: 0)

        addSubview(infoButton)
        infoButton.anchor(top: nil, left: nil, bottom: progressContainer.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)

        addSubview(infoLabelOne)
        infoLabelOne.anchor(top: progressContainer.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        addSubview(infoLabelTwo)
        infoLabelTwo.anchor(top: progressContainer.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 5, width: 0, height: 0)
    }
    
    // MARK: - Setters
    func set(delegate: FormingProgressViewDelegate) {
        self.delegate = delegate
    }
    
    func set(percentLabel text: String) {
        self.percentLabel.text = text
    }
    
    func set(description: String) {
        descriptionLabel.set(text: description)
    }
    
    func set(infoOne: String) {
        infoLabelOne.set(text: infoOne)
    }
    
    func set(infoTwo: String) {
        infoLabelTwo.set(text: infoTwo)
    }
    
    func set(trackStartX: CGFloat, trackEndX: CGFloat) {
        configureLayer(self.trackLayer, path: self.trackPath, startX: trackStartX, endX: trackEndX, andColor: .tertiarySystemFill)
    }
    
    func set(progressRate: CGFloat, startX: CGFloat, endX: CGFloat) {
        if self.reload { self.progressPath.removeAllPoints() }
        
        configureLayer(self.progressLayer, path: self.progressPath, startX: startX, endX: endX, andColor: .systemGreen)
        animate(from: 0.0, to: progressRate, onLayer: self.progressLayer)
        self.reload = true
    }
    
    func set(failedRate: CGFloat, startX: CGFloat, endX: CGFloat) {
        if self.reload { self.failedPath.removeAllPoints() }
        
        configureLayer(self.failedLayer, path: self.failedPath, startX: startX, endX: endX, andColor: .systemRed)
        animate(from: 0.0, to: failedRate, onLayer: self.failedLayer)
        self.reload = true
    }
    
    func set(compensate: Bool) {
        self.compensate = compensate
    }
    
    // MARK: - Functions
    private func animate(from fromValue: CGFloat, to toValue: CGFloat, onLayer layer: CAShapeLayer) {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.fromValue = fromValue
        if self.compensate && toValue != 1.0 {
            basicAnimation.toValue = toValue - 0.02125
        } else {
            basicAnimation.toValue = toValue
        }
        basicAnimation.duration = CFTimeInterval((toValue / toValue) * 0.75)
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        layer.add(basicAnimation, forKey: "line")
    }
    
    func removeInfoButton() {
        self.infoButton.removeFromSuperview()
    }
    
    // MARK: - Selectors
    @objc func infoButtonPressed() {
        if let description = self.descriptionLabel.text {
            if description.contains("Completion") {
                self.delegate?.showAlert(withTitle: "Completion Rate", andMessage: "Your completion rate is calculated by dividing the number of completed days by the sum of completed days and failed days. \n\nThis is used to give you an idea of how successful you are at completing a habit.")
            } else {
                self.delegate?.showAlert(withTitle: "Goal Progress", andMessage: "Your goal progress is an indicator of how close you are to reaching your goal for a habit, if one is set. \n\nWhen a goal is reached, you will be notified within the app and will be given options on how to continue your habit.")
            }
        }
    }
}

protocol FormingProgressViewDelegate: class {
    func showAlert(withTitle title: String, andMessage message: String)
}
