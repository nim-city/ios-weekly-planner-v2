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

    private var weeklySchedule: WeeklySchedule? {
        weeklySchedules.first
    }
    
    private var themeColour: Color {
        AppColours.getColourForWeeklySchedule(weeklySchedule)
    }
    
    init(weeklySchedule: WeeklySchedule, changeScheduleAction: @escaping () -> Void) {
        
        let weeklySchedulesPredicate = NSPredicate(format: "self == %@", weeklySchedule)
        _weeklySchedules = FetchRequest(sortDescriptors: [], predicate: weeklySchedulesPredicate)
        
        self.changeScheduleAction = changeScheduleAction
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
                    WeeklyScheduleSettingsView(weeklySchedule: weeklySchedule, changeScheduleAction: changeScheduleAction)
                }
            }
            .tint(themeColour)
        }
    }
}
