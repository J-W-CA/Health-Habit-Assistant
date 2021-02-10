//
//  FormingColors.swift
//  WeeklyHabitTracker
//
//  Created by Jason Wang on 4/17/20.
//  Copyright © 2020 Jason Wang. All rights reserved.
//

import UIKit

struct FormingColors {
    static func getColor(fromValue value: Int64) -> UIColor {
        switch value {
            case 0: return UIColor.systemGreen
            case 1: return UIColor.systemTeal
            case 2: return UIColor.systemRed
            case 3: return UIColor.systemBlue
            case 4: return UIColor.systemGray
            case 5: return UIColor.systemPink
            case 6: return UIColor.systemIndigo
            case 7: return UIColor.systemOrange
            case 8: return UIColor.systemYellow
            case 9: return UIColor.systemPurple
            default: return UIColor.white
        }
    }
}
