//
//  Archive+CoreDataClass.swift
//  WeeklyHabitTracker
//
//  Created by Jason Wang on 6/12/20.
//  Copyright © 2020 Jason Wang. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Archive)
public class Archive: NSManagedObject {
    func reset() {
        self.completedTotal = 0
        self.failedTotal = 0
        self.incompleteTotal = 0
        
        self.habit.resetStatuses()
        self.habit.updateButtonState(toState: false)
        
        if let array = self.archivedHabits?.array as? [ArchivedHabit] {
            for archivedHabit in array {
                PersistenceService.shared.delete(archivedHabit)
            }
        }
        updateCurrentWeekNumber(to: 1)
        createNewArchivedHabit(withStatuses: self.habit.statuses, andDate: CalUtility.getCurrentDate(), andDay: CalUtility.getCurrentDay())
    }
    
    func restore() {
        updateActive(toState: true)
        self.habit = createNewHabit()
    }
    
    func updateCurrentArchivedHabit(toStatus status: Status, atIndex index: Int) {
        if let archivedHabit = self.archivedHabits?.lastObject as? ArchivedHabit {
            archivedHabit.updateStatus(toStatus: status, atIndex: index)
        }
    }
    
    func updateCurrentArchivedHabit(withStatuses statuses: [Status]) {
        if let archivedHabit = self.archivedHabits?.lastObject as? ArchivedHabit {
            archivedHabit.updateStatuses(toStatuses: statuses)
        }
    }
    
    func updateActive(toState state: Bool) {
        self.active = state
    }
    
    func updateCurrentWeekNumber(to num: Int64? = nil) {
        if let number = num {
            self.currentWeekNumber = number
        } else {
            self.currentWeekNumber += 1
        }
    }
    
    func updateStats(fromStatus oldStatus: Status, toStatus newStatus: Status) {
        switch oldStatus {
        case .completed:
            switch newStatus {
            case .completed: ()
            case .failed: self.completedTotal -= 1; self.failedTotal += 1
            case .incomplete: self.completedTotal -= 1; self.incompleteTotal += 1
            case .empty: self.completedTotal -= 1
            }
        case .failed:
            switch newStatus {
            case .completed: self.failedTotal -= 1; self.completedTotal += 1
            case .failed: ()
            case .incomplete: self.failedTotal -= 1; self.incompleteTotal += 1
            case .empty: self.failedTotal -= 1
            }
        case .incomplete:
            switch newStatus {
            case .completed: self.incompleteTotal -= 1; self.completedTotal += 1
            case .failed: self.incompleteTotal -= 1; self.failedTotal += 1
            case .incomplete: ()
            case .empty: self.incompleteTotal -= 1
            }
        case .empty:
            switch newStatus {
            case .completed: self.completedTotal += 1
            case .failed: self.failedTotal += 1
            case .incomplete: self.incompleteTotal += 1
            case .empty: ()
            }
        }
        
        let total = Double(self.completedTotal + self.failedTotal)
        if total != 0 { self.successRate = Double(self.completedTotal) / total }
        else { self.successRate = 1.0 }
    }
    
    func createNewArchivedHabit(withStatuses statuses: [Status], andDate date: Date, andDay day: Int) {
        let archivedHabit = ArchivedHabit(context: PersistenceService.shared.context)
        archivedHabit.archive = self
        archivedHabit.statuses = statuses
        archivedHabit.startDate = CalUtility.getFirstDateOfWeek(fromDate: date, andDay: day)
        archivedHabit.endDate = CalUtility.getLastDateOfWeek(fromDate: date, andDay: day)
        archivedHabit.weekNumber = self.currentWeekNumber
        insertIntoArchivedHabits(archivedHabit, at: 0)
    }
    
    func createNewHabit() -> Habit {
        let newHabit = Habit(context: PersistenceService.shared.context)
        newHabit.title = self.title
        newHabit.color = self.color
        newHabit.priority = self.priority
        newHabit.reminder = self.reminder
        newHabit.flag = self.flag
        newHabit.goal = self.goal
        newHabit.dateCreated = CalUtility.getCurrentDate()
        newHabit.uniqueID = UUID().uuidString
        newHabit.archive = self
        
        if let archivedHabit = self.archivedHabits?.lastObject as? ArchivedHabit {
            var days = [Bool]()
            var statuses = [Status]()
            for status in archivedHabit.statuses {
                if status != .empty { days.append(true) }
                else { days.append(false) }
            }
            newHabit.days = days
            
            if CalUtility.getCurrentDate() > archivedHabit.endDate {
                for day in days {
                    if day { statuses.append(.incomplete); updateStats(fromStatus: .empty, toStatus: .incomplete) }
                    else { statuses.append(.empty) }
                }
                newHabit.statuses = statuses
                newHabit.buttonState = false
                createNewArchivedHabit(withStatuses: statuses, andDate: CalUtility.getCurrentDate(), andDay: CalUtility.getCurrentDay())
            } else {
                newHabit.statuses = archivedHabit.statuses
                if newHabit.statuses[CalUtility.getCurrentDay()] == .completed || newHabit.statuses[CalUtility.getCurrentDay()] == .failed {
                    newHabit.buttonState = true
                } else {
                    newHabit.buttonState = false
                }
            }
        }
        
        return newHabit
    }
    
    func stringRepresentation() -> String {
        var stringRepresentation = String()
        stringRepresentation = """
        \ttitle: \(self.title)
        \tcolor: \(self.color)
        \tflag: \(self.flag)
        \tpriority: \(self.priority)
        \treminder: \(CalUtility.getTimeAsString(time: self.reminder))
        \tgoal: \(self.goal)
        \tactive: \(self.active)
        \tsuccessRate: \(self.successRate)
        \tcompletedTotal: \(self.completedTotal)
        \tfailedTotal: \(self.failedTotal)
        \tincompleteTotal: \(self.incompleteTotal)
        \tcurrentWeekNumber: \(self.currentWeekNumber)
        \tarchivedHabits: \n \(getArchivedHabitsAsString())
        """
        return stringRepresentation
    }
    
    private func getArchivedHabitsAsString() -> String {
        var string = ""
        let archivedHabits = self.archivedHabits?.array as? [ArchivedHabit]
        archivedHabits?.forEach( { string += "\($0.stringRepresentation())\n\n" } )
        return string
    }
}
