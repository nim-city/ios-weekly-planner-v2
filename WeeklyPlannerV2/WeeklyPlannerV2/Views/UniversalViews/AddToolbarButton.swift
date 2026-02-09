//
//  AddToolbarButton.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-10-11.
//

import SwiftUI

struct AddToolbarButton: View {
    
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "plus")
                .renderingMode(.template)
                .resizable()
                .tint(AppColours.appTheme)
                .frame(width: 24, height: 24)
        }
    }
}
