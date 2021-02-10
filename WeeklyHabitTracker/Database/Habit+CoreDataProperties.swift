//
//  Habit+CoreDataProperties.swift
//  WeeklyHabitTracker
//
//  Created by Jason Wang on 6/12/20.
//  Copyright © 2020 Jason Wang. All rights reserved.
//
//

import Foundation
import CoreData


extension Habit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Habit> {
        return NSFetchRequest<Habit>(entityName: "Habit")
    }

    @NSManaged public var buttonState: Bool
    @NSManaged public var color: Int64
    @NSManaged public var dateCreated: Date
    @NSManaged public var days: Array<Bool>
    @NSManaged public var flag: Bool
    @NSManaged public var priority: Int64
    @NSManaged public var reminder: Date?
    @NSManaged private var statusValues: Array<Int64>
    @NSManaged public var title: String?
    @NSManaged public var uniqueID: String
    @NSManaged public var goal: Int64
    @NSManaged public var tracking: Bool
    @NSManaged public var archive: Archive
    
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
