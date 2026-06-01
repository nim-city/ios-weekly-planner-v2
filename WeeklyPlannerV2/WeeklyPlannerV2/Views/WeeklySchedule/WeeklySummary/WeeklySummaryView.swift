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
            static let main: CGFloat = 20
            static let text: CGFloat = 16
            static let top: CGFloat = 10
            static let workoutsLeading: CGFloat = 6
        }
        enum Sizing {
            static let borderWidth: CGFloat = 0
            static let cornerRadius: CGFloat = 20
        }
        enum Spacing {
            static let goalViewVertical: CGFloat = 40
            static let mainVertical: CGFloat = 40
            static let subviewVertical: CGFloat = 10
            static let workoutsVertical: CGFloat = 4
        }
    }
    
    @ObservedObject var weeklySchedule: WeeklySchedule
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
    
    private var backgroundGradient: LinearGradient {
        .init(colors: [AppColours.getColourForWeeklySchedule(weeklySchedule).opacity(0.5),
                       AppColours.getColourForWeeklySchedule(weeklySchedule).opacity(0.4),
                       AppColours.getColourForWeeklySchedule(weeklySchedule).opacity(0.5)],
              startPoint: .topLeading,
              endPoint: .bottomTrailing)
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
                        .padding(.top, Constants.Padding.top)
                        .padding(.horizontal, Constants.Padding.main)
                    
                    highlightsView
                        .padding(.horizontal, Constants.Padding.main)
                    
                    goalsView
                    
                    WorkoutsListView(weeklySchedule: weeklySchedule)
                        .padding(.horizontal, Constants.Padding.main)
                }
                .padding(.vertical, Constants.Padding.main)
            }
            .tint(themeColour)
            .background(backgroundGradient)
            
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
    }
    
    // TODO: Add case for holiday week
    private var highlightsView: some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.subviewVertical) {
            
            Text("Days working")
                .font(AppFonts.subtitle)
            
            Group {
                if let workdaysText = viewModel.workdaysText {
                    
                    Text(workdaysText)
                        .font(AppFonts.detailLabelBold)
                        .foregroundStyle(.tint)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius))
                        .bottomRightShadow()
                } else {
                    
                    ZStack {
                        Color.white
                        
                        Text("No work scheduled, enjoy your time off!")
                            .italic()
                            .font(AppFonts.detailLabel)
                            .frame(maxWidth: .infinity)
                            .padding(Constants.Padding.text)
                            .background(.tint.opacity(0.2))
                            
                    }
                    .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius))
                }
            }
        }
    }
    
    private var goalsView: some View {
        VStack(spacing: Constants.Spacing.goalViewVertical) {
            
            // Daily goals
            GoalsList(weeklySchedule: weeklySchedule, goals: dailyGoals, category: .daily) {
                selectedGoalCategory = .daily
            } editGoalAction: { goal in
                editGoal(goal)
            }
            
            // Weekly goals
            GoalsList(weeklySchedule: weeklySchedule, goals: weeklyGoals, category: .weekly) {
                selectedGoalCategory = .weekly
            } editGoalAction: { goal in
                editGoal(goal)
            }
        }
    }
    
    private struct WorkoutsListView: View {
        
        @FetchRequest var workoutTaskBlocks: FetchedResults<TaskBlock>
        
        var mappedWorkoutsToDayName: [(Weekday, [TaskBlock])] {
            
            var mappedWorkouts: [Weekday: [TaskBlock]] = [:]
            
            for taskBlock in workoutTaskBlocks {
                guard let weekday = taskBlock.dailySchedule?.weekday else { continue }
                if mappedWorkouts[weekday] == nil {
                    mappedWorkouts[weekday] = [taskBlock]
                } else {
                    mappedWorkouts[weekday]!.append(taskBlock)
                }
            }
            
            return mappedWorkouts.sorted { $0.key.rawValue < $1.key.rawValue }
        }
        
        init(weeklySchedule: WeeklySchedule) {
            
            let dailySchedulesPredicate = NSPredicate(format: "dailySchedule IN %@", weeklySchedule.dailySchedulesList)
            let exercisePredicate = NSPredicate(format: "categoryName == %@", TaskItemCategory.exercise.rawValue)
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [dailySchedulesPredicate, exercisePredicate])
            
            _workoutTaskBlocks = FetchRequest(sortDescriptors: [NSSortDescriptor(key: "dailySchedule.weekdayIndex", ascending: true)], predicate: compoundPredicate)
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: Constants.Spacing.subviewVertical) {
                
                Text("Workouts")
                    .font(AppFonts.subtitle)
                
                Group {
                    if workoutTaskBlocks.isEmpty {
                        
                        ZStack {
                            Color.white
                            
                            Text("No workouts yet")
                                .italic()
                                .font(AppFonts.detailLabel)
                                .frame(maxWidth: .infinity)
                                .padding(Constants.Padding.text)
                                .background(.tint.opacity(0.2))
                                
                        }
                        .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius))
                    } else {
                        
                        VStack(alignment: .leading, spacing: Constants.Spacing.workoutsVertical) {
                            
                            ForEach(mappedWorkoutsToDayName, id: \.0) { (weekday, taskBlocks) in
                                WorkoutsListViewItem(weekday: weekday, workoutTaskBlocks: taskBlocks)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius))
                        .bottomRightShadow()
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
                enum Spacing {
                    static let workoutsVertical: CGFloat = 4
                }
            }
            
            let weekday: Weekday
            let workoutTaskBlocks: [TaskBlock]
            
            var body: some View {
                HStack(alignment: .top) {
                    
                    // Weekday label
                    Text("• \(weekday.shortName):")
                        .font(AppFonts.detailLabelBold)
                        .frame(width: Constants.Sizing.weekdayLabelWidth, alignment: .leading)
                    
                    // Workouts stack
                    VStack(spacing: Constants.Spacing.workoutsVertical) {
                        ForEach(workoutTaskBlocks) { taskBlock in
                            
                            if taskBlock.taskItemsList.isEmpty {
                                
                                Text("Open")
                                    .font(AppFonts.detailLabelMedium)
                            } else {
                                
                                ForEach(taskBlock.taskItemsList) { taskItem in
                                    if let workout = taskItem as? Workout {
                                        Text(workout.name ?? "Open workout")
                                            .font(AppFonts.detailLabelMedium)
                                    }
                                }
                            }
                        }
                    }
                    .font(AppFonts.detailLabelBold)
                    .foregroundStyle(.tint)
                }
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
