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
    }
    
    static let shared = Preferences()
    
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    func getSelectedWeeklyScheduleID() -> String? {
        userDefaults.string(forKey: Keys.selectedWeeklyScheduleID)
    }
    
    func saveSelectedWeeklySchedule(withID id: String) {
        userDefaults.set(id, forKey: Keys.selectedWeeklyScheduleID)
    }
    
    func clearSelectedWeeklySchedule() {
        userDefaults.removeObject(forKey: Keys.selectedWeeklyScheduleID)
    }
}
