//
//  AddEditTaskBlockView.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-09-17.
//

import SwiftUI

struct AddEditTaskBlockView: View {
    
    private enum Constants {
        enum ImageName {
            static let plus = "plus"
        }
        enum Padding {
            static let addButtonPadding: CGFloat = 40
            static let allAround: CGFloat = 20
            static let controlHorizontal: CGFloat = 15
            static let controlVertical: CGFloat = 10
            static let extraHorizontal: CGFloat = 5
            static let taskItemsAllAround: CGFloat = 10
        }
        enum Sizing {
            static let addButtonWidth: CGFloat = 14
            static let cornerRadius: CGFloat = 12
            static let borderWidth: CGFloat = 2
        }
        enum Spacing {
            static let taskItemsHeadingHorizontal: CGFloat = 16
            static let mainVertical: CGFloat = 30
            static let taskItems: CGFloat = 10
            static let taskItemsTitle: CGFloat = 10
        }
    }
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
    @StateObject var viewModel: AddEditTaskBlockViewModel
    
    @State private var isPresentingSelectTaskItemsView = false
    
    private var themeColour: Color {
        AppColours.getColourForTaskItemCategory(viewModel.selectedCategory)
    }
    
    // FIXME: Update this
    init(dailySchedule: DailySchedule, startHour: Int, taskBlock: TaskBlock? = nil) {
        if let taskBlock {
            _viewModel = .init(wrappedValue: .init(dailySchedule: dailySchedule, taskBlock: taskBlock))
        } else {
            _viewModel = .init(wrappedValue: .init(dailySchedule: dailySchedule, startHour: startHour))
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Constants.Spacing.mainVertical) {
                    
                    LabelledTextField(text: $viewModel.name, prompt: "Name")
                    
                    categoryView
                    
                    SetHourView(title: "Start hour",
                                hourString: viewModel.startHourString,
                                increaseHourAction: viewModel.increaseStartHour,
                                decreaseHourAction: viewModel.decreaseStartHour)
                    
                    SetHourView(title: "End hour",
                                hourString: viewModel.endHourString,
                                increaseHourAction: viewModel.increaseEndHour,
                                decreaseHourAction: viewModel.decreaseEndHour)
                    
                    if viewModel.isNew {
                        weekdaysView
                    }
                    
                    taskItemsView
                    
                    if !viewModel.isNew {
                        Button {
                            deleteTaskBlock()
                        } label: {
                            Text("Delete task block")
                                .font(AppFonts.deleteTextButton)
                                .foregroundStyle(.red)
                        }
                    }
                }
                .padding(Constants.Padding.allAround)
                .frame(maxWidth: .infinity)
            }
            
            // Navigation bar
            .sheetHeader(title: viewModel.title,
                          cancelAction: pressCancelButton,
                          saveAction: pressSaveButton)
            
            .onChange(of: viewModel.selectedCategory) {
                viewModel.clearTaskItems()
            }
            
            // Select task items view
            .navigationDestination(isPresented: $isPresentingSelectTaskItemsView) {
                SelectTaskItemsView(viewModel: .init(category: viewModel.selectedCategory,
                                                     selectedTaskItems: viewModel.taskItems),
                                    saveAction: viewModel.updateTaskItems(newTaskItems:))
            }
            
            .tint(themeColour)
        }
    }
    
    // Revert changes to selected task items and Delete if new
    private func pressCancelButton() {
        dismiss()
    }
    
    // Update values
    private func pressSaveButton() {
        viewModel.pressSaveButton(moc: moc)
        dismiss()
    }
    
    private func deleteTaskBlock() {
        viewModel.deleteTaskBlock(moc: moc)
        dismiss()
    }
}


// MARK: - Subviews


extension AddEditTaskBlockView {
    
    // Category view
    private var categoryView: some View {
        HStack {
            
            Text("Category")
                .font(AppFonts.formHeading)
            
            Spacer()
            
            if viewModel.isNew {
                DropdownMenu(texts: viewModel.categoryNames,
                             selectedIndex: $viewModel.categoryIndex)
            } else {
                Text(viewModel.selectedCategoryName)
                    .font(AppFonts.formHeading)
                    .padding(.horizontal, Constants.Padding.controlHorizontal)
                    .padding(.vertical, Constants.Padding.controlVertical)
            }
        }
    }
    
