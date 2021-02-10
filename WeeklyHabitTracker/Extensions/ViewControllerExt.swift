//
//  ViewControllerExt.swift
//  WeeklyHabitTracker
//
//  Created by Jason Wang on 7/6/20.
//  Copyright © 2020 Jason Wang. All rights reserved.
//

import UIKit


extension UIViewController {
    var topbarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
}
