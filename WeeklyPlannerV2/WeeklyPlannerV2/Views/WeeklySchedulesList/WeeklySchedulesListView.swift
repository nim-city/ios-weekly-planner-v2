//
//  WeeklySchedulesListView.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-09-07.
//

import SwiftUI

struct WeeklySchedulesListView: View {
    
    private enum Constants {
        enum Padding {
            static let addButton: (bottom: CGFloat, trailing: CGFloat) = (40, 40)
            static let listRowInsets: EdgeInsets = .init(top: 1, leading: 1, bottom: 1, trailing: 1)
            static let mainContent: CGFloat = 20
        }
        enum Spacing {
            static let emptyViewVertical: CGFloat = 15
            static let listRowSpacing: CGFloat = 20
        }
    }
    
    @FetchRequest(sortDescriptors: []) var weeklySchedules: FetchedResults<WeeklySchedule>
    
    let selectScheduleAction: (WeeklySchedule) -> Void
    @State private var isPresentingAddWeeklyScheduleView = false
    @State private var weeklyScheduleToEdit: WeeklySchedule?
    
    var body: some View {
        NavigationStack {
            Group {
                
                if weeklySchedules.isEmpty {
                    
                    emptyView
                } else {
                    
                    weeklySchedulesList
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Navigation bar
            .navigationTitle("Weekly Schedules")
            .navigationBarBackButtonHidden(true)
            
            // Add weekly schedule sheet
            .sheet(isPresented: $isPresentingAddWeeklyScheduleView) {
                AddEditWeeklyScheduleView()
            }
            // Edit weekly schedule sheet
            .sheet(item: $weeklyScheduleToEdit) { weeklySchedule in
                AddEditWeeklyScheduleView(weeklySchedule: weeklySchedule)
            }

            .overlay(alignment: .bottomTrailing) {
                FloatingAddButtonView {
                    isPresentingAddWeeklyScheduleView = true
                }
                .padding(.bottom, Constants.Padding.addButton.bottom)
                .padding(.trailing, Constants.Padding.addButton.trailing)
            }
        }
    }
}


// MARK: - Subviews


extension WeeklySchedulesListView {
    
    var emptyView: some View {
        VStack(spacing: Constants.Spacing.emptyViewVertical) {
            
            InfoLabelLarge("No weekly schedules yet")
            
            TextButton(text: "Add a schedule") {
                withAnimation {
                    isPresentingAddWeeklyScheduleView = true
                }
            }
            .italic()
            .foregroundStyle(AppColours.appTheme)
        }
    }
    
    private var weeklySchedulesList: some View {
        
        List(weeklySchedules) { weeklySchedule in
            
            WeeklyScheduleListItemView(weeklySchedule: weeklySchedule)
                .listRowSeparator(.hidden)
                .listRowInsets(Constants.Padding.listRowInsets)
                .onTapGesture {
                    withAnimation {
                        selectScheduleAction(weeklySchedule)
                    }
                }
                .onLongPressGesture {
                    selectWeeklyScheduleToEdit(weeklySchedule)
                }
        }
        .listStyle(.plain)
        .listRowSpacing(Constants.Spacing.listRowSpacing)
        .padding(Constants.Padding.mainContent)
    }
    
    private func selectWeeklyScheduleToEdit(_ weeklySchedule: WeeklySchedule) {
        
        AppAnimations.makeLongPressFeedback()
        weeklyScheduleToEdit = weeklySchedule
    }
}


// MARK: - Previews


#Preview {
    WeeklySchedulesListView(selectScheduleAction: { _ in })
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
