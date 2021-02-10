//
//  UNUserNotificationCenterExt.swift
//  WeeklyHabitTracker
//
//  Created by Jason Wang on 7/7/20.
//  Copyright © 2020 Jason Wang. All rights reserved.
//

import Foundation
import UserNotifications

extension UNUserNotificationCenter {
    func createNotificationRequest(forHabit habit: Habit) {
        if let reminder = habit.reminder, let title = habit.title {
            for (index, day) in habit.days.enumerated() {
                if day {
                    let content = UNMutableNotificationContent()
                    content.title = "Habit Reminder: \(title)"
                    content.body = "You have a \(CalUtility.getTimeAsString(time: reminder)) daily reminder set for this habit."
                    content.sound = UNNotificationSound.default
                    content.categoryIdentifier = "alarm"
                    content.userInfo = ["customData": habit.uniqueID]
                    let trigger = UNCalendarNotificationTrigger(dateMatching: CalUtility.getReminderComps(time: reminder, weekday: index + 1), repeats: true)
                    add(UNNotificationRequest(identifier: "\(habit.uniqueID)-\(String(index))", content: content, trigger: trigger))
                }
            }
        }
    }
    
    func deleteNotificationRequests(forDays days: [Bool], andUniqueID id: String) {
        var identifiers = [String]()
        for (index, day) in days.enumerated() {
            if day { identifiers.append("\(id)-\(String(index))") }
        }
        removePendingNotificationRequests(withIdentifiers: identifiers)
        removeDeliveredNotifications(withIdentifiers: identifiers)
    }
}

