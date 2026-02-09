//
//  AddEditTaskItemView.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-09-10.
//

import SwiftUI

struct AddEditTaskItemView: View {
    
    private enum Constants {
        enum ImageName {
            static let canceButton = "xmark"
        }
        enum Padding {
            static let allAround: CGFloat = 20
            static let bottom: CGFloat = 40
            static let checkboxTrailing: CGFloat = 10
            static let notesAllAround: CGFloat = 15
        }
        enum Sizing {
            static let borderWidth: CGFloat = 2
            static let buttonFontSize: CGFloat = 20
            static let buttonHeight: CGFloat = 50
            static let cancelButtonSize: CGFloat = 20
            static let cornerRadius: CGFloat = 10
            static let mainBorderWidth: CGFloat = 3
            static let mainCornerRadius: CGFloat = 12
            static let notes: (minHeight: CGFloat, maxHeight: CGFloat) = (40, 70)
            static let presentationDetents: CGFloat = 560
            static let saveButtonCornerRadius: CGFloat = 10
        }
        enum Spacing {
            static let buttons: CGFloat = 16
            static let mainVertical: CGFloat = 30
            static let notesVertical: CGFloat = 10
            static let scrollView: CGFloat = 1
        }
    }
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: AddEditTaskItemViewModel
    
    @State private var isPresentingDeleteItemAlert: Bool = false
    
    private var themeColour: Color {
        AppColours.getDarkColourForTaskItemType(viewModel.selectedItemType)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Constants.Spacing.mainVertical) {
                    
                    // Item name text field
                    LabelledTextField(text: $viewModel.itemName,
                                      prompt: viewModel.namePlaceholder)
                    
                    // Completed checkbox
                    if !viewModel.isNew {
                        completedView
                    }
                    
                    // Views specific to task item type
                    typeSpecificView
                    
                    // Notes text field
                    notesView
                    
                    if !viewModel.isNew {
                        deleteButton
                            .padding(.bottom, Constants.Padding.bottom)
                    }
                }
                .padding(Constants.Padding.allAround)
            }
            
            // Navigation bar
            .sheetHeader(title: viewModel.title,
                          cancelButtonStyle: .close) {
                dismiss()
            } saveAction: {
                if viewModel.pressSaveButton(moc: moc) {
                    dismiss()
                }
            }
            .tint(themeColour)
            
            .onTapGesture {
                AppAnimations.hideKeyboard()
            }
            
            // Delete schedule alert
            .alert("Delete \(viewModel.itemName)", isPresented: $isPresentingDeleteItemAlert) {
                Button("No", role: .cancel) {}
                Button("Yes", role: .destructive) {
                    if viewModel.pressDeleteButton(moc: moc) {
                        dismiss()
                    }
                }
            } message: {
                Text("Are you sure you want to delete this schedule?")
            }
        }
        .presentationDetents([.height(Constants.Sizing.presentationDetents)])
        .overlay {
            RoundedRectangle(cornerRadius: Constants.Sizing.mainCornerRadius)
                .stroke(AppColours.borderSubdued, lineWidth: Constants.Sizing.mainBorderWidth)
        }
        .ignoresSafeArea()
    }
}


// MARK: - Subviews


extension AddEditTaskItemView {
    
    private var completedView: some View {
        HStack {
            
            Text("Completed")
                .font(AppFonts.formHeading)
            
            Spacer()
            
            Checkbox(isSelected: $viewModel.completed)
                .padding(.trailing, Constants.Padding.checkboxTrailing)
        }
    }
    
    private var typeSpecificView: some View {
        Group {
            
            // Goal
            if viewModel.selectedItemType == .goal {
                GoalView(selectedCategory: $viewModel.selectedGoalCategory)
            }
            
            // Meal
            if viewModel.selectedItemType == .meal {
                MealView(selectedCategory: $viewModel.selectedMealCategory)
            }
            
            // To buy item
            if viewModel.selectedItemType == .toBuyItem {
                ToBuyItemView(selectedPriority: $viewModel.selectedPriority)
            }
            
            // To do item
            if viewModel.selectedItemType == .toDoItem {
                ToDoItemView(selectedCategory: $viewModel.selectedToDoItemCategory,
                             selectedPriority: $viewModel.selectedPriority,
                             isRecurring: $viewModel.recurring,
                             canSelectCategory: viewModel.isNew)
            }
            
            // Workout
            if viewModel.selectedItemType == .workout {
                WorkoutView(exercises: $viewModel.exercises)
            }
        }
    }
    
    private var deleteButton: some View {
        Button {
            isPresentingDeleteItemAlert = true
        } label: {
            Text("Delete \(viewModel.selectedItemType.displayValue)")
                .font(.system(size: Constants.Sizing.buttonFontSize, weight: .regular))
                .foregroundStyle(.red)
                .frame(maxWidth: .infinity)
                .frame(height: Constants.Sizing.buttonHeight)
        }
    }
    
    private var notesView: some View {
        
        VStack(alignment: .leading, spacing: Constants.Spacing.notesVertical) {
            
            Text("Notes")
                .font(AppFonts.formHeading)
            
            TextField("Notes",
                      text: $viewModel.notes,
                      prompt: Text("No notes yet"),
                      axis: .vertical)
                .lineLimit(3...5)
                .font(.system(size: 15, weight: .regular))
                .frame(minHeight: Constants.Sizing.notes.minHeight,
                       maxHeight: Constants.Sizing.notes.maxHeight)
                .padding(Constants.Padding.notesAllAround)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius))
                .overlay {
                    RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius)
                        .stroke(themeColour, lineWidth: Constants.Sizing.borderWidth)
                }
        }
    }
}


// MARK: - Previews


struct AddEditTaskItemView_Previews: PreviewProvider {
    
    static let previewContext = PersistenceController.preview.container.viewContext
    static let dailySchedule = PersistenceController.createMockWeeklySchedule(moc: previewContext).dailySchedulesList.first!
    static let taskBlock = dailySchedule.taskBlocksList.first!
    
    static var previews: some View {
        VStack {
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.red.opacity(0.5))
        .sheet(isPresented: Binding(get: { true }, set: { _ in })) {
            AddEditTaskItemView(viewModel: .init(itemType: .workout))
        }
    }
}
