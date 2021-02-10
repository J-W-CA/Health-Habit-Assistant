//
//  File.swift
//  WeeklyHabitTracker
//
//  Created by Jason Wang on 4/26/20.
//  Copyright © 2020 Jason Wang. All rights reserved.
//

import UIKit
import CoreHaptics

extension UIButton {
    func shake(duration: TimeInterval = 0.5, xValue: CGFloat = 12, yValue: CGFloat = 0) {
        self.transform = CGAffineTransform(translationX: xValue, y: yValue)
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
        
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var engine: CHHapticEngine?
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Engine creation error:", error.localizedDescription)
        }
        engine?.stoppedHandler = { reason in
            print("Engine stopped:", reason)
        }
        engine?.resetHandler = {
            do {
                try engine?.start()
            } catch {
                print("Engine failed error:", error)
            }
        }

        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()
        for index in stride(from: 0, to: 0.4, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - index))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1 - index))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: index)
            events.append(event)
        }

        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Play pattern error:", error.localizedDescription)
        }
    }
}
