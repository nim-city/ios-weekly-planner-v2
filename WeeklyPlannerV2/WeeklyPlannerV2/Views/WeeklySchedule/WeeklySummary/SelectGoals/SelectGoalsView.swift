//
//  SelectGoalsView.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-10-05.
//

import SwiftUI

struct SelectGoalsView: View {
    
    private enum Constants {
        enum Padding {
            static let addButtonPadding: CGFloat = 40
            static let dividerHorizontal: CGFloat = 14
            static let emptyListHorizontal: CGFloat = 40
            static let emptyListTop: CGFloat = 240
            static let main: CGFloat = 20
        }
        enum Sizing {
            static let borderWidth: CGFloat = 2
            static let mainCornerRadius: CGFloat = 20
        }
    }
    
//    private let weeklySchedule: WeeklySchedule
//    private let goalCategory: GoalCategory
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @FetchRequest(sortDescriptors: []) private var goals: FetchedResults<Goal>
    
    @StateObject private var viewModel: SelectGoalsViewModel
//    @State private var selectedGoals: [Goal] = []
    @State private var goalToEdit: Goal? = nil
    @State private var isPresentingAddEditGoalsSheet: Bool = false
    @State private var expandedListItemIndex: Int? = nil
    
    private var themeColour: Color {
        AppColours.getColourForWeeklySchedule(viewModel.weeklySchedule)
    }
    
    private var backgroundGradient: LinearGradient {
        .init(colors: [AppColours.getColourForTaskItemType(.goal).opacity(0.4),
                       AppColours.getColourForTaskItemType(.goal).opacity(0.6),
                       AppColours.getColourForTaskItemType(.goal).opacity(0.4)],
              startPoint: .topLeading,
              endPoint: .bottomTrailing)
    }
    
    private var displayGoals: [Goal] {
        goals.filter { $0.category == viewModel.goalCategory }
    }
    
//    private var title: String {
//        "Select \(goalCategory.displayValue) goals"
//    }
//    
//    private var emptyListText: String {
//        "No \(goalCategory.displayValue) goals yet"
//    }
    
    init(weeklySchedule: WeeklySchedule, goalCategory: GoalCategory) {
        
        self._viewModel = .init(wrappedValue: .init(weeklySchedule: weeklySchedule, goalCategory: goalCategory))
        
//        self.weeklySchedule = weeklySchedule
//        self.goalCategory = goalCategory
//        
//        switch goalCategory {
//        case .daily:
//            selectedGoals = weeklySchedule.dailyGoals
//        case .weekly:
//            selectedGoals = weeklySchedule.weeklyGoals
//        case .longTerm:
//            selectedGoals = []
//        }
        
        // Create fetch request
//        let predicate = NSPredicate(format: "categoryName == %@", goalCategory.rawValue)
//        _goals = FetchRequest(entity: Goal.entity(), sortDescriptors: [], predicate: predicate)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                GoalsCategorySelector(selectedCategory: $viewModel.goalCategory)
                    .padding(Constants.Padding.main)
                
                ScrollView {
                    
                    if displayGoals.isEmpty {
                        
                        Text(viewModel.emptyListText)
                            .font(AppFonts.detailLabel)
                            .italic()
                            .padding(.horizontal, Constants.Padding.emptyListHorizontal)
                            .padding(.top, Constants.Padding.emptyListTop)
                    } else {
                        
                        VStack(spacing: 0) {
                            ForEach(displayGoals.indices, id: \.self) { goalIndex in
                                
                                let goal = displayGoals[goalIndex]
                                let isBelowExpandedItem = goal == displayGoals.first || expandedListItemIndex == goalIndex - 1
                                let isAboveExpandedItem = goal == displayGoals.last || expandedListItemIndex == goalIndex + 1
                                let showDivider = goal != displayGoals.last && !isAboveExpandedItem && goalIndex != expandedListItemIndex
                                
                                SelectableTaskItemView(taskItem: goal,
                                                       taskItemType: .goal,
                                                       isSelected: viewModel.selectedGoals.contains(goal),
                                                       roundTop: isBelowExpandedItem,
                                                       roundBottom: isAboveExpandedItem,
                                                       showDivider: showDivider,
                                                       isExpanded: Binding(get: { goalIndex == self.expandedListItemIndex },
                                                                           set: {
                                    if $0 {
                                        self.expandedListItemIndex = goalIndex
                                    } else {
                                        self.expandedListItemIndex = nil
                                    }
                                })) {
                                    viewModel.selectGoal(goal)
                                }
                                .onLongPressGesture {
                                    selectGoalToEdit(goal)
                                }
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.mainCornerRadius))
                        .bottomRightShadow()
                        .padding(.vertical, Constants.Padding.main)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(backgroundGradient)
            
            // Navigation bar
            .sheetHeader(title: viewModel.title,
                         cancelButtonStyle: .close,
                         cancelAction: pressCancelButton,
                         saveAction: pressSaveButton)
            .tint(.goalDarkened)
            
            .overlay(alignment: .bottomTrailing) {
                
                FloatingAddButtonView {
                    isPresentingAddEditGoalsSheet = true
                }
                .padding(.trailing, Constants.Padding.addButtonPadding)
                .padding(.bottom, Constants.Padding.addButtonPadding)
            }
            
            // Add task item sheet
            .sheet(isPresented: $isPresentingAddEditGoalsSheet) {
                AddEditTaskItemView(viewModel: .init(itemType: .goal))
            }
            
            // Edit task item sheet
            .sheet(item: $goalToEdit) { goal in
                AddEditTaskItemView(viewModel: .init(itemToEdit: goal))
            }
        }
    }
    
    func pressCancelButton() {
        dismiss()
    }
    
    func pressSaveButton() {
        if viewModel.saveGoals(moc: moc) {
            dismiss()
        }
    }
    
    private func selectGoalToEdit(_ goal: Goal) {
        
        AppAnimations.makeLongPressFeedback()
        
        goalToEdit = goal
    }
}


// MARK: - Previews


struct SelectGoalsView_Previews: PreviewProvider {
    
    static let previewContext = PersistenceController.preview.container.viewContext
    static let weeklySchedule = PersistenceController.createMockWeeklySchedule(moc: previewContext)
    
    static var previews: some View {
        Color.clear
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .sheet(isPresented: .constant(true)) {
                SelectGoalsView(weeklySchedule: weeklySchedule, goalCategory: .daily)
                    .environment(\.managedObjectContext, previewContext)
            }
    }
}
