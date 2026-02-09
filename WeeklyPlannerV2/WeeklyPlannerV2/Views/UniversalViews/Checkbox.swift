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
        Group {
            if isSelected {
                Image(systemName: Constants.ImageName.selected)
                    .foregroundStyle(.tint)
                    .onTapGesture {
                        withAnimation {
                            isSelected.toggle()
                        }
                    }
            } else {
                Image(systemName: Constants.ImageName.unselected)
                    .foregroundStyle(.tint)
                    .onTapGesture {
                        withAnimation {
                            isSelected.toggle()
                        }
                    }
            }
        }
        .font(.system(size: 24, weight: .regular))
    }
}
