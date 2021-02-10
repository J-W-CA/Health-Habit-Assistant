//
//  ArchivedHabit+CoreDataProperties.swift
//  WeeklyHabitTracker
//
//  Created by Jason Wang on 6/12/20.
//  Copyright © 2020 Jason Wang. All rights reserved.
//
//

import Foundation
import CoreData


extension ArchivedHabit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArchivedHabit> {
        return NSFetchRequest<ArchivedHabit>(entityName: "ArchivedHabit")
    }

    @NSManaged public var startDate: Date
    @NSManaged public var endDate: Date
    @NSManaged public var notes: String?
    @NSManaged public var archive: Archive
    @NSManaged private var statusValues: Array<Int64>
    @NSManaged public var weekNumber: Int64

    public var statuses: [Status] {
        get {
            var array = [Status]()
            statusValues.forEach {
                if let status = Status(rawValue: $0) { array.append(status) }
            }
            return array
        }
        set {
            var array = [Int64]()
            newValue.forEach {
                array.append($0.rawValue)
            }
            self.statusValues = array
        }
    }
}
