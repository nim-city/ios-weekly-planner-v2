//
//  WeeklySchedulesListItemView.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2026-01-25.
//

import SwiftUI

extension WeeklySchedulesListView {
    
    struct WeeklyScheduleListItemView: View {
        
        private enum Constants {
            enum ImageNames {
                static let workDay: String = "pc"
                static let restDayHoliday: String = "beach.umbrella.fill"
                static let restDay: String = "bed.double.fill"
            }
            enum Padding {
                static let allAround: CGFloat = 16
                static let infoLabelLeading: CGFloat = 5
            }
            enum Sizing {
                static let cornerRadius: CGFloat = 12
                static let borderWidth: CGFloat = 2
                static let weekdayIconWidth: CGFloat = 30
                static let weekdayLabelSize: CGFloat = 24
            }
            enum Spacing {
                static let vertical: CGFloat = 15
                static let weekdaySpacing: CGFloat = 12
            }
        }
        
        @ObservedObject private var weeklySchedule: WeeklySchedule
        private let themeColour: Color
        private let title: String
        private let scheduleType: String?
        
        init(weeklySchedule: WeeklySchedule) {
            
            self.weeklySchedule = weeklySchedule
            self.themeColour = AppColours.getColourForWeeklySchedule(weeklySchedule)
            self.title = weeklySchedule.name ?? "Weekly Schedule"
            self.scheduleType = weeklySchedule.category?.weekTypeLabel
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: Constants.Spacing.vertical) {
                
                Text(title)
                    .font(AppFonts.title)
                
                if let type = scheduleType {
                    Text(type)
                        .font(AppFonts.infoLabel)
                        .padding(.leading, Constants.Padding.infoLabelLeading)
                }

                weekdaysView
            }
            .padding(Constants.Padding.allAround)
            .contentShape(RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius))
            .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius))
            .overlay {
                RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius)
                    .stroke(themeColour, lineWidth: Constants.Sizing.borderWidth)
            }
        }
        
        private func getIsWeekdayAWorkDay(_ weekday: Weekday) -> Bool {
            weeklySchedule.workDays.contains(weekday)
        }
        
        private func getImageNameForWeekday(_ weekday: Weekday) -> String {
            
            if weeklySchedule.workDays.contains(weekday) {
                return Constants.ImageNames.workDay
            }

            if weeklySchedule.category == .holiday {
                return Constants.ImageNames.restDayHoliday
            } else {
                return Constants.ImageNames.restDay
            }
        }
    }
}


// MARK: - Subviews


extension WeeklySchedulesListView.WeeklyScheduleListItemView {
    
    private var weekdaysView: some View {
        
        HStack(alignment: .top, spacing: Constants.Spacing.weekdaySpacing) {
            
            ForEach(Weekday.allCases) { weekday in
                
                let imageName = getImageNameForWeekday(weekday)
                
                VStack(spacing: 0) {
                    
                    Text(weekday.initial)
                        .font(AppFonts.iconSmall)
                        .frame(width: Constants.Sizing.weekdayLabelSize,
                               height: Constants.Sizing.weekdayLabelSize)
                    
                    Image(systemName: imageName)
                        .font(AppFonts.iconLarge)
                        .foregroundStyle(themeColour)
                }
                .frame(width: Constants.Sizing.weekdayIconWidth)
            }
            
            Spacer()
        }
    }
}
