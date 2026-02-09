//
//  DropdownMenu.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-10-27.
//

import SwiftUI

struct DropdownMenu: View {
    
    private enum Constants {
        enum ImageName {
            static let checkmark = "checkmark"
            static let downArrow = "arrowtriangle.down.fill"
        }
        enum Padding {
            static let menuItemHorizontal: CGFloat = 15
            static let menuItemVertical: CGFloat = 10
        }
        enum Sizing {
            static let borderWidth: CGFloat = 2
            static let cornerRadius: CGFloat = 10
            static let downArrowHeight: CGFloat = 5
            static let downArrowWidth: CGFloat = 10
        }
        enum Spacing {
            static let menuItemHorizontal: CGFloat = 15
        }
    }
    
    let texts: [String]
    @Binding var selectedIndex: Int

    var body: some View {
        Menu {
            ForEach(texts.indices, id: \.self) { index in
                
                let text = texts[index]
                
                Button {
                    
                    selectedIndex = index
                } label: {
                    
                    HStack(spacing: 0) {

                        Text(text)

                        if index == selectedIndex {
                            Image(systemName: Constants.ImageName.checkmark)
                                .renderingMode(.template)
                                .tint(.black)
                        }
                    }
                }
            }
        } label: {
            
            HStack(spacing: Constants.Spacing.menuItemHorizontal) {

                Text(texts[selectedIndex])
                    .foregroundStyle(.tint)
                    .font(AppFonts.controlLabel)

                Image(systemName: Constants.ImageName.downArrow)
                    .resizable()
                    .foregroundStyle(.tint)
                    .frame(width: Constants.Sizing.downArrowWidth, height: Constants.Sizing.downArrowHeight)
            }
            .padding(.horizontal, Constants.Padding.menuItemHorizontal)
            .padding(.vertical, Constants.Padding.menuItemVertical)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius))
        }
        .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius))
        .overlay {
            RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius)
                .strokeBorder(.tint, lineWidth: Constants.Sizing.borderWidth)
        }
    }
}


// MARK: - Previews


#Preview {
    
    @Previewable @State var selectedIndex = 0
    DropdownMenu(texts: ["Item 1", "Item 2", "Item 3"], selectedIndex: $selectedIndex)
}
