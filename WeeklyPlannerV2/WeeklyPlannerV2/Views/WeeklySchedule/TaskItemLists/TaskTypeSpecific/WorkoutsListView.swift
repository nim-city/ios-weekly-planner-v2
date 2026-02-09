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
    
    @FetchRequest(sortDescriptors: []) private var workouts: FetchedResults<Workout>
    
    let editTaskItem: (TaskItem) -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                
                // All workouts in one list
                WorkoutsList(workouts: Array(workouts), editTaskItem: editTaskItem)
                    .padding(.bottom, Constants.bottomPadding)
            }
            .padding(Constants.mainPadding)
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
                static let borderWidth: CGFloat = 2
                static let cornerRadius: CGFloat = 20
            }
            enum Spacing {
                static let mainSpacing: CGFloat = 16
            }
            enum Padding {
                static let dividerHorizontal: CGFloat = 14
                static let emptyTextVertical: CGFloat = 20
            }
        }
        
        let workouts: [Workout]
        let editTaskItem: (TaskItem) -> Void

        var body: some View {
            VStack(alignment: .leading, spacing: Constants.Spacing.mainSpacing) {
                
                Text("All workouts")
                    .font(AppFonts.subtitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if workouts.isEmpty {
                    
                    Text("No workouts yet")
                        .font(AppFonts.detailLabel)
                        .italic()
                        .padding(.vertical, Constants.Padding.emptyTextVertical)
                        .frame(maxWidth: .infinity)
                } else {
                    
                    VStack(spacing: 0) {
                        
                        ForEach(workouts) { workout in
                            
                            TaskListItemView(taskItem: workout,
                                             schedules: workout.dailySchedulesList)
                                .onLongPressGesture {
                                    editTaskItem(workout)
                                }
                            
                            if workout != workouts.last {
                                Divider()
                                    .background(AppColours.dividerBold)
                                    .padding(.horizontal, Constants.Padding.dividerHorizontal)
                            }
                        }
                    }
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius))
                    .overlay {
                        RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius)
                            .strokeBorder(.black, lineWidth: Constants.Sizing.borderWidth)
                    }
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
