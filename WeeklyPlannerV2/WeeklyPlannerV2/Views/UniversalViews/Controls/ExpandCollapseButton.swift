//
//  ExpandCollapseButton.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-10-17.
//

import SwiftUI

struct ExpandCollapseButton: View {
    
    private enum Constants {
        enum ImageName {
            static let chevronDown = "chevron.down"
            static let chevronRight = "chevron.right"
        }
        enum Sizing {
            static let outerSize: CGFloat = 24
        }
    }
    
    @Binding var isExpanded: Bool
    
    var body: some View {
        Button {
            isExpanded.toggle()
        } label: {
            Image(systemName: isExpanded ? Constants.ImageName.chevronDown : Constants.ImageName.chevronRight)
                .font(AppFonts.detailLabel)
                .frame(width: Constants.Sizing.outerSize, height: Constants.Sizing.outerSize)
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
