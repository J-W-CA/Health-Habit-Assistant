import UIKit

extension CAShapeLayer {
    
    func strokeEndAnimation(fromValue: CGFloat, toValue: CGFloat, duration: CFTimeInterval) {
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.fromValue = fromValue
        strokeAnimation.toValue = toValue
        strokeAnimation.duration = duration
        strokeAnimation.fillMode = CAMediaTimingFillMode.forwards
        strokeAnimation.isRemovedOnCompletion = false
        self.add(strokeAnimation, forKey: "strokeEnd")
    }
}
