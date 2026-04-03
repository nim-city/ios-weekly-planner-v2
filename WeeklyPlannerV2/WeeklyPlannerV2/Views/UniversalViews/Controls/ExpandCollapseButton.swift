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
            static let chevronRight = "chevron.right"
        }
        enum Sizing {
            static let outerSize: CGFloat = 24
        }
    }
    
    @Binding var isExpanded: Bool
    
    private var rotation: Angle {
        isExpanded ? .degrees(90) : .degrees(0)
    }
    
    var body: some View {
        Button(action: pressButton) {
            Image(systemName: Constants.ImageName.chevronRight)
                .font(AppFonts.detailLabel)
                .frame(width: Constants.Sizing.outerSize, height: Constants.Sizing.outerSize)
                .rotationEffect(rotation)
        }
    }
    
    private func pressButton() {
        withAnimation(.snappy) {
            isExpanded.toggle()
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
