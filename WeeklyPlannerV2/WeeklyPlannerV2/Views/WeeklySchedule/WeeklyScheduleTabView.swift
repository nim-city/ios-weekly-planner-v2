//
//  WeeklyScheduleTabView.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-09-07.
//

import SwiftUI

struct WeeklyScheduleTabView: View {
    
    @FetchRequest var weeklySchedules: FetchedResults<WeeklySchedule>
    let changeScheduleAction: () -> Void
    
    @State var themeColour: Color

    private var weeklySchedule: WeeklySchedule? {
        weeklySchedules.first
    }
    
    init(weeklySchedule: WeeklySchedule, changeScheduleAction: @escaping () -> Void) {
        
        let weeklySchedulesPredicate = NSPredicate(format: "self == %@", weeklySchedule)
        _weeklySchedules = FetchRequest(sortDescriptors: [], predicate: weeklySchedulesPredicate)
        
        self.changeScheduleAction = changeScheduleAction
        
        self.themeColour = AppColours.getColourForWeeklySchedule(weeklySchedule)
    }
    
    var body: some View {
        if let weeklySchedule {
            TabView {
                
                Tab("Summary", systemImage: "doc.text.magnifyingglass") {
                    WeeklySummaryView(weeklySchedule: weeklySchedule)
                }
                
                Tab("Day to day", systemImage: "calendar") {
                    WeeklyBreakdownView(weeklySchedule: weeklySchedule)
                }
                
                Tab("All tasks", systemImage: "list.bullet") {
                    TaskItemListsView(weeklySchedule: weeklySchedule)
                }
                
                Tab("Settings", systemImage: "gearshape.fill") {
                    SettingsView(weeklySchedule: weeklySchedule,
                                 updateScheduleAction: updateScheduleAction,
                                 changeScheduleAction: changeScheduleAction)
                }
            }
            .tint(themeColour)
        }
    }
    
    private func updateScheduleAction() {
        themeColour = AppColours.getColourForWeeklySchedule(weeklySchedule)
    }
}
