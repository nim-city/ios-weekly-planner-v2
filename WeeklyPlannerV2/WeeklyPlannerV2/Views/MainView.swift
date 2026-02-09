//
//  MainView.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-09-07.
//

import SwiftUI

struct MainView: View {

    @Environment(\.managedObjectContext) private var moc
    
    @StateObject var viewModel: MainViewModel = .init()
    
    private var selectedWeeklySchedule: WeeklySchedule? {
        guard let scheduleId = viewModel.selectedWeeklyScheduleID else { return nil }
        return fetchWeeklySchedule(byID: scheduleId)
    }
    
    var body: some View {
        Group {
            
            // Show schedule view if user has stored a selected weekly schedule Id
            // Otherwise, show a list of all previously created weekly schedules
            if let selectedWeeklySchedule {
                
                WeeklyScheduleTabView(weeklySchedule: selectedWeeklySchedule, changeScheduleAction: viewModel.unselectWeeklySchedule)
            } else {
                
                WeeklySchedulesListView(selectScheduleAction: viewModel.selectWeeklySchedule(_:))
            }
        }
    }
}


// MARK: - Functionality


extension MainView {
    
    func fetchWeeklySchedule(byID id: UUID) -> WeeklySchedule? {
        
        let request = WeeklySchedule.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        
        return try? moc.fetch(request).first
    }
}


// MARK: - Previews


//#Preview {
//    MainView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//}
