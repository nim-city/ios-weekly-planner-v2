//
//  GoalView.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-10-27.
//

import SwiftUI

extension AddEditTaskItemView {
    
    struct GoalView: View {

        @Binding var selectedCategory: GoalCategory
        
        private var texts: [String] {
            GoalCategory.allCases.map { $0.displayValue.capitalized }
        }
        
        var body: some View {
            HStack {
                
                Text("Goal Category")
                    .font(AppFonts.formHeading)
                
                Spacer()
                
                DropdownMenu(texts: texts, selectedIndex: Binding(get: {
                    GoalCategory.allCases.firstIndex(of: selectedCategory) ?? 0
                }, set: { newIndex in
                    selectedCategory = GoalCategory.allCases[newIndex]
                }))
            }
        }
    }
}
