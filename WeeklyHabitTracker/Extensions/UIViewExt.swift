//
//  UIViewExt.swift
//  WeeklyHabitTracker
//
//  Created by Jason Wang on 4/14/20.
//  Copyright © 2020 Jason Wang. All rights reserved.
//

import UIKit

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, x: NSLayoutXAxisAnchor? = nil, y: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top { self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true }
        if let left = left { self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true }
        if let bottom = bottom { bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true }
        if let right = right { rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true }
        if let x = x { centerXAnchor.constraint(equalTo: x).isActive = true }
        if let y = y { centerYAnchor.constraint(equalTo: y).isActive = true }
        if width != 0 { widthAnchor.constraint(equalToConstant: width).isActive = true }
        if height != 0 { heightAnchor.constraint(equalToConstant: height).isActive = true }
    }
    
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}
