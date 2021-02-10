//
//  HIstoryCell.swift
//  WeeklyHabitTracker
//
//  Created by Jason Wang on 5/5/20.
//  Copyright © 2020 Jason Wang. All rights reserved.
//

import UIKit

class HistoryTitleCell: UICollectionViewCell {
    private let titleLabel = UILabel()
    private let compPercentLabel = UILabel()
    private let goalPercentLabel = UILabel()
    private let compProgressView = UIView()
    private let goalProgressView = UIView()
    
    private let compDescriptionLabel = FormingSecondaryLabel(text: "Completion")
    private let goalDescriptionLabel = FormingSecondaryLabel(text: "To Goal")
    
    private let compTrackLayer = CAShapeLayer()
    private let compTrackPath = UIBezierPath()
    private let compProgressLayer = CAShapeLayer()
    private let compProgressPath = UIBezierPath()
    private let goalTrackLayer = CAShapeLayer()
    private let goalTrackPath = UIBezierPath()
    private let goalProgressLayer = CAShapeLayer()
    private let goalProgressPath = UIBezierPath()
    
    private var reload: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 14
        clipsToBounds = true
        
        compDescriptionLabel.textColor = .white
        goalDescriptionLabel.textColor = .white
        
        configureTitleLabel()
        configure(percentLabel: compPercentLabel)
        configure(percentLabel: goalPercentLabel)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTitleLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .left
        titleLabel.textColor = .white
        titleLabel.lineBreakMode = .byTruncatingTail
    }
    
    private func configure(percentLabel: UILabel) {
        percentLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        percentLabel.textAlignment = .left
        percentLabel.textColor = .white
    }
    
    private func configureLayer(_ layer: CAShapeLayer, path: UIBezierPath, startX: CGFloat, endX: CGFloat, color: UIColor, progressView: UIView) {
        path.move(to: CGPoint(x: startX, y: 5.5))
        path.addLine(to: CGPoint(x: endX, y: 5.5))
        
        layer.frame = path.bounds
        layer.path = path.cgPath
        layer.strokeColor = color.cgColor
        layer.lineWidth = 12
        layer.lineCap = .round
        
        progressView.layer.addSublayer(layer)
    }
    
    private func configureConstraints() {
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 28)
    }
    
    private func addCompletionConstraints() {
        addSubview(compPercentLabel)
        compPercentLabel.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        addSubview(compDescriptionLabel)
        compDescriptionLabel.anchor(top: nil, left: compPercentLabel.rightAnchor, bottom: compPercentLabel.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        addSubview(compProgressView)
        compProgressView.anchor(top: compPercentLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: centerXAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 5, paddingRight: 10, width: 0, height: 0)
    }
    
    private func addGoalConstraints() {
        addSubview(goalPercentLabel)
        goalPercentLabel.anchor(top: titleLabel.bottomAnchor, left: centerXAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 20)
        addSubview(goalDescriptionLabel)
        goalDescriptionLabel.anchor(top: nil, left: goalPercentLabel.rightAnchor, bottom: goalPercentLabel.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        addSubview(goalProgressView)
        goalProgressView.anchor(top: goalPercentLabel.bottomAnchor, left: centerXAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 5, paddingRight: 10, width: 0, height: 0)
    }
    
    private func removeConstraints() {
        compPercentLabel.removeFromSuperview()
        compDescriptionLabel.removeFromSuperview()
        compProgressView.removeFromSuperview()
        goalPercentLabel.removeFromSuperview()
        goalDescriptionLabel.removeFromSuperview()
        goalProgressView.removeFromSuperview()
    }
    
    func set(title: String) {
        titleLabel.text = title
    }
    
    func set(color: UIColor) {
        backgroundColor = color
    }
    
    func set(completionRate: Double, compRateText: String, goalRate: CGFloat?, goalRateText: String?) {
        if self.reload { removePoints(); removeConstraints() }
            
        let endX: CGFloat
        if let goal = goalRate, let goalText = goalRateText {
            endX = self.frame.width / 2 - 30
            goalPercentLabel.text = goalText
            configureLayer(self.goalTrackLayer, path: self.goalTrackPath, startX: 3.0, endX: endX, color: UIColor.white.withAlphaComponent(0.5), progressView: goalProgressView)
            if goal > 0 && goal <= 1.0 {
                configureLayer(self.goalProgressLayer, path: self.goalProgressPath, startX: 3.0, endX: endX * CGFloat(goal), color: .white, progressView: goalProgressView)
            } else if goal > 1.0 {
                configureLayer(self.goalProgressLayer, path: self.goalProgressPath, startX: 3.0, endX: endX, color: .white, progressView: goalProgressView)
            } else {
                goalProgressLayer.removeFromSuperlayer()
            }
            
            addGoalConstraints()
        } else {
            endX = self.frame.width - 30
        }
        
        compPercentLabel.text = compRateText
        configureLayer(self.compTrackLayer, path: self.compTrackPath, startX: 3.0, endX: endX, color: UIColor.white.withAlphaComponent(0.5), progressView: compProgressView)
        if completionRate > 0 {
            configureLayer(self.compProgressLayer, path: self.compProgressPath, startX: 3.0, endX: endX * CGFloat(completionRate), color: .white, progressView: compProgressView)
        } else {
            compProgressLayer.removeFromSuperlayer()
        }
        
        addCompletionConstraints()
        self.reload = true
    }
    
    private func removePoints() {
        self.compTrackPath.removeAllPoints()
        self.compProgressPath.removeAllPoints()
        self.goalTrackPath.removeAllPoints()
        self.goalProgressPath.removeAllPoints()
    }
}
