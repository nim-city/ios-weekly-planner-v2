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
            static let deleteButtonTop: CGFloat = 20
            static let extraHorizontal: CGFloat = 5
            static let emptyTaskItems: CGFloat = 10
            static let taskItemsAllAround: CGFloat = 16
        }
        enum Sizing {
            static let addButtonWidth: CGFloat = 14
            static let cornerRadius: CGFloat = 12
            static let borderWidth: CGFloat = 2
            static let taskItemImageWidth: CGFloat = 36
            static let taskItemsMinHeight: CGFloat = 60
        }
        enum Spacing {
            static let taskItemsHeadingHorizontal: CGFloat = 16
            static let mainVertical: CGFloat = 30
            static let taskItemCategories: CGFloat = 32
            static let taskItems: CGFloat = 8
            static let taskItemsTitle: CGFloat = 10
        }
    }
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
    @StateObject var viewModel: AddEditTaskBlockViewModel
    
    @State private var isPresentingSelectTaskItemsView = false
    @State private var isPresentingDeleteTaskBlockAlert = false
    @State private var isPresentingInvalidInputsAlert = false
    
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
                    
                    LabelledTextField(text: $viewModel.name,
                                      prompt: "Name",
                                      maxCharacterCount: viewModel.maxNameLength,
                                      backgroundColor: themeColour.opacity(0.2))
                    
                    categoryView
                    
                    SetTimeView(title: "Start hour",
                                hour: $viewModel.startHour,
                                minutes: $viewModel.startMinutes)
                    
                    SetTimeView(title: "End hour",
                                hour: $viewModel.endHour,
                                minutes: $viewModel.endMinutes)

                    if viewModel.isNew {
                        weekdaysView
                    }
                    
                    taskItemsView
                    
                    if !viewModel.isNew {
                        Button {
                            isPresentingDeleteTaskBlockAlert = true
                        } label: {
                            Text("Delete task block")
                                .font(AppFonts.textButton)
                                .foregroundStyle(.red)
                        }
                        .padding(.top, Constants.Padding.deleteButtonTop)
                    }
                }
                .padding(Constants.Padding.allAround)
                .frame(maxWidth: .infinity)
            }
            
            // Navigation bar
            .sheetHeader(title: viewModel.title,
                         isSaveEnabled: viewModel.isSaveButtonEnabled,
                         cancelAction: pressCancelButton,
                         saveAction: pressSaveButton)
            
            .onChange(of: viewModel.selectedCategory) {
                viewModel.clearTaskItems()
            }
            
            .onChange(of: viewModel.validationError) { _, newValue in
                isPresentingInvalidInputsAlert = newValue != nil
            }
            
            // Delete task block alert
            .alert("Delete \"\(viewModel.name.lowercased())\"", isPresented: $isPresentingDeleteTaskBlockAlert) {
                Button("No", role: .cancel) {}
                Button("Yes", role: .destructive) {
                    pressDeleteTaskBlock()
                }
            } message: {
                Text("Are you sure you want to delete this task block?")
            }
            
            // Invalid inputs alert
            .alert("Invalid inputs",
                   isPresented: $isPresentingInvalidInputsAlert,
                   presenting: viewModel.validationError) { error in
                
                Button("Okay", role: .cancel) {
                    viewModel.validationError = nil
                }
            } message: { error in
                
                Text(error.message)
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
        if viewModel.pressSaveButton(moc: moc) {
            dismiss()
        }
    }
    
    private func pressDeleteTaskBlock() {
        if viewModel.deleteTaskBlock(moc: moc) {
            dismiss()
        }
    }
    
    @State var startHour: Int = 0
    @State var startMinutes: Int = 0
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
                             selectedIndex: $viewModel.categoryIndex,
                             backgroundColor: themeColour.opacity(0.2))
            } else {
                Text(viewModel.selectedCategoryName)
                    .font(AppFonts.formHeading)
                    .padding(.horizontal, Constants.Padding.controlHorizontal)
                    .padding(.vertical, Constants.Padding.controlVertical)
            }
        }
    }
    
    private var startTimeView: some View {
        HStack {
            
            Text("Start time")
                .font(AppFonts.formHeading)
            
            Spacer()
            
            HStack(spacing: 0) {
                Picker("Start hour", selection: $startHour) {
                    ForEach(1...12, id: \.self) { hour in
                        Text("\(hour)")
                            .font(AppFonts.controlLabel)
                            .foregroundStyle(.black)
                    }
                }
                .pickerStyle(.wheel)
                .frame(maxWidth: 50, maxHeight: 40)
                .labelsHidden()
                .compositingGroup()
                
                
                Text(":")
                    .font(AppFonts.controlLabel)
                    .foregroundStyle(.black)
                
                Picker("End hour", selection: $startHour) {
                    ForEach([0, 15, 30, 45], id: \.self) { hour in
                        Text("\(hour)")
                            .font(AppFonts.controlLabel)
                            .foregroundStyle(.black)
                    }
                }
                .pickerStyle(.wheel)
                .frame(maxWidth: 50, maxHeight: 40)
                
                Text("AM")
                    .font(AppFonts.controlLabel)
                    .foregroundStyle(.black)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(.tint.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius))
            .overlay {
                RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius)
                    .stroke(.tint, lineWidth: Constants.Sizing.borderWidth)
            }
            .modifier(SunkenStyle())
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
            .background(themeColour.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius))
            .overlay {
                RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius)
                    .stroke(themeColour, lineWidth: Constants.Sizing.borderWidth)
            }
            .modifier(SunkenStyle())
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
            
            Group {
                if viewModel.taskItems.isEmpty {
                    
                    Text("No task items yet")
                        .italic()
                        .font(AppFonts.notesText)
                        .foregroundStyle(AppColours.mediumGray)
                        .padding(Constants.Padding.emptyTaskItems)
                } else {
                    
                    VStack(alignment: .leading, spacing: Constants.Spacing.taskItemCategories) {
                        ForEach(TaskItemCategory.allCases) { taskItemCategory in
                            if let taskItems = viewModel.sortedTaskItems[taskItemCategory.rawValue] {
                                
                                HStack(alignment: .top, spacing: 0) {
                                    
                                    Image(systemName: AppImages.getSystemImageNameForTaskItemCategory(taskItemCategory))
                                        .font(AppFonts.detailLabelBold)
                                        .foregroundStyle(AppColours.getColourForTaskItemCategory(taskItemCategory))
                                        .frame(width: Constants.Sizing.taskItemImageWidth, alignment: .leading)
                                    
                                    VStack(alignment: .leading, spacing: Constants.Spacing.taskItems) {
                                        ForEach(taskItems) { taskItem in
                                            Text(taskItem.name ?? "")
                                                .font(AppFonts.detailLabelMedium)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(Constants.Padding.taskItemsAllAround)
                }
            }
            .frame(maxWidth: .infinity, minHeight: Constants.Sizing.taskItemsMinHeight, alignment: .topLeading)
            
            .background(.tint.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius))
            .overlay {
                RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius)
                    .stroke(themeColour, lineWidth: Constants.Sizing.borderWidth)
            }
            .modifier(SunkenStyle())
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
    
    // TODO: Move this to a more generic view
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
