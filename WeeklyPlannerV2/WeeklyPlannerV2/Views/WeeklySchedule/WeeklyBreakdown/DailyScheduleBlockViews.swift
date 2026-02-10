//
//  DailyScheduleBlockViews.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-10-30.
//

import SwiftUI

struct HourBlockView: View {
    
    private enum Constants {
        enum Padding {
            static let dividerLeading: CGFloat = 50
            static let dividerTop: CGFloat = 10
        }
        enum Sizing {
            static let dividerHeight: CGFloat = 1
        }
    }
    
    let hour: Int
    let height: CGFloat
    
    private var hourString: String {
        DateTimeFunctions.getHoursStringForHour(hour)
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            ScheduleTimeLabel(hourString)
                .offset(y: -height / 2) // For some reason the view is shifted down by height / 2 so this balances it out
            
            Rectangle()
                .frame(height: Constants.Sizing.dividerHeight)
                .foregroundStyle(AppColours.subtleDivider)
                .padding(.leading, Constants.Padding.dividerLeading)
                .padding(.top, Constants.Padding.dividerTop)
                .offset(y: -height / 2) // For some reason the view is shifted down by height / 2 so this balances it out
        }
        .frame(height: height)
        .contentShape(Rectangle())
    }
}

struct TaskBlockView: View {
    
    private enum Constants {
        enum Padding {
            static let leading: CGFloat = 50
        }
        enum Sizing {
            static let cornerRadius: CGFloat = 15
            static let borderWidth: CGFloat = 5
            static let dividerHeight: CGFloat = 1
        }
    }
    
    @ObservedObject var taskBlock: TaskBlock
    let minimumHeight: CGFloat
    private var backgroundGradient: LinearGradient {
        LinearGradient(colors: [AppColours.getColourForTaskItemBlock(taskBlock).opacity(0.5),
                                AppColours.getColourForTaskItemBlock(taskBlock).opacity(0.6)],
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
    }
    
    private var height: CGFloat {
        CGFloat(taskBlock.totalHours) * minimumHeight
    }
    
    private var title: String {
        taskBlock.name ?? taskBlock.categoryName ?? "Task block"
    }
    
    var body: some View {
        ZStack {
            Color.white
                .frame(height: height)
                .frame(maxWidth: .infinity)
            
            VStack(spacing: 0) {
                
                Text(title)
                    .font(AppFonts.subtitle)
                    .frame(height: minimumHeight)
                
                if height > minimumHeight {
                    Spacer()
                }
            }
            .frame(height: height)
            .frame(maxWidth: .infinity)
            .background(backgroundGradient)
        }
        .compositingGroup()
        .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius))
        .overlay {
            RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius)
                .strokeBorder(AppColours.getColourForTaskItemBlock(taskBlock).opacity(0.05),
                              lineWidth: Constants.Sizing.borderWidth)
        }
        .overlay {
            RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius)
                .strokeBorder(AppColours.getColourForTaskItemBlock(taskBlock).opacity(0.1),
                              lineWidth: Constants.Sizing.borderWidth / 2)
        }
        .padding(.leading, Constants.Padding.leading)
        .shadow(color: AppColours.shadowColour, radius: 5, x: 5, y: 5)
    }
}
