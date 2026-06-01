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
            static let dividerHorizontal: CGFloat = 15
            static let emptyListHorizontal: CGFloat = 40
            static let emptyListTop: CGFloat = 240
            static let mainAllAround: CGFloat = 20
            static let numberOfTaskSelectedView: (horizontal: CGFloat, vertical: CGFloat) = (28, 12)
            static let selector: (top: CGFloat, bottom: CGFloat) = (24, 10)
        }
        enum Sizing {
            static let borderWidth: CGFloat = 2
            static let mainCornerRadius: CGFloat = 20
        }
    }
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: TaskItem.entity(), sortDescriptors: []) var taskItems: FetchedResults<TaskItem>
    @ObservedObject var viewModel: SelectTaskItemsViewModel
    let saveAction: ([TaskItem]) -> Void
    
    @State private var isPresentingAddEditTaskItemSheet: Bool = false
    @State private var taskItemToEdit: TaskItem? = nil
    @State private var expandedListItemIndex: Int? = nil
    
    private var taskItemsArray: [TaskItem] {
        viewModel.getFilteredTaskItems(from: Array(taskItems))
    }
    private var themeColour: Color {
        AppColours.getColourForTaskItemCategory(viewModel.selectedCategory)
    }
    private var backgroundGradient: LinearGradient {
        .init(colors: [AppColours.getColourForTaskItemCategory(viewModel.selectedCategory).opacity(0.4),
                       AppColours.getColourForTaskItemCategory(viewModel.selectedCategory).opacity(0.6),
                       AppColours.getColourForTaskItemCategory(viewModel.selectedCategory).opacity(0.4)],
              startPoint: .topLeading,
              endPoint: .bottomTrailing)
    }
    
    init(viewModel: SelectTaskItemsViewModel, saveAction: @escaping ([TaskItem]) -> Void) {
        
        self.viewModel = viewModel
        self.saveAction = saveAction
    }
    
    var body: some View {
        NavigationStack {
            
            VStack(spacing: 0) {
                
                TaskItemCategorySelector(taskItemCategories: TaskItemCategory.allCases, selectedCategory: $viewModel.selectedCategory)
                    .padding(.top, Constants.Padding.selector.top)
                    .padding(.bottom, Constants.Padding.selector.bottom)
                
                if !viewModel.isSelectionEmpty {
                    numberOfTasksSelectedView
                        .padding(.horizontal, Constants.Padding.numberOfTaskSelectedView.horizontal)
                        .padding(.top, Constants.Padding.mainAllAround)
                        .padding(.bottom, Constants.Padding.numberOfTaskSelectedView.vertical)
                }

                ScrollView {
                    
                    if taskItemsArray.isEmpty {
                        
                        emptyView
                            .padding(.horizontal, Constants.Padding.emptyListHorizontal)
                            .padding(.top, Constants.Padding.emptyListTop)
                    } else {
                        
                        taskItemsList
                            .padding(.vertical, Constants.Padding.mainAllAround)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(backgroundGradient)
            
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
    
    private var numberOfTasksSelectedView: some View {
        HStack {
            
            Text("\(viewModel.selectedTaskItems.count) ")
                .foregroundStyle(.tint)
                .font(AppFonts.detailLabelBold) +
            Text(viewModel.selectedTaskItems.count == 1 ? "item selected" : "items selected")
                .foregroundStyle(.black)
                .font(AppFonts.subtitleSmall)
            
            Spacer()
            
            Button {
                withAnimation {
                    viewModel.clearSelectedItems()
                }
            } label: {
                Text("Clear")
                    .foregroundStyle(.tint)
                    .font(AppFonts.subtitleSmall)
            }
        }
    }
    
    private var taskItemsList: some View {
        
        VStack(spacing: 0) {
            ForEach(taskItemsArray.indices, id: \.self) { taskItemIndex in

                let taskItem = taskItemsArray[taskItemIndex]
                let isBelowExpandedItem = taskItem == taskItemsArray.first || expandedListItemIndex == taskItemIndex - 1
                let isAboveExpandedItem = taskItem == taskItemsArray.last || expandedListItemIndex == taskItemIndex + 1
                let showDivider = taskItem != taskItemsArray.last && !isAboveExpandedItem && taskItemIndex != expandedListItemIndex
                
                // TODO: Alter this to ignore taskItemType
                SelectableTaskItemView(taskItem: taskItem,
                                       taskItemType: .goal,
                                       isSelected: viewModel.selectedTaskItems.contains(taskItem),
                                       roundTop: isBelowExpandedItem,
                                       roundBottom: isAboveExpandedItem,
                                       showDivider: showDivider,
                                       isExpanded: Binding(get: { taskItemIndex == self.expandedListItemIndex },
                                                           set: {
                          if $0 {
                              self.expandedListItemIndex = taskItemIndex
                          } else {
                              self.expandedListItemIndex = nil
                          }
                })) {
                    viewModel.selectTaskItem(taskItem)
                }
                .onLongPressGesture {
                    selectTaskItemToEdit(taskItem)
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.mainCornerRadius))
        .bottomRightShadow()
    }
}


// MARK: - Previews


#Preview {
    SelectTaskItemsView(viewModel: .init(category: .chore, selectedTaskItems: []),
                        saveAction: { _ in })
//        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
