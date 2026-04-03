//
//  ToBuyItemView.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-10-27.
//

import SwiftUI


extension AddEditTaskItemView {
    
    struct ToBuyItemView: View {
        
        private enum Constants {
            enum Spacing {
                static let mainVertical: CGFloat = 20
            }
        }
        
        @Binding var selectedCategory: ToBuyItemCategory
        @Binding var selectedPriority: TaskItemPriority
        
        private var categoryTexts: [String] {
            ToBuyItemCategory.allCases.map { $0.displayValue.capitalized }
        }
        
        private var priorityTexts: [String] {
            TaskItemPriority.allCases.map { $0.displayValue.capitalized }
        }
        
        var body: some View {
            VStack(spacing: Constants.Spacing.mainVertical) {
                
                categoryView
                
                priorityView
            }
        }
    }
}


// MARK: - Subviews


extension AddEditTaskItemView.ToBuyItemView {
    
    var categoryView: some View {
        HStack {
            
            Text("Category")
                .font(AppFonts.formHeading)
            
            Spacer()
            
            DropdownMenu(texts: categoryTexts,
                         selectedIndex: Binding(get: {
                ToBuyItemCategory.allCases.firstIndex(of: selectedCategory) ?? 0
            }, set: {
                selectedCategory = ToBuyItemCategory.allCases[$0]
            }), backgroundColor: AppColours.getColourForTaskItemType(.toBuyItem).opacity(0.2))
        }
    }
    
    var priorityView: some View {
        HStack {
            
            Text("Priority")
                .font(AppFonts.formHeading)
            
            Spacer()
            
            DropdownMenu(texts: priorityTexts,
                         selectedIndex: Binding(get: {
                TaskItemPriority.allCases.firstIndex(of: selectedPriority) ?? 0
            }, set: {
                selectedPriority = TaskItemPriority.allCases[$0]
            }), backgroundColor: AppColours.getColourForTaskItemType(.toBuyItem).opacity(0.2))
        }
    }
}


// MARK: - Previews


#Preview {
    AddEditTaskItemView(viewModel: .init(itemType: .toBuyItem))
}
