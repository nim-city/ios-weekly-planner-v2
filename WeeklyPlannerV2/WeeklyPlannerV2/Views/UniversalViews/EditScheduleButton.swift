//
//  EditScheduleButton.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-11-21.
//

import SwiftUI

struct EditScheduleButton: View {
    
    private enum Constants {
        enum Colours {
            static let defaultTint: Color = AppColours.offBlack
        }
        enum ImageName {
            static let editImage: String = "square.and.pencil"
        }
        enum Sizing {
            static let defaultSize: CGFloat = 25
        }
    }
    
    let tint: Color
    let size: CGFloat
    let action: () -> Void
    
    init(tint: Color? = nil, size: CGFloat? = nil, action: @escaping () -> Void) {
        
        self.tint = tint ?? Constants.Colours.defaultTint
        self.size = size ?? Constants.Sizing.defaultSize
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: Constants.ImageName.editImage)
                .resizable()
                .renderingMode(.template)
                .tint(tint)
                .frame(width: size,
                       height: size)
        }
    }
}
