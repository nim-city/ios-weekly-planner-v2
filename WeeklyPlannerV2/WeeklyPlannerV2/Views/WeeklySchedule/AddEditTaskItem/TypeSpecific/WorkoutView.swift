//
//  WorkoutView.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-10-27.
//

import SwiftUI

extension AddEditTaskItemView {
    
    struct WorkoutView: View {
        
        let texts = WorkoutCategory.allCases.map(\.displayValue.capitalized)
        @Binding var selectedCategory: WorkoutCategory
        
        var body: some View {
            HStack {
                
                Text("Workout Category")
                    .font(AppFonts.formHeading)
                
                Spacer()
                
                DropdownMenu(texts: texts, selectedIndex: Binding(get: {
                    WorkoutCategory.allCases.firstIndex(of: selectedCategory) ?? 0
                }, set: { newIndex in
                    selectedCategory = WorkoutCategory.allCases[newIndex]
                }), backgroundColor: AppColours.getColourForTaskItemType(.workout).opacity(0.2))
            }
        }
    }
}
