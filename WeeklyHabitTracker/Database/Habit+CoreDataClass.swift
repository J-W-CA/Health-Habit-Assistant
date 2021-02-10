//
//  Habit+CoreDataClass.swift
//  WeeklyHabitTracker
//
//  Created by Jason Wang on 6/12/20.
//  Copyright © 2020 Jason Wang. All rights reserved.
//
//

import Foundation
import CoreData


public class Habit: NSManagedObject {
    func checkBoxPressed(fromStatus oldStatus: Status, toStatus newStatus: Status, atIndex index: Int, withState state: Bool?) {
        updateStatus(toStatus: newStatus, atIndex: index)
        if let buttonState = state { updateButtonState(toState: buttonState) }
        self.archive.updateCurrentArchivedHabit(toStatus: newStatus, atIndex: index)
        self.archive.updateStats(fromStatus: oldStatus, toStatus: newStatus)
    }
    
    func dayChanged(toDay newDay: Int) {
        if self.statuses[newDay - 1] == .incomplete {
            updateStatus(toStatus: .failed, atIndex: newDay - 1)
            self.archive.updateCurrentArchivedHabit(toStatus: .failed, atIndex: newDay - 1)
            self.archive.updateStats(fromStatus: .incomplete, toStatus: .failed)
        }
        
        if self.statuses[newDay] == .completed || self.statuses[newDay] == .failed {
            updateButtonState(toState: true)
        } else if self.statuses[newDay] == .incomplete {
            updateButtonState(toState: false)
        }
    }
    
    func weekChanged(toDate date: Date, andDay day: Int) {
        if self.statuses[6] == .incomplete {
            updateStatus(toStatus: .failed, atIndex: 6)
            self.archive.updateCurrentArchivedHabit(toStatus: .failed, atIndex: 6)
            self.archive.updateStats(fromStatus: .incomplete, toStatus: .failed)
        }
        
        resetStatuses()
        
        updateButtonState(toState: false)
        
        self.archive.updateCurrentWeekNumber()
        self.archive.createNewArchivedHabit(withStatuses: self.statuses, andDate: date, andDay: day)
    }
    
    func resetStatuses() {
        for (index, status) in self.statuses.enumerated() {
            if status != .empty {
                updateStatus(toStatus: .incomplete, atIndex: index)
                self.archive.updateStats(fromStatus: .empty, toStatus: .incomplete)
            }
        }
    }
    
    func updateStatus(toStatus status: Status, atIndex index: Int) {
        self.statuses[index] = status
    }
    
    func updateButtonState(toState state: Bool) {
        self.buttonState = state
    }
    
    func stringRepresentation() -> String {
        var stringRepresentation = String()
        stringRepresentation = """
        title: \(self.title!)
        color: \(self.color)
        days: \(self.days)
        statuses: \(getStatusesAsString())
        button state: \(self.buttonState)
        flag: \(self.flag)
        priority: \(self.priority)
        reminder: \(CalUtility.getTimeAsString(time: self.reminder))
        date created: \(self.dateCreated)
        unique ID: \(self.uniqueID)
        archive: \n\(self.archive.stringRepresentation())
        """
        return stringRepresentation
    }
    
    private func getStatusesAsString() -> String {
        var string = ""
        self.statuses.forEach( { string += "\(String($0.rawValue)) " } )
        return string
    }
}