    private var weekdaysView: some View {
        HStack {
            
            Text("Weekdays")
                .font(AppFonts.formHeading)
            
            Spacer()
            
            WeekdayButtonsView(selectedWeekdays: $viewModel.selectedWeekdays) {
                viewModel.selectedWeekdays = NSMutableOrderedSet(orderedSet: $0)
            }
            .tint(themeColour)
            .padding(.horizontal, Constants.Padding.controlHorizontal)
            .padding(.vertical, Constants.Padding.controlVertical)
            .background(themeColour.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius))
            .overlay {
                RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius)
                    .stroke(themeColour, lineWidth: Constants.Sizing.borderWidth)
            }
        }
    }
    
    // Task items
    private var taskItemsView: some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.taskItemsTitle) {
            
            HStack(spacing: Constants.Spacing.taskItemsHeadingHorizontal) {
                
                Text("Task items")
                    .font(AppFonts.formHeading)
                
                Button {
                    isPresentingSelectTaskItemsView = true
                } label: {
                    Image(systemName: Constants.ImageName.plus)
                        .tint(themeColour)
                        .font(.system(size: 18, weight: .semibold))
                }
                
                Spacer()
            }
            .padding(.leading, Constants.Padding.extraHorizontal)

            VStack(spacing: Constants.Spacing.taskItems) {
                if viewModel.taskItems.isEmpty {
                    
                    Text("No task items yet. Add some here")
                        .italic()
                        .padding(.vertical, Constants.Padding.taskItemsAllAround)
                } else {
                    
                    ForEach(viewModel.taskItems) { taskItem in
                        ListItemView(taskItem: taskItem)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(Constants.Padding.taskItemsAllAround)
            .background(.tint.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius))
            .overlay {
                RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius)
                    .stroke(themeColour, lineWidth: Constants.Sizing.borderWidth)
            }
            .contentShape(Rectangle())
        }
    }
    
    private struct ListItemView: View {
        
        let taskItem: TaskItem
        
        private var text: String {
            "\u{2022} \(taskItem.name ?? "Task item")"
        }
        
        var body: some View {
            HStack {
                Text(text)
                Spacer()
            }
        }
    }
    
    private struct WeekdayButtonsView: View {
        
        @Binding var selectedWeekdays: NSMutableOrderedSet
        private let size: CGFloat
        private let changeWeekdayAction: ((NSOrderedSet) -> Void)?
        
        init(selectedWeekdays: Binding<NSMutableOrderedSet>, size: CGFloat = 24, changeWeekdayAction: ((NSOrderedSet) -> Void)? = nil) {
            self._selectedWeekdays = selectedWeekdays
            self.size = size
            self.changeWeekdayAction = changeWeekdayAction
        }
        
        private var halfSize: CGFloat {
            size / 2
        }
        
        private var spacing: CGFloat {
            size / 3
        }
        
        var body: some View {
            HStack(spacing: spacing) {
                
                ForEach(Weekday.allCases) { weekday in
                    
                    let isSelected = getIsWeekdaySelected(weekday)
                    
                    Button {
                        
                        selectWeekday(weekday)
                    } label: {
                        if isSelected {
                            
                            Text(weekday.initial)
                                .font(.system(size: halfSize, weight: .bold))
                                .foregroundStyle(.white)
                                .frame(width: size, height: size)
                                .background(.tint)
                        } else {
                            
                            Text(weekday.initial)
                                .font(.system(size: halfSize, weight: .bold))
                                .foregroundStyle(.black)
                                .frame(width: size, height: size)
                                .background(.white)
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: halfSize))
                    .overlay {
                        RoundedRectangle(cornerRadius: halfSize)
                            .stroke(.black, lineWidth: 1)
                    }
                }
            }
        }
        
        private func getIsWeekdaySelected(_ weekday: Weekday) -> Bool {
            selectedWeekdays.contains(weekday)
        }
        
        private func selectWeekday(_ weekday: Weekday) {
            
            if selectedWeekdays.contains(weekday) {
                selectedWeekdays.remove(weekday)
            } else {
                selectedWeekdays.add(weekday)
            }
            
            changeWeekdayAction?(selectedWeekdays)
        }
    }
}


// MARK: - Previews


struct AddEditTaskBlockView_Previews: PreviewProvider {
    
    static let previewContext = PersistenceController.preview.container.viewContext
    static let dailySchedule = PersistenceController.createMockWeeklySchedule(moc: previewContext).dailySchedulesList.first!
    static let taskBlock = dailySchedule.taskBlocksList.first!
    
    static var previews: some View {
        AddEditTaskBlockView(dailySchedule: dailySchedule, startHour: 3, taskBlock: nil)
    }
}
