//
//  SetTimeView.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2026-05-11.
//

import SwiftUI

extension AddEditTaskBlockView {
    
    struct SetTimeView: View {
        
        private enum Constants {
            enum Padding {
                static let mainHorizontal: CGFloat = 10
                static let mainVertical: CGFloat = 5
            }
            enum Sizing {
                static let cornerRadius: CGFloat = 12
                static let borderWidth: CGFloat = 2
                static let timeWheel: (width: CGFloat, height: CGFloat) = (50, 40)
            }
        }
        
        private let allMinutes: [Int] = [0, 15, 30, 45]
        
        let title: String
        let allHours: [Int]
        @Binding var hour: Int
        @Binding var minutes: Int
        
        var body: some View {
            HStack {
                
                Text(title)
                    .font(AppFonts.formHeading)
                
                Spacer()
                
                HStack(spacing: 0) {
                    Picker("Hour", selection: $hour) {
                        ForEach(allHours, id: \.self) { hour in
                            Text(getHourString(forHour: hour))
                                .font(AppFonts.controlLabel)
                                .foregroundStyle(.black)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(maxWidth: Constants.Sizing.timeWheel.width,
                           maxHeight: Constants.Sizing.timeWheel.height)
                    
                    
                    Text(":")
                        .font(AppFonts.controlLabel)
                        .foregroundStyle(.black)
                    
                    Picker("Minutes", selection: $minutes) {
                        ForEach(allMinutes, id: \.self) { minute in
                            Text(getMinutesString(forMinutes: minute))
                                .font(AppFonts.controlLabel)
                                .foregroundStyle(.black)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(maxWidth: Constants.Sizing.timeWheel.width,
                           maxHeight: Constants.Sizing.timeWheel.height)
                    
                    Text(getAMPMString(forHour: hour))
                        .font(AppFonts.controlLabel)
                        .foregroundStyle(.black)
                }
                .padding(.horizontal, Constants.Padding.mainHorizontal)
                .padding(.vertical, Constants.Padding.mainVertical)
                .background(.tint.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius))
                .overlay {
                    RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius)
                        .stroke(.tint, lineWidth: Constants.Sizing.borderWidth)
                }
                .modifier(SunkenStyle())
            }
        }
    }
}


// MARK: Functionality


extension AddEditTaskBlockView.SetTimeView {
    
    func getHourString(forHour hour: Int) -> String {
        hour > 12 ? "\(hour - 12)" : hour == 0 ? "12" : "\(hour)"
    }
    
    func getMinutesString(forMinutes minutes: Int) -> String {
        minutes == 0 ? "00" : "\(minutes)"
    }
    
    func getAMPMString(forHour hour: Int) -> String {
        if hour == 24 || hour < 12 { return "am" }
        return "pm"
    }
}
