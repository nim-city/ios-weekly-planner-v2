//
//  ExpandCollapseButton.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-10-17.
//

import SwiftUI

struct ExpandCollapseButton: View {
    
    @Binding var isExpanded: Bool
    
    var body: some View {
        Button {
            isExpanded.toggle()
        } label: {
            Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                .font(AppFonts.detailLabel)
                .frame(width: 24, height: 24)
        }
    }
}


// MARK: - Previews


#Preview {
    
    @Previewable @State var isExpanded: Bool = false
    VStack {
        ExpandCollapseButton(isExpanded: $isExpanded)
            .background(.white)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.blue)
}
