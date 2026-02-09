//
//  WeeklySummaryView.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-09-07.
//

import SwiftUI

struct WeeklySummaryView: View {
    
    private enum Constants {
        enum Padding {
            static let allAround: CGFloat = 20
            static let workoutsLeading: CGFloat = 6
        }
        enum Sizing {
            static let borderWidth: CGFloat = 0
            static let cornerRadius: CGFloat = 20
        }
        enum Spacing {
            static let goalViewVertical: CGFloat = 10
            static let mainVertical: CGFloat = 40
            static let subviewVertical: CGFloat = 10
            static let workoutsVertical: CGFloat = 8
        }
    }
    
    private let weeklySchedule: WeeklySchedule
    @FetchRequest var goals: FetchedResults<Goal>
    @FetchRequest var workouts: FetchedResults<Workout>
    @StateObject private var viewModel: WeeklySummaryViewModel
    
    @State private var selectedGoalCategory: GoalCategory? = nil
    @State private var goalToEdit: Goal?
    
    private var dailyGoals: [Goal] {
        goals.filter { $0.categoryName == GoalCategory.daily.rawValue }
    }
    
    private var weeklyGoals: [Goal] {
        goals.filter { $0.categoryName == GoalCategory.weekly.rawValue }
    }
    
    private var themeColour: Color {
        AppColours.getColourForWeeklySchedule(weeklySchedule)
    }
    
    init(weeklySchedule: WeeklySchedule) {
        
        self.weeklySchedule = weeklySchedule

        let goalsPredicate = NSPredicate(format: "ANY weeklySchedules == %@", weeklySchedule)
        _goals = FetchRequest(entity: Goal.entity(), sortDescriptors: [], predicate: goalsPredicate)
        
        let workoutsPredicate = NSPredicate(format: "ANY taskBlocks.dailySchedule IN %@", weeklySchedule.dailySchedulesList)
        _workouts = FetchRequest(entity: Workout.entity(), sortDescriptors: [], predicate: workoutsPredicate)
        
        _viewModel = .init(wrappedValue: .init(weeklySchedule: weeklySchedule))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Constants.Spacing.mainVertical) {
                    
                    // Date text
                    dateTextView
                    
                    highlightsView
                    
                    // Daily goals
                    GoalsList(goals: dailyGoals, category: .daily) {
                        selectedGoalCategory = .daily
                    } editGoalAction: { goal in
                        editGoal(goal)
                    }
                    
                    // Weekly goals
                    GoalsList(goals: weeklyGoals, category: .weekly) {
                        selectedGoalCategory = .weekly
                    } editGoalAction: { goal in
                        editGoal(goal)
                    }
                    
                    workoutsListView
                }
                .padding(Constants.Padding.allAround)
            }
            .tint(themeColour)
            
            // Navigation bar
            .navigationTitle(viewModel.title)
            
            // Select
            .sheet(item: $selectedGoalCategory) { category in
                SelectGoalsView(weeklySchedule: viewModel.weeklySchedule, goalCategory: category)
                    .presentationDetents([.large])
            }
            
            // Add edit task item sheet
            .sheet(item: $goalToEdit) { goal in
                AddEditTaskItemView(viewModel: .init(itemToEdit: goal))
            }
        }
    }
    
    private func editGoal(_ goal: Goal) {
        
        AppAnimations.makeLongPressFeedback()
        
        goalToEdit = goal
    }
}


// MARK: - Subviews


extension WeeklySummaryView {
    
    private var dateTextView: some View {
        Text(viewModel.dateText)
            .font(AppFonts.subtext)
            .foregroundStyle(.tint)
    }
    
    private var highlightsView: some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.subviewVertical) {
            
            Text("Highlights")
                .font(AppFonts.subtitle)
            
            if let workdaysText = viewModel.workdaysText {
                
                HStack {
                    Text("Working:")
                        .font(AppFonts.detailLabel)
                    Text(workdaysText)
                        .font(AppFonts.detailLabelBold)
                        .foregroundStyle(.tint)
                }
            } else {
                Text("No work scheduled, enjoy your time off!")
                    .font(AppFonts.detailLabel)
            }
        }
    }
    
    private var workoutsListView: some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.subviewVertical) {
            
            Text("Workouts")
                .font(AppFonts.subtitle)
            
            Group {
                if weeklySchedule.dailySchedulesList.isEmpty {
                    
                    Text("No workouts yet")
                        .italic()
                } else {
                    
                    VStack(alignment: .leading, spacing: Constants.Spacing.workoutsVertical) {
                        ForEach(weeklySchedule.dailySchedulesList) { dailySchedule in
                            
                            if dailySchedule.taskBlocksList.contains(where: { $0.category == .exercise }) {
                                
                                WorkoutsListViewItem(dailySchedule: dailySchedule)
                            }
                        }
                    }
                }
            }
            .padding(.leading, Constants.Padding.workoutsLeading)
        }
    }
    
    private struct WorkoutsListViewItem: View {
        
        private enum Constants {
            enum Sizing {
                static let weekdayLabelWidth: CGFloat = 50
            }
        }
        
        let dailySchedule: DailySchedule
        
        var body: some View {
            HStack {
                
                // Weekday label
                if let weekday = dailySchedule.weekday {
                    Text("• \(weekday.shortName):")
                        .font(AppFonts.detailLabelBold)
                        .frame(width: Constants.Sizing.weekdayLabelWidth)
                }
                
                // Workouts stack
                let workoutTaskBlocks = dailySchedule.taskBlocksList.filter { $0.category == .exercise }
                Group {
                    if workoutTaskBlocks.isEmpty {
                        Text("Rest day")
                    } else {
                        ForEach(workoutTaskBlocks) { taskBlock in
                            ForEach(taskBlock.taskItemsList) { taskItem in
                                Text(taskItem.name ?? taskBlock.name ?? "Workout")
                            }
                        }
                    }
                }
                .font(AppFonts.detailLabelMedium)
                .foregroundStyle(.tint)
            }
        }
    }
}


// MARK: - Previews


struct WeeklySummaryView_Previews: PreviewProvider {
    
    static let previewContext = PersistenceController.preview.container.viewContext
    static let weeklySchedule = PersistenceController.createMockWeeklySchedule(moc: previewContext)
    
    static var previews: some View {
        WeeklySummaryView(weeklySchedule: weeklySchedule)
            .environment(\.managedObjectContext, previewContext)
    }
}
