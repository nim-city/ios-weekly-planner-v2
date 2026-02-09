//
//  AddEditWeeklyScheduleView.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-09-07.
//

import SwiftUI

struct AddEditWeeklyScheduleView: View {
    
    private enum Constants {
        enum Padding {
            static let mainAllAround: CGFloat = 20
        }
        enum Sizing {
            static let borderWidth: CGFloat = 3
            static let buttonFontSize: CGFloat = 20
            static let buttonHeight: CGFloat = 32
            static let cornerRadius: CGFloat = 10
            static let mainCornerRadius: CGFloat = 20
            static let mainHeight: CGFloat = 360
            static let saveButtonCornerRadius: CGFloat = 10
        }
        enum Spacing {
            static let mainVertical: CGFloat = 40
            static let infoViewsVertical: CGFloat = 30
        }
    }
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: AddEditWeeklyScheduleViewModel
    
    @State private var selectedColour: Color = AppColours.appTheme
    @State private var isPresentingAreYouSureAlert = false
    
    init(weeklySchedule: WeeklySchedule? = nil) {
        _viewModel = .init(wrappedValue: .init(weeklySchedule: weeklySchedule))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Constants.Spacing.mainVertical) {
                    
                    VStack(spacing: Constants.Spacing.infoViewsVertical) {
                        LabelledTextField(text: $viewModel.nameText,
                                          prompt: "Schedule name",
                                          maxCharacterCount: viewModel.maxNameLength)
                        
                        categoryPicker
                        
                        colourPickerView
                    }
                    
                    // Delete button
                    if !viewModel.isNewSchedule {
                        deleteButton
                    }
                    
                    Spacer()
                }
                .padding(Constants.Padding.mainAllAround)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(.white)
            
            // Navigation bar
            .sheetHeader(title: viewModel.title, isSaveEnabled: viewModel.areInputsValid) {
                dismiss()
            } saveAction: {
                pressSaveButton()
            }
            
            .tint(selectedColour)
            
            .onTapGesture {
                AppAnimations.hideKeyboard()
            }
            
            // Are you sure you want to delete schedule alert
            .alert("Are you sure you want to delete this weekly schedule?",
                   isPresented: $isPresentingAreYouSureAlert) {
                
                Button("Yes", role: .destructive) {
                    pressDeleteButton()
                }
                
                Button("No", role: .cancel) {}
            }
        }
        .overlay {
            RoundedRectangle(cornerRadius: Constants.Sizing.mainCornerRadius)
                .strokeBorder(AppColours.borderSubdued, lineWidth: Constants.Sizing.borderWidth)
        }
        .ignoresSafeArea()
        .presentationDetents([.height(Constants.Sizing.mainHeight)])
        .presentationCornerRadius(Constants.Sizing.mainCornerRadius)
        
        .onAppear {
            if let colourData = viewModel.selectedColourData, let colour = Color.decodeFromData(colourData) {
                selectedColour = colour
            } else {
                selectedColour = AppColours.appTheme
            }
        }
        
        .onChange(of: selectedColour) {
            viewModel.selectedColourData = selectedColour.encodeToData()
        }
    }
    
    private func pressSaveButton() {
        if viewModel.pressSaveButton(moc: moc) {
            dismiss()
        }
    }
    
    private func pressDeleteButton() {
        if viewModel.pressDeleteButton(moc: moc) {
            dismiss()
        }
    }
}


// MARK: - Subviews


extension AddEditWeeklyScheduleView {
    
    var categoryPicker: some View {
        HStack {
            Text("Category")
                .font(AppFonts.formHeading)
            
            Spacer()
            
            DropdownMenu(texts: viewModel.categoryTexts, selectedIndex: $viewModel.selectedCategoryIndex)
                .tint(selectedColour)
        }
    }
    
    var colourPickerView: some View {
        HStack {
            Text("Theme colour")
                .font(AppFonts.formHeading)
            
            Spacer()
            
            ColorPicker("", selection: $selectedColour)
        }
    }
    
    var deleteButton: some View {
        Button {
            isPresentingAreYouSureAlert = true
        } label: {
            Text("Delete")
                .font(AppFonts.deleteTextButton)
                .frame(maxWidth: .infinity)
                .frame(height: Constants.Sizing.buttonHeight)
                .foregroundStyle(.red)
        }
    }
}


// MARK: - Previews


struct AddEditWeeklyScheduleView_Previews: PreviewProvider {
    
    static let previewContext = PersistenceController.preview.container.viewContext
    static let weeklySchedule = PersistenceController.createMockWeeklySchedule(moc: previewContext)
    
    static var previews: some View {
        VStack {
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: .constant(true)) {
            AddEditWeeklyScheduleView(weeklySchedule: weeklySchedule)
                .environment(\.managedObjectContext, previewContext)
        }
    }
}
