//
//  WeeklyScheduleTabView.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-09-07.
//

import SwiftUI

struct WeeklyScheduleTabView: View {
    
    let weeklySchedule: WeeklySchedule
    let changeScheduleAction: () -> Void
    
    private var themeColour: Color {
        AppColours.getColourForWeeklySchedule(weeklySchedule)
    }
    
    var body: some View {
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
