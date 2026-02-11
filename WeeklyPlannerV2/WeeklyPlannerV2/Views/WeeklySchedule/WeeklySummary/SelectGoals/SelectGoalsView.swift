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
            static let mainAllAround: CGFloat = 20
        }
        enum Sizing {
            static let borderWidth: CGFloat = 2
            static let mainCornerRadius: CGFloat = 20
        }
    }
    
    private let weeklySchedule: WeeklySchedule
    private let goalCategory: GoalCategory
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @FetchRequest private var goals: FetchedResults<Goal>
    
    @State private var selectedGoals: [Goal] = []
    @State private var goalToEdit: Goal? = nil
    @State private var isPresentingAddEditGoalsSheet: Bool = false
    
    private var themeColour: Color {
        AppColours.getColourForWeeklySchedule(weeklySchedule)
    }
    
    private var backgroundGradient: LinearGradient {
        .init(colors: [AppColours.getColourForTaskItemType(.goal).opacity(0.3),
                       AppColours.getColourForTaskItemType(.goal).opacity(0.7),
                       AppColours.getColourForTaskItemType(.goal).opacity(0.3)],
              startPoint: .topLeading,
              endPoint: .bottomTrailing)
    }
    
    private var title: String {
        "Select \(goalCategory.displayValue) goals"
    }
    
    private var emptyListText: String {
        "No \(goalCategory.displayValue) goals yet"
    }
    
    init(weeklySchedule: WeeklySchedule, goalCategory: GoalCategory) {
        
        self.weeklySchedule = weeklySchedule
        self.goalCategory = goalCategory
        
        switch goalCategory {
        case .daily:
            selectedGoals = weeklySchedule.dailyGoals
        case .weekly:
            selectedGoals = weeklySchedule.weeklyGoals
        case .longTerm:
            selectedGoals = []
        }
        
        // Create fetch request
        let predicate = NSPredicate(format: "categoryName == %@", goalCategory.rawValue)
        _goals = FetchRequest(entity: Goal.entity(), sortDescriptors: [], predicate: predicate)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                
                if goals.isEmpty {
                    
                    Text(emptyListText)
                        .font(AppFonts.detailLabel)
                        .italic()
                        .padding(.horizontal, Constants.Padding.emptyListHorizontal)
                        .padding(.top, Constants.Padding.emptyListTop)
                } else {
                    
                    VStack(spacing: 0) {
                        ForEach(goals) { goal in
                            
                            SelectableTaskItemView(taskItem: goal,
                                                   isSelected: selectedGoals.contains(goal),
                                                   onTap: { selectGoal(goal) })
                            .onLongPressGesture {
                                selectGoalToEdit(goal)
                            }
                            
                            if goal != goals.last {
                                Divider()
                                    .background(AppColours.dividerBold)
                                    .padding(.horizontal, Constants.Padding.dividerHorizontal)
                            }
                        }
                    }
                    .background(.white)
                    
                    .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.mainCornerRadius))
                    .overlay {
                        RoundedRectangle(cornerRadius: Constants.Sizing.mainCornerRadius)
                            .stroke(.black, lineWidth: Constants.Sizing.borderWidth)
                    }
                    .padding(Constants.Padding.mainAllAround)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(backgroundGradient)
            
            // Navigation bar
            .sheetHeader(title: title,
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
        saveGoals()
        dismiss()
    }
    
    func selectGoal(_ goal: Goal) {
        
        if let index = selectedGoals.firstIndex(of: goal) {
            selectedGoals.remove(at: index)
        } else {
            selectedGoals.append(goal)
        }
    }
    
    func saveGoals() {
        
        switch goalCategory {
        case .daily:
            weeklySchedule.addGoals(selectedGoals, category: .daily)
        case .weekly:
            weeklySchedule.addGoals(selectedGoals, category: .weekly)
        case .longTerm:
            return
        }
        
        do {
            try moc.save()
        } catch let error {
            print(error)
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
