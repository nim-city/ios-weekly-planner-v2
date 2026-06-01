//
//  SettingsView.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-12-01.
//

import SwiftUI

struct SettingsView: View {
    
    private enum Constants {
        enum Padding {
            static let allAround: CGFloat = 20
            static let top: CGFloat = 20
        }
        enum Spacing {
            static let mainVertical: CGFloat = 40
        }
    }
    
    @Environment(\.managedObjectContext) private var moc
    let weeklySchedule: WeeklySchedule
    let changeScheduleAction: () -> Void
    
    @State private var shouldDeleteCompletedTasks: Bool = false
    @State private var isPresentingDeleteCompletedTasksAlert: Bool = false
    @State private var isPresentingEditScheduleSheet: Bool = false
    @State private var isPresentingDeleteScheduleAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Constants.Spacing.mainVertical) {
                    
                    deleteCompletedTasksView
                        .padding(.top, Constants.Padding.top)
                    
                    updateScheduleView
                    
                    changeScheduleView
                    
                    deleteScheduleView
                        .padding(.top, Constants.Padding.top)
                }
                .padding(Constants.Padding.allAround)
            }
            .navigationTitle("Settings")
            
            // Edit schedule sheet
            .sheet(isPresented: $isPresentingEditScheduleSheet) {
                AddEditWeeklyScheduleView(weeklySchedule: weeklySchedule)
            }
            
            // Delete completed items alert
            .alert("Auto delete tasks?", isPresented: $isPresentingDeleteCompletedTasksAlert) {
                Button("No", role: .cancel) {
                    shouldDeleteCompletedTasks = false
                }
                Button("Yes", role: .destructive) {
                    setDeleteCompletedItems(to: true)
                }
            } message: {
                Text("By enabling auto-delete, tasks completed in previous weeks will be deleted upon startup")
            }
            
            // Delete schedule alert
            .alert("Delete schedule", isPresented: $isPresentingDeleteScheduleAlert) {
                Button("No", role: .cancel) {}
                Button("Yes", role: .destructive) {
                    deleteWeeklySchedule()
                }
            } message: {
                Text("Are you sure you want to delete this schedule?")
            }
        }
        .tint(AppColours.getColourForWeeklySchedule(weeklySchedule))
    }
}


// MARK: - Subviews


extension SettingsView {
    
    private var deleteCompletedTasksView: some View {
        HStack {
            Text("Clear tasks automatically")
                .font(AppFonts.controlLabel)
                .layoutPriority(1)
            
            Spacer()
            
            Toggle("", isOn: $shouldDeleteCompletedTasks)
            .onAppear {
                shouldDeleteCompletedTasks = Preferences.shared.getShouldDeleteCompletedTasks()
            }
            .onChange(of: shouldDeleteCompletedTasks) { _, newValue in
                
                if newValue {
                    isPresentingDeleteCompletedTasksAlert = true
                } else {
                    setDeleteCompletedItems(to: false)
                }
            }
        }
    }
    
    private var updateScheduleView: some View {
        Button {
            isPresentingEditScheduleSheet = true
        } label: {
            Text("Update schedule")
                .font(AppFonts.controlLabel)
        }
    }
    
    private var changeScheduleView: some View {
        Button {
            changeScheduleAction()
        } label: {
            Text("Change current schedule")
                .font(AppFonts.controlLabel)
        }
    }
    
    private var deleteScheduleView: some View {
        Button {
            isPresentingDeleteScheduleAlert = true
        } label: {
            Text("Delete schedule")
                .font(AppFonts.controlLabel)
                .tint(.red)
        }
        .frame(maxWidth: .infinity)
    }
}


// MARK: - Functionality


extension SettingsView {
    
    private func getShouldDeleteCompletedItems() -> Bool {
        Preferences.shared.getShouldDeleteCompletedTasks()
    }
    
    private func setDeleteCompletedItems(to shouldDelete: Bool) {
        Preferences.shared.saveShouldDeleteCompletedTasks(shouldDelete)
    }
    
    private func deleteWeeklySchedule() {
        do {
            try DeleteWeeklyScheduleService.deleteWeeklySchedule(weeklySchedule, withContext: moc)
            changeScheduleAction()
        } catch let error {
            print(error)
        }
    }
}


// MARK: - Previews


struct WeeklyScheduleSettingsView_Previews: PreviewProvider {
    
    static let previewContext = PersistenceController.preview.container.viewContext
    static let weeklySchedule = PersistenceController.createMockWeeklySchedule(moc: previewContext)
    
    static var previews: some View {
        SettingsView(weeklySchedule: weeklySchedule) {}
            .environment(\.managedObjectContext, previewContext)
    }
}
