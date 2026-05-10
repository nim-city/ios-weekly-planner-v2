//
//  AddEditTaskItemView.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-09-10.
//

import SwiftUI

struct AddEditTaskItemView: View {
    
    private enum Constants {
        static let maxNameLength: Int = 30
        enum ImageName {
            static let canceButton = "xmark"
        }
        enum Padding {
            static let allAround: CGFloat = 20
            static let bottom: CGFloat = 40
            static let buttonsTop: CGFloat = 10
            static let checkboxTrailing: CGFloat = 10
            static let notesAllAround: CGFloat = 10
        }
        enum Sizing {
            static let borderWidth: CGFloat = 2
            static let buttonFontSize: CGFloat = 20
            static let buttonHeight: CGFloat = 40
            static let cancelButtonSize: CGFloat = 20
            static let cornerRadius: CGFloat = 10
            static let mainBorderWidth: CGFloat = 3
            static let mainCornerRadius: CGFloat = 12
            static let notes: (minHeight: CGFloat, maxHeight: CGFloat) = (40, 80)
            static let presentationDetents: CGFloat = 480
            static let saveButtonCornerRadius: CGFloat = 10
        }
        enum Spacing {
            static let buttons: CGFloat = 20
            static let mainVertical: CGFloat = 30
            static let markAsDoneButton: CGFloat = 10
            static let notesVertical: CGFloat = 10
            static let scrollView: CGFloat = 1
        }
    }
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: AddEditTaskItemViewModel
    
    @State private var isPresentingDeleteItemAlert: Bool = false
    
    private var accentColour: Color {
        AppColours.getDarkColourForTaskItemType(viewModel.selectedItemType)
    }
    private var fillColour: Color {
        AppColours.getColourForTaskItemType(viewModel.selectedItemType).opacity(0.2)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Constants.Spacing.mainVertical) {
                    
                    itemNameView
                    
                    typeSpecificView
                    
                    notesView
                    
                    buttonsView
                        .padding(.top, Constants.Padding.buttonsTop)
                }
                .padding(Constants.Padding.allAround)
                .padding(.bottom, Constants.Padding.bottom)
            }
            .scrollIndicators(.never)
            
            // Navigation bar
            .sheetHeader(title: viewModel.title, cancelButtonStyle: .close) {
                dismiss()
            } saveAction: {
                if viewModel.pressSaveButton(moc: moc) {
                    dismiss()
                }
            }
            .tint(accentColour)
            
            .onTapGesture {
                AppAnimations.hideKeyboard()
            }
            
            // Delete task item alert
            .alert("Delete \"\(viewModel.itemName.lowercased())\"", isPresented: $isPresentingDeleteItemAlert) {
                Button("No", role: .cancel) {}
                Button("Yes", role: .destructive) {
                    if viewModel.pressDeleteButton(moc: moc) {
                        dismiss()
                    }
                }
            } message: {
                Text("Are you sure you want to delete this item?")
            }
        }
        .presentationDetents([.height(Constants.Sizing.presentationDetents)])
        .ignoresSafeArea()
    }
}


// MARK: - Subviews


extension AddEditTaskItemView {
    
    private var itemNameView: some View {
        LabelledTextField(text: $viewModel.itemName,
                          prompt: viewModel.namePlaceholder, maxCharacterCount: Constants.maxNameLength,
                          backgroundColor: fillColour)
    }
    
    private var typeSpecificView: some View {
        Group {
            switch viewModel.selectedItemType {
            case .goal:
                
                GoalView(selectedCategory: $viewModel.selectedGoalCategory)
            case .toDoItem:
                
                ToDoItemView(selectedCategory: $viewModel.selectedToDoItemCategory,
                             selectedPriority: $viewModel.selectedPriority,
                             isRecurring: $viewModel.recurring,
                             canSelectCategory: viewModel.isNew)
            
            case .toBuyItem:
                
                ToBuyItemView(selectedCategory: $viewModel.selectedToBuyItemCategory,
                              selectedPriority: $viewModel.selectedPriority)
            case .workout:
                
                WorkoutView(selectedCategory: $viewModel.selectedWorkoutCategory)
            case .meal:
                
                MealView(selectedCategory: $viewModel.selectedMealCategory)
            }
        }
    }
    
    private var buttonsView: some View {
        VStack(spacing: Constants.Spacing.buttons) {
            
            // Mark as done button
            if viewModel.showMarkAsDoneButton {
                Button {
                    
                    if viewModel.toggleTaskItemCompleted(moc: moc) {
                        dismiss()
                    }
                } label: {
                    HStack(spacing: Constants.Spacing.markAsDoneButton) {
                        
                        Image(systemName: viewModel.isTaskItemComplete ? "xmark" : "checkmark")
                        
                        Text(viewModel.isTaskItemComplete ? "Mark as not done" : "Mark as done")
                    }
                    .font(AppFonts.textButton)
                    .foregroundStyle(accentColour)
                    .frame(maxWidth: .infinity)
                    .frame(height: Constants.Sizing.buttonHeight)
                }
            }
            
            // Delete button
            if !viewModel.isNew {
                Button {
                    isPresentingDeleteItemAlert = true
                } label: {
                    HStack(spacing: Constants.Spacing.markAsDoneButton) {
                        
                        Image(systemName: "trash")
                        
                        Text("Delete \(viewModel.selectedItemType.displayValue)")
                    }
                    .font(AppFonts.textButton)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity)
                    .frame(height: Constants.Sizing.buttonHeight)
                }
            }
        }
    }
    
    private var notesView: some View {
        
        VStack(alignment: .leading, spacing: Constants.Spacing.notesVertical) {
            
            Text("Notes")
                .font(AppFonts.formHeading)
            
            TextField("Notes",
                      text: $viewModel.notes,
                      prompt: Text("No notes yet").italic(),
                      axis: .vertical)
                .lineLimit(2...5)
                .lineSpacing(4)
                .font(AppFonts.notesText)
                .frame(minHeight: Constants.Sizing.notes.minHeight)
                .padding(Constants.Padding.notesAllAround)
                .background(fillColour)
                .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius))
                .overlay {
                    RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius)
                        .stroke(accentColour, lineWidth: Constants.Sizing.borderWidth)
                }
                .modifier(SunkenStyle())
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
