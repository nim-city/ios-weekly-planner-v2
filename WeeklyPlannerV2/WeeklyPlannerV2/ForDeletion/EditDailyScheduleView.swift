//
//  EditDailyScheduleView.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-09-15.
//

import SwiftUI

struct EditDailyScheduleView: View {
    
    private enum Constants {
        enum ImageName {
            static let canceButton = "xmark"
            static let saveButton = "opticaldiscdrive"
        }
        enum Padding {
            static let headerHorizontal: CGFloat = 10
            static let titleHorizontal: CGFloat = 22
            static let top: CGFloat = 100
            static let weekdayButtonsBottom: CGFloat = 15
            static let weekdayButtonsTop: CGFloat = 15
        }
        enum Sizing {
            static let cancelButtonSize: CGFloat = 20
            static let editButtonSize: CGFloat = 25
            static let headerButtonSize: CGFloat = 45
        }
        enum Spacing {
            static let headerVertical: CGFloat = 20
            static let headerButtonSpacing: CGFloat = 20
        }
    }
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: EditDailyScheduleViewModel
    
    
    init(weeklySchedule: WeeklySchedule, initialWeekdayIndex: Int) {
        _viewModel = .init(wrappedValue: .init(weeklySchedule: weeklySchedule,
                                               initialWeekdayIndex: initialWeekdayIndex))
    }
    
    var body: some View {
        NavigationStack {
            
            EditDailyScheduleView(viewModel: viewModel)
                .padding(.top, Constants.Padding.top)
            
                // Header
                .overlay(alignment: .top) {
                    header
                }
                
                // Edit task item block view
                .sheet(isPresented: $viewModel.isPresentingAddEditTaskBlockView) {
                    
//                    if let taskBlock = viewModel.getSelectedTaskBlock() {
//                        
//                        AddEditTaskBlockView(dailySchedule: viewModel.dailySchedule, taskBlock: taskBlock)
//                    } else {
//                        
//                        AddEditTaskBlockView(dailySchedule: viewModel.dailySchedule, startHour: viewModel.selectedHour ?? 0)
//                    }
                }
        }
    }
    
    private func cancel() {
        viewModel.revertMock(moc: moc)
        dismiss()
    }
    
    private func save() {
        if viewModel.save(moc: moc) {
            dismiss()
        }
    }
}


// MARK: - Header subviews


extension EditDailyScheduleView {
    
    private var header: some View {
        VStack(spacing: 0) {
            
            Spacer()
            
            titleView
                .padding(.horizontal, Constants.Padding.titleHorizontal)
            
            weekdayButtonsView
                .padding(EdgeInsets(top: Constants.Padding.weekdayButtonsTop,
                                    leading: Constants.Padding.headerHorizontal,
                                    bottom: Constants.Padding.weekdayButtonsBottom,
                                    trailing: Constants.Padding.headerHorizontal))
            
            Divider()
                .background(AppColours.offBlack)
        }
        .background(.white)
        .frame(height: Constants.Padding.top)
    }
    
    private var titleView: some View {
        HStack(alignment: .top) {
            
            // Cancel button
            Button {
                cancel()
            } label: {
                Image(systemName: Constants.ImageName.canceButton)
                    .resizable()
                    .renderingMode(.template)
                    .tint(AppColours.offBlack)
                    .frame(width: Constants.Sizing.cancelButtonSize,
                           height: Constants.Sizing.cancelButtonSize)
            }
            
            TitleLabel(viewModel.title)
                .frame(maxWidth: .infinity)
            
            // Edit button
            Button {
                save()
            } label: {
                Image(systemName: Constants.ImageName.saveButton)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .tint(AppColours.offBlack)
                    .frame(height: Constants.Sizing.cancelButtonSize)
            }
        }
    }
    
    private var weekdayButtonsView: some View {
        HStack(spacing: 0) {
            ForEach(Weekday.allCases) { weekday in
                
                let isSelected = viewModel.getIsWeekdaySelected(weekday)
                
                Button(weekday.shortName) {
                    
                    viewModel.selectWeekday(weekday)
                }
                .tint(isSelected ? .white : .black)
                .font(.system(size: 16, weight: .medium))
                .frame(width: Constants.Sizing.headerButtonSize,
                       height: Constants.Sizing.headerButtonSize)
                .background(isSelected ? .black : .white)
                .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.headerButtonSize / 2))
            }
            .frame(maxWidth: .infinity)
        }
    }
}


// MARK: - Subviews


extension EditDailyScheduleView {
    
    private struct EditDailyScheduleView: View {
        
        private enum Constants {
            enum Padding {
                static let leading: CGFloat = 10
                static let mainTop: CGFloat = 25
                static let trailing: CGFloat = 20
            }
            enum Sizing {
                static let taskBlockBorderWidth: CGFloat = 4
                static let listItemHeight: CGFloat = 50
            }
        }
        
        @Environment(\.managedObjectContext) var moc
        @Environment(\.dismiss) var dismiss
        @ObservedObject var viewModel: EditDailyScheduleViewModel
        
        var body: some View {
            NavigationStack {
                ScrollView {
                    ZStack(alignment: .top) {
                        
                        VStack(spacing: 0) {
                            ForEach(DateTimeFunctions.dailyScheduleHours, id: \.self) { hour in
                                HourBlockView(hour: hour, height: Constants.Sizing.listItemHeight)
                                    .onTapGesture {
                                        viewModel.tapOnHourBlock(forHour: hour)
                                    }
                            }
                        }
                        
                        ForEach(viewModel.taskBlocks, id: \.self) { taskBlock in
                            
                            TaskBlockView(taskBlock: taskBlock, minimumHeight: Constants.Sizing.listItemHeight)
                                .offset(y: getOffset(forTaskBlock: taskBlock))
                                .allowsHitTesting(false)
                        }
                    }
                    .padding(.leading, Constants.Padding.leading)
                    .padding(.trailing, Constants.Padding.trailing)
                    .padding(.top, Constants.Padding.mainTop)
                }
            }
        }
        
        private func getOffset(forTaskBlock taskBlock: TaskBlock) -> CGFloat {
            CGFloat(taskBlock.startHour) * Constants.Sizing.listItemHeight + Constants.Sizing.taskBlockBorderWidth
        }
    }
}


// MARK: - Previews


struct EditDailyScheduleView_Previews: PreviewProvider {
    
    static let previewContext = PersistenceController.preview.container.viewContext
    static let weeklySchedule = PersistenceController.createMockWeeklySchedule(moc: previewContext)
    
    static var previews: some View {
        EditDailyScheduleView(weeklySchedule: weeklySchedule, initialWeekdayIndex: 0)
            .environment(\.managedObjectContext, previewContext)
    }
}
