//
//  ToBuyItemView.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-10-27.
//

import SwiftUI


extension AddEditTaskItemView {
    
    struct ToBuyItemView: View {
        
        @Binding var selectedPriority: TaskItemPriority
        
        private var texts: [String] {
            TaskItemPriority.allCases.map { $0.displayValue.capitalized }
        }
        
        var body: some View {
            HStack {
                
                Text("Priority")
                    .font(AppFonts.formHeading)
                
                Spacer()
                
                DropdownMenu(texts: texts,
                             selectedIndex: Binding(get: {
                    TaskItemPriority.allCases.firstIndex(of: selectedPriority) ?? 0
                }, set: {
                    selectedPriority = TaskItemPriority.allCases[$0]
                }))
            }
        }
    }
}


// MARK - Previews


#Preview {
    AddEditTaskItemView(viewModel: .init(itemType: .toBuyItem))
}
