//
//  MainViewModel.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-10-11.
//

import Foundation

class MainViewModel: ObservableObject {
    
    @Published var selectedWeeklyScheduleID: UUID?
    
    init() {
        selectedWeeklyScheduleID = getSelectedWeeklyScheduleIdFromPrefs()
    }
    
    func getSelectedWeeklyScheduleIdFromPrefs() -> UUID? {
        
        guard let scheduleIDString = Preferences.shared.getSelectedWeeklyScheduleID() else { return nil }
        return UUID(uuidString: scheduleIDString)
    }
    
    func selectWeeklySchedule(_ weeklySchedule: WeeklySchedule) {
        
        guard let id = weeklySchedule.id else { return }
        
        selectedWeeklyScheduleID = id
        Preferences.shared.saveSelectedWeeklySchedule(withID: id.uuidString)
    }
    
    func unselectWeeklySchedule() {
        
        self.selectedWeeklyScheduleID = nil
        Preferences.shared.clearSelectedWeeklySchedule()
    }
}
