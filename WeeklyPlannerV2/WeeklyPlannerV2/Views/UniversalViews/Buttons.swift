//
//  Buttons.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-12-02.
//

import SwiftUI

struct TextButton: View {
    
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button {
            
            action()
        } label: {
            
            Text(text)
                .font(.system(size: 18, weight: .medium))
        }
    }
}
