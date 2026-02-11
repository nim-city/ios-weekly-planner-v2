//
//  TaskItemListsView.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-09-07.
//

import SwiftUI

struct TaskItemListsView: View {
    
    private enum Constants {
        enum Padding {
            static let addButtonPadding: (trailing: CGFloat, bottom: CGFloat) = (40, 20)
            static let taskItemTypePickerTop: CGFloat = 20
        }
    }

    @StateObject private var viewModel: TaskItemListsViewModel
    @State var isPresentingAddEditTaskItemSheet: Bool = false
    @State var taskItemToEdit: TaskItem?
    
    private var backgroundColour: LinearGradient {
        return LinearGradient(colors: [AppColours.getColourForTaskItemType(viewModel.selectedTaskItemType).opacity(0.3), AppColours.getColourForTaskItemType(viewModel.selectedTaskItemType).opacity(0.7)],
                              startPoint: .top,
                              endPoint: .bottom)
    }

    init(weeklySchedule: WeeklySchedule) {
        _viewModel = .init(wrappedValue: .init(weeklySchedule: weeklySchedule))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                TaskItemTypePicker(selectedTaskItemType: $viewModel.selectedTaskItemType)
                    .padding(.top, Constants.Padding.taskItemTypePickerTop)
                
                ZStack {
                    Color.white
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    Group {
                        switch viewModel.selectedTaskItemType {
                        case .goal:
                            GoalsListView { taskItem in
                                longTapTaskItem(taskItem)
                            }
                        case .meal:
                            MealsListView { taskItem in
                                longTapTaskItem(taskItem)
                            }
                        case .toBuyItem:
                            ToBuyItemsListView { taskItem in
                                longTapTaskItem(taskItem)
                            }
                        case .toDoItem:
                            ToDoItemsListView { taskItem in
                                longTapTaskItem(taskItem)
                            }
                        case .workout:
                            WorkoutsListView { taskItem in
                                longTapTaskItem(taskItem)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(backgroundColour)
                }
                .compositingGroup()
            }
            
            // Navigation bar
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle(viewModel.title)
            
            // Floating add button
            .overlay(alignment: .bottomTrailing) {
                
                FloatingAddButtonView {
                    isPresentingAddEditTaskItemSheet = true
                }
                .padding(.trailing, Constants.Padding.addButtonPadding.trailing)
                .padding(.bottom, Constants.Padding.addButtonPadding.bottom)
            }
            
            // Add task item sheet
            .sheet(isPresented: $isPresentingAddEditTaskItemSheet) {
                AddEditTaskItemView(viewModel: .init(itemType: viewModel.selectedTaskItemType))
            }
            
            // Edit task item sheet
            .sheet(item: $taskItemToEdit) { taskItem in
                AddEditTaskItemView(viewModel: .init(itemToEdit: taskItem))
            }
        }
    }
    
    private func longTapTaskItem(_ taskItem: TaskItem) {
        
        AppAnimations.makeLongPressFeedback()
        
        taskItemToEdit = taskItem
    }
}


// MARK: - Subviews


extension TaskItemListsView {
    
    // MARK: Task item type picker
    var taskItemSelector: some View {
        Picker("Select task item type picker", selection: $viewModel.selectedTaskItemType) {
            
            ForEach(TaskItemType.allCases, id: \.self) { taskItemType in
                Text(viewModel.getTaskItemTypeLabel(forType: taskItemType))
            }
        }
        .pickerStyle(.segmented)
    }
}


// MARK: - Previews


struct TaskItemListsView_Previews: PreviewProvider {
    
    static let previewContext = PersistenceController.preview.container.viewContext
    static let weeklySchedule = PersistenceController.createMockWeeklySchedule(moc: previewContext)
    
    static var previews: some View {
        TaskItemListsView(weeklySchedule: weeklySchedule)
            .environment(\.managedObjectContext, previewContext)
    }
}
