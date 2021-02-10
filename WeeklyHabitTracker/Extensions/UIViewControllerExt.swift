//
//  UIViewControllerExt.swift
//  WeeklyHabitTracker
//
//  Created by Jason Wang on 7/31/20.
//  Copyright © 2020 Jason Wang. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentGoalReachedViewController(withHabit habit: Habit, andDelegate delegate: GoalReachedDelegate) {
        DispatchQueue.main.async {
            let alert = GoalReachedViewController(habit: habit, delegate: delegate)
            alert.modalPresentationStyle = .overFullScreen
            alert.modalTransitionStyle = .crossDissolve
            self.present(alert, animated: true)
        }
    }
    
    func createAndStartParticles() {
        let particleEmitter = CAEmitterLayer()

        particleEmitter.emitterPosition = CGPoint(x: view.center.x, y: -96)
        particleEmitter.emitterShape = .line
        particleEmitter.emitterSize = CGSize(width: view.frame.size.width, height: 1)

        let pink = makeEmitterCell(color: .systemPink)
        let indigo = makeEmitterCell(color: .systemIndigo)
        let orange = makeEmitterCell(color: .systemOrange)
        let yellow = makeEmitterCell(color: .systemYellow)
        let purple = makeEmitterCell(color: .systemPurple)

        particleEmitter.emitterCells = [pink, indigo, orange, yellow, purple]

        view.layer.addSublayer(particleEmitter)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            particleEmitter.birthRate = 0
        }
    }

    private func makeEmitterCell(color: UIColor) -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = 3
        cell.lifetime = 7.0
        cell.lifetimeRange = 0
        cell.color = color.cgColor
        cell.velocity = 200
        cell.velocityRange = 50
        cell.emissionLongitude = CGFloat.pi
        cell.emissionRange = CGFloat.pi / 4
        cell.spin = 2
        cell.spinRange = 3
        cell.scaleRange = 0.5
        cell.scaleSpeed = -0.05

        cell.contents = UIImage(named: "white-star")?.cgImage
        return cell
    }
}
