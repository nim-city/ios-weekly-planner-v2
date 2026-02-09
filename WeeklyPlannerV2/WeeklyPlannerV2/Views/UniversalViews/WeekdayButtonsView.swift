//
//  WeekdayButtonsView.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-12-05.
//

import SwiftUI

struct WeekdayButtonsView: View {
    
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
