//
//  Checkbox.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-10-13.
//

import SwiftUI

struct Checkbox: View {
    
    private enum Constants {
        enum ImageName {
            static let selected = "checkmark.circle.fill"
            static let unselected = "circle"
        }
    }
    
    @Binding var isSelected: Bool

    var body: some View {
        Image(systemName: isSelected ? Constants.ImageName.selected : Constants.ImageName.unselected)
            .font(AppFonts.checkbox)
            .foregroundStyle(.tint)
            .onTapGesture {
                withAnimation {
                    isSelected.toggle()
                }
            }
    }
}
