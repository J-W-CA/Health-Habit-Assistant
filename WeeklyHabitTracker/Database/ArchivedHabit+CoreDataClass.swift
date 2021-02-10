//
//  ArchivedHabit+CoreDataClass.swift
//  WeeklyHabitTracker
//
//  Created by Jason Wang on 6/12/20.
//  Copyright © 2020 Jason Wang. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ArchivedHabit)
public class ArchivedHabit: NSManagedObject {
    func updateStatus(toStatus status: Status, atIndex index: Int) {
        self.statuses[index] = status
    }
    
    func updateStatuses(toStatuses statuses: [Status]) {
        self.statuses = statuses
    }
    
    func stringRepresentation() -> String {
        var stringRepresentation = String()
        stringRepresentation = """
        \t\tstartDate: \(self.startDate)
        \t\tendDate: \(self.endDate)
        \t\tweekNumber: \(self.weekNumber)
        \t\tnotes: \(String(describing: self.notes))
        \t\tstatuses: \(getStatusesAsString())
        """
        return stringRepresentation
    }
    
    private func getStatusesAsString() -> String {
        var string = ""
        self.statuses.forEach( { string += "\(String($0.rawValue)) " } )
        return string
    }
}
