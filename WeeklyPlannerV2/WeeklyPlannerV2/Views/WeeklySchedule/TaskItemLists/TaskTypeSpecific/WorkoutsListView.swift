//
//  WorkoutsListView.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-10-12.
//

import SwiftUI

struct WorkoutsListView: View {
    
    private enum Constants {
        static let bottomPadding: CGFloat = 40
        static let mainSpacing: CGFloat = 20
        static let mainPadding: CGFloat = 20
    }
    
    @FetchRequest(sortDescriptors: [.init(keyPath: \Workout.createdAt, ascending: true)]) private var workouts: FetchedResults<Workout>
    
    let editTaskItem: (TaskItem) -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: Constants.mainSpacing) {
                
                // Workouts lists sorted by category
                ForEach(WorkoutCategory.allCases, id: \.self) { category in
                    
                    let filteredWorkouts = workouts.filter { $0.categoryName == category.rawValue }
                    WorkoutsList(category: category, workouts: Array(filteredWorkouts), editTaskItem: editTaskItem)
                }
            }
            .padding(.vertical, Constants.mainPadding)
            .padding(.bottom, Constants.bottomPadding)
        }
        .scrollIndicators(.hidden)
        .tint(.workoutDarkened)
    }
}


// MARK: Subviews


extension WorkoutsListView {
    
    // List of workouts for a specific category
    private struct WorkoutsList: View {
        
        enum Constants {
            enum Sizing {
                static let borderWidth: CGFloat = 1
                static let cornerRadius: CGFloat = 20
            }
            enum Spacing {
                static let mainSpacing: CGFloat = 16
            }
            enum Padding {
                static let main: CGFloat = 20
            }
        }
        
        let category: WorkoutCategory
        let workouts: [Workout]
        let editTaskItem: (TaskItem) -> Void
        
        @State var expandedListItemIndex: Int? = nil
        
        private var emptyText: String {
            "No \(category.displayValue) workouts yet"
        }

        var body: some View {
            VStack(alignment: .leading, spacing: Constants.Spacing.mainSpacing) {
                
                Text(category.displayValue.capitalized)
                    .font(AppFonts.subtitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, Constants.Padding.main)
                
                if workouts.isEmpty {
                    
                    ZStack {
                        Color.white
                        
                        Text(emptyText)
                            .font(AppFonts.detailLabel)
                            .italic()
                            .padding(.vertical, Constants.Padding.main)
                            .frame(maxWidth: .infinity)
                            .background(AppColours.getColourForTaskItemType(.workout).opacity(0.2))
                    }
                    .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius))
                    .padding(.horizontal, Constants.Padding.main)
                } else {
                    
                    VStack(spacing: 0) {
                        
                        ForEach(workouts.indices, id: \.self) { workoutIndex in

                            let workout = workouts[workoutIndex]
                            let isBelowExpandedItem = workout == workouts.first || expandedListItemIndex == workoutIndex - 1
                            let isAboveExpandedItem = workout == workouts.last || expandedListItemIndex == workoutIndex + 1
                            let showDivider = workout != workouts.last && !isAboveExpandedItem && workoutIndex != expandedListItemIndex
                            
                            TaskListItemView(taskItem: workout,
                                             taskItemType: .workout,
                                             schedules: workout.dailySchedulesList,
                                             roundTop: isBelowExpandedItem,
                                             roundBottom: isAboveExpandedItem,
                                             showDivider: showDivider,
                                             isExpanded: Binding(get: { workoutIndex == self.expandedListItemIndex },
                                                                 set: {
                                if $0 {
                                    self.expandedListItemIndex = workoutIndex
                                } else {
                                    self.expandedListItemIndex = nil
                                }
                            }))
                            .onLongPressGesture {
                                editTaskItem(workout)
                            }
                        }
                        
//                        ForEach(workouts) { workout in
//                            
//                            TaskListItemView(taskItem: workout,
//                                             taskItemType: .workout,
//                                             schedules: workout.dailySchedulesList,
//                                             isFirst: workout == workouts.first,
//                                             isLast: workout == workouts.last)
//                                .onLongPressGesture {
//                                    editTaskItem(workout)
//                                }
//                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius))
                    .bottomRightShadow()
                    .padding(.bottom, Constants.Padding.main)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}


// MARK: - Previews


#Preview {
    VStack {
        WorkoutsListView(editTaskItem: { _ in })
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.gray)
}
