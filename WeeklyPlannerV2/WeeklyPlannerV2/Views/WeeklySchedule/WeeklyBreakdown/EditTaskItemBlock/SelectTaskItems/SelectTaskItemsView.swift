//
//  SelectTaskItemsView.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-09-21.
//

import SwiftUI

struct SelectTaskItemsView: View {
    
    private enum Constants {
        enum Padding {
            static let addButtonPadding: CGFloat = 40
            static let categoryPickerVertical: CGFloat = 20
            static let dividerHorizontal: CGFloat = 15
            static let emptyListHorizontal: CGFloat = 40
            static let emptyListTop: CGFloat = 240
            static let mainAllAround: CGFloat = 5
        }
        enum Sizing {
            static let borderWidth: CGFloat = 2
            static let mainCornerRadius: CGFloat = 20
        }
    }
    
    @Environment(\.dismiss) var dismiss
    @FetchRequest(sortDescriptors: []) var taskItems: FetchedResults<TaskItem>
    @ObservedObject var viewModel: SelectTaskItemsViewModel
    let saveAction: ([TaskItem]) -> Void
    
    @State private var isPresentingAddEditTaskItemSheet: Bool = false
    @State private var taskItemToEdit: TaskItem? = nil
    
    private var taskItemsArray: [TaskItem] {
        viewModel.getFilteredTaskItems(from: Array(taskItems))
    }
    private var backgroundColour: Color {
        .white
    }
    private var themeColour: Color {
        AppColours.getColourForTaskItemCategory(viewModel.selectedCategory)
    }
    
    init(viewModel: SelectTaskItemsViewModel, saveAction: @escaping ([TaskItem]) -> Void) {
        
        self.viewModel = viewModel
        self.saveAction = saveAction
    }
    
    var body: some View {
        NavigationStack {
            
            Picker("Select category", selection: $viewModel.selectedCategory) {
                ForEach(TaskItemCategory.allCases, id: \.self) { category in
                    Image(systemName: category.imageName)
                        .font(.system(size: 8))
                }
            }
            .pickerStyle(.segmented)
            .padding(.vertical, Constants.Padding.categoryPickerVertical)
            
            ScrollView {
                
                if taskItemsArray.isEmpty {
                    
                    emptyView
                        .padding(.horizontal, Constants.Padding.emptyListHorizontal)
                        .padding(.top, Constants.Padding.emptyListTop)
                } else {
                    
                    taskItemsList
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(backgroundColour)
            
            // Navigation bar
            .sheetHeader(title: viewModel.title,
                          cancelButtonStyle: .back,
                          cancelAction: pressCancelButton,
                          saveAction: pressSaveButton)
            
            .overlay(alignment: .bottomTrailing) {
                
                FloatingAddButtonView {
                    isPresentingAddEditTaskItemSheet = true
                }
                .padding(.trailing, Constants.Padding.addButtonPadding)
                .padding(.bottom, Constants.Padding.addButtonPadding)
            }
            
            // Add task item sheet
            .sheet(isPresented: $isPresentingAddEditTaskItemSheet) {
                AddEditTaskItemView(viewModel: .init(taskItemCategory: viewModel.selectedCategory))
            }
            
            // Edit task item sheet
            .sheet(item: $taskItemToEdit) { taskItem in
                AddEditTaskItemView(viewModel: .init(itemToEdit: taskItem))
            }
            
            .tint(themeColour)
        }
    }
    
    func pressCancelButton() {
        dismiss()
    }
    
    func pressSaveButton() {
        saveAction(Array(viewModel.selectedTaskItems))
        dismiss()
    }
    
    func selectTaskItemToEdit(_ taskItem: TaskItem) {
        
        AppAnimations.makeLongPressFeedback()
        
        taskItemToEdit = taskItem
    }
}


// MARK: - Subviews


extension SelectTaskItemsView {
    
    private var emptyView: some View {
        Text(viewModel.emptyListText)
            .italic()
    }
    
    private var taskItemsList: some View {
        
        VStack(spacing: 0) {
            ForEach(taskItemsArray) { taskItem in
                
                SelectableTaskItemView(taskItem: taskItem,
                                       isSelected: viewModel.selectedTaskItems.contains(taskItem),
                                       onTap: { viewModel.selectTaskItem(taskItem) })
                .tint(themeColour)
                .onLongPressGesture {
                    selectTaskItemToEdit(taskItem)
                }
                
                if taskItem != taskItemsArray.last {
                    Divider()
                        .background(AppColours.dividerBold)
                        .padding(.horizontal, Constants.Padding.dividerHorizontal)
                }
            }
        }
//        .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.mainCornerRadius))
//        .overlay {
//            RoundedRectangle(cornerRadius: Constants.Sizing.mainCornerRadius)
//                .stroke(.black, lineWidth: Constants.Sizing.borderWidth)
//        }
        .padding(Constants.Padding.mainAllAround)
    }
}


// MARK: - Previews


struct SelectTaskItemsView_Previews: PreviewProvider {
    
    static let previewContext = PersistenceController.preview.container.viewContext
    static let taskBlock = PersistenceController.createMockWeeklySchedule(moc: previewContext).dailySchedulesList.first!.taskBlocksList[1]
    
    static var previews: some View {
        SelectTaskItemsView(viewModel: .init(category: taskBlock.category!, selectedTaskItems: taskBlock.taskItemsList), saveAction: { _ in })
            .environment(\.managedObjectContext, previewContext)
    }
}
