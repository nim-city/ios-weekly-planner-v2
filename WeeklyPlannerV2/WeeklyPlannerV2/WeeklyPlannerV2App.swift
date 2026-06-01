//
//  WeeklyPlannerV2App.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-09-06.
//

import SwiftUI

@main
struct WeeklyPlannerV2App: App {
    
    let persistenceController = PersistenceController.shared
    
    init() {
        
        performStartupTasks()
        
        setupUI()
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}


// MARK: - Startup tasks


extension WeeklyPlannerV2App {
    
    private func performStartupTasks() {
        
        // Delete completed tasks if should delete completed tasks functionality is toggled on
        // It's fine to only call this upon startup as this app will likely not run for a long time
        // and user can manually clear completed items if desired
        let shouldDeleteCompletedTasks = Preferences.shared.getShouldDeleteCompletedTasks()
        if shouldDeleteCompletedTasks {
            // Not worth handling errors here
            try? DeleteCompletedTasksService.deleteCompletedTasksFromPreviousWeeks(withContext: persistenceController.container.viewContext)
        }
    }
    
    private func setupUI() {
        
        // Set tab bar appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
