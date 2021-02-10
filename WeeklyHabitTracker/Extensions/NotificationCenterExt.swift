//
//  NotificationCenterExt.swift
//  WeeklyHabitTracker
//
//  Created by Jason Wang on 7/9/20.
//  Copyright © 2020 Jason Wang. All rights reserved.
//

import Foundation

extension NotificationCenter {
    func reload(habits: Bool = false, history: Bool = false, archiveDetail: Bool = false, archivedHabitDetail: Bool = false) {
        if habits { post(name: NSNotification.Name(NotificationName.habits.rawValue), object: nil) }
        if history { post(name: NSNotification.Name(NotificationName.history.rawValue), object: nil) }
        if archiveDetail { post(name: NSNotification.Name(NotificationName.archiveDetail.rawValue), object: nil) }
        if archivedHabitDetail { post(name: NSNotification.Name(NotificationName.archivedHabitDetail.rawValue), object: nil) }
    }
}
