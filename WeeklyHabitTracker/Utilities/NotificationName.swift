//
//  NotificationName.swift
//  WeeklyHabitTracker
//
//  Created by Jason Wang on 7/9/20.
//  Copyright © 2020 Jason Wang. All rights reserved.
//

import Foundation

enum NotificationName: String {
    case newDay = "newDay"
    case habits = "habits"
    case history = "history"
    case archiveDetail = "archiveDetail"
    case archivedHabitDetail = "archivedHabitDetail"
    case historyStartedSearching = "historyStartedSearching"
    case historyStoppedSearching = "historyStoppedSearching"
    case finishHabitFromNotes = "finishHabitFromNotes"
}
