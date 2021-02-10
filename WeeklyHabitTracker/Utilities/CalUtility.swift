//
//  CalendarManager.swift
//  WeeklyHabitTracker
//
//  Created by Jason Wang on 4/14/20.
//  Copyright © 2020 Jason Wang. All rights reserved.
//

import Foundation

class CalUtility {
    static func getCurrentDay(fromDate date: Date? = nil) -> Int {
//        let day = Date()
//        let calendar = Calendar.current
//        return calendar.component(.weekday, from: day) - 1
        if let day = date {
            return Calendar.current.component(.weekday, from: day) - 1
        } else {
            return Calendar.current.component(.weekday, from: Date()) - 1
        }
    }
    
    static func getCurrentWeek() -> [String] {
        let date = Date()
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        var days = Array(repeating: "", count: 7)
        let currentDay = getCurrentDay()
        
        days[currentDay] = dateFormatter.string(from: date)

        for index in 0..<currentDay {
            if let day = calendar.date(byAdding: .day, value: index - currentDay, to: date) {
                days[index] = dateFormatter.string(from: day)
            }
        }
        
        for index in 0..<(6 - currentDay) {
            if let day = calendar.date(byAdding: .day, value: index + 1, to: date) {
                days[index + currentDay + 1] = dateFormatter.string(from: day)
            }
        }
        
        return days
    }
    
    static func getTimeAsString(time: Date?) -> String {
        guard let unwrappedTime = time else { return "nil" }
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter.string(from: unwrappedTime)
    }
    
    static func getDateAsString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    static func getDateAsShortString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    static func getTimeAsDate(time: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        if let date = formatter.date(from: time) {
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            let minutes = calendar.component(.minute, from: date)
            return calendar.date(bySettingHour: hour, minute: minutes, second: 0, of: date)
        } else { return nil }
    }
    
    static func getFutureDate() -> Date {
        guard let date = Calendar.current.date(byAdding: .year, value: 100, to: getCurrentDate()) else {
            fatalError("Get future date error.")
        }
        return date
    }
    
    static func getCurrentDate() -> Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: Date())) else {
            fatalError("Get current date error.")
        }
        return date
    }
    
    static func getReminderComps(time: Date, weekday: Int) -> DateComponents {
        let calendar = Calendar.current
        var components = DateComponents()
        components.hour = calendar.component(.hour, from: time)
        components.minute = calendar.component(.minute, from: time)
        components.weekday = weekday
        return components
    }
    
    static func getFirstDateOfWeek(fromDate: Date, andDay day: Int) -> Date {
        guard let date = Calendar.current.date(byAdding: .day, value: -(day), to: fromDate) else {
            fatalError("Get first date of week error.")
        }
        return date
    }
    
    static func getLastDateOfWeek(fromDate: Date, andDay day: Int) -> Date {
        guard let date = Calendar.current.date(byAdding: .day, value: (6 - day), to: fromDate) else {
            fatalError("Get last date of week error.")
        }
        return date
    }
    
    static func getDaysElapsed(fromOldDate oldDate: Date, toCurrentDate currentDate: Date) -> ([Int], [Date]) {
        var days = [Int]()
        var dates = [Date]()
        var fromDate = oldDate
        
        while fromDate < currentDate {
            fromDate = Calendar.current.date(byAdding: .day, value: 1, to: fromDate)!
            days.append(getCurrentDay(fromDate: fromDate))
            dates.append(fromDate)
        }
        
        return (days, dates)
    }
}
