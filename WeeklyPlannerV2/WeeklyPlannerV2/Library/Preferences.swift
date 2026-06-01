//
//  Preferences.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-10-06.
//

import Foundation

class Preferences {
    
    private enum Keys {
        static let selectedWeeklyScheduleID = "selected_weekly_schedule_id"
        static let shouldDeleteCompletedTasks = "should_delete_completed_tasks"
        static let showCompactDailySchedules = "show_compact_daily_schedules"
    }
    
    static let shared = Preferences()
    
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    
    // MARK: - Selected weekly schedule
    
    
    func getSelectedWeeklyScheduleID() -> String? {
        userDefaults.string(forKey: Keys.selectedWeeklyScheduleID)
    }
    
    func saveSelectedWeeklySchedule(withID id: String) {
        userDefaults.set(id, forKey: Keys.selectedWeeklyScheduleID)
    }
    
    func clearSelectedWeeklySchedule() {
        userDefaults.removeObject(forKey: Keys.selectedWeeklyScheduleID)
    }
    
    
    // MARK: - Auto delete completed task items
    
    
    func getShouldDeleteCompletedTasks() -> Bool {
        userDefaults.bool(forKey: Keys.shouldDeleteCompletedTasks)
    }
    
    func saveShouldDeleteCompletedTasks(_ enabled: Bool) {
        userDefaults.set(enabled, forKey: Keys.shouldDeleteCompletedTasks)
    }
    
    
    // MARK: - Show condensed daily schedules
    
    
    func getShowCompactDailySchedules() -> Bool {
        userDefaults.bool(forKey: Keys.showCompactDailySchedules)
    }
    
    func saveShowCompactDailySchedules(_ enabled: Bool) {
        userDefaults.set(enabled, forKey: Keys.showCompactDailySchedules)
    }
}
