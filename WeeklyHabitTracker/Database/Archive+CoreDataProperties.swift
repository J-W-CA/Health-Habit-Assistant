//
//  Archive+CoreDataProperties.swift
//  WeeklyHabitTracker
//
//  Created by Jason Wang on 6/12/20.
//  Copyright © 2020 Jason Wang. All rights reserved.
//
//

import Foundation
import CoreData


extension Archive {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Archive> {
        return NSFetchRequest<Archive>(entityName: "Archive")
    }

    @NSManaged public var archivedHabits: NSOrderedSet?
    @NSManaged public var habit: Habit
    @NSManaged public var title: String
    @NSManaged public var color: Int64
    @NSManaged public var active: Bool
    @NSManaged public var successRate: Double
    @NSManaged public var completedTotal: Int64
    @NSManaged public var failedTotal: Int64
    @NSManaged public var incompleteTotal: Int64
    @NSManaged public var flag: Bool
    @NSManaged public var priority: Int64
    @NSManaged public var reminder: Date?
    @NSManaged public var goal: Int64
    @NSManaged public var currentWeekNumber: Int64

}

// MARK: Generated accessors for archivedHabits
extension Archive {

    @objc(insertObject:inArchivedHabitsAtIndex:)
    @NSManaged public func insertIntoArchivedHabits(_ value: ArchivedHabit, at idx: Int)

    @objc(removeObjectFromArchivedHabitsAtIndex:)
    @NSManaged public func removeFromArchivedHabits(at idx: Int)

    @objc(insertArchivedHabits:atIndexes:)
    @NSManaged public func insertIntoArchivedHabits(_ values: [ArchivedHabit], at indexes: NSIndexSet)

    @objc(removeArchivedHabitsAtIndexes:)
    @NSManaged public func removeFromArchivedHabits(at indexes: NSIndexSet)

    @objc(replaceObjectInArchivedHabitsAtIndex:withObject:)
    @NSManaged public func replaceArchivedHabits(at idx: Int, with value: ArchivedHabit)

    @objc(replaceArchivedHabitsAtIndexes:withArchivedHabits:)
    @NSManaged public func replaceArchivedHabits(at indexes: NSIndexSet, with values: [ArchivedHabit])

    @objc(addArchivedHabitsObject:)
    @NSManaged public func addToArchivedHabits(_ value: ArchivedHabit)

    @objc(removeArchivedHabitsObject:)
    @NSManaged public func removeFromArchivedHabits(_ value: ArchivedHabit)

    @objc(addArchivedHabits:)
    @NSManaged public func addToArchivedHabits(_ values: NSOrderedSet)

    @objc(removeArchivedHabits:)
    @NSManaged public func removeFromArchivedHabits(_ values: NSOrderedSet)

}
