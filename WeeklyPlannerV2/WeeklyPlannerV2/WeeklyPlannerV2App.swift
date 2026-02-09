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
        
        // Set tab bar appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
