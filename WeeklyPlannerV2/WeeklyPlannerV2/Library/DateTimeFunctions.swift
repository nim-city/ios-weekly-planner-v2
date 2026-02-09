//
//  DateTimeFunctions.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-09-18.
//

import Foundation

class DateTimeFunctions {
    
    private init() {}
    
    static let dailyScheduleHours: [Int] = Array(0...24)
    
    static func getHoursStringForHour(_ hour: Int) -> String {
        
        if hour == 0 {
            return "12 am"
        } else if hour == 12 {
            return "12 pm"
        } else if hour < 12 {
            return "\(hour) am"
        } else {
            return "\(hour - 12) pm"
        }
    }
    
    private static var adjustedCurrentWeekday: Int {
        let today = Date()
        var currentWeekday = Calendar.current.component(.weekday, from: today)
        
        // Weekday comes back as 1 for Sunday, 2 for Monday... so Move Sunday's value from 1 -> 8 to put it at the end of the week
        if currentWeekday == 1 {
            currentWeekday = 8
        }
        // Shift weekdays down one from 2, 3, ... to 1, 2, ...
        return currentWeekday - 1
    }
    
    static var weekStartDate: Date? {
        let currentWeekday = adjustedCurrentWeekday - 1
        return Calendar.current.date(byAdding: .day, value: -currentWeekday, to: Date())
    }
    
    static var weekEndDate: Date? {
        
        guard let weekStartDate else {
            return nil
        }
        
        return Calendar.current.date(byAdding: .day, value: 6, to: weekStartDate)
    }
    
    static var currentWeekdayIndex: Int {
        adjustedCurrentWeekday - 1
    }
    
    static func getShortDateString(fromDate date: Date) -> String {
        let day = Calendar.current.component(.day, from: date)
        let month = Calendar.current.component(.month, from: date) - 1
        let monthName = Calendar.current.shortMonthSymbols[month]
        
        return "\(monthName) \(day)"
    }
}
