//
//  LabelledTextField.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-10-26.
//

import SwiftUI

struct LabelledTextField: View {
    
    private enum Constants {
        enum Padding {
            static let allAround: CGFloat = 16
            static let characterCount: (trailing: CGFloat, bottom: CGFloat) = (8, 8)
            static let textField: CGFloat = 12
            static let textFieldLeading: CGFloat = 20
            static let textFieldHorizontal: CGFloat = 5
        }
        enum Sizing {
            static let borderWidth: CGFloat = 2
            static let cornerRadius: CGFloat = 10
            static let labelHeight: CGFloat = 20
            
            static let labelOffset: CGFloat = labelHeight / 2
        }
    }
    
    @Binding var text: String
    let prompt: String
    let maxCharacterCount: Int?
    
    @State private var isNameLabelShowing: Bool = false
    
    private var characterCountText: String? {
        guard let maxCharacterCount else { return nil }
        return "\(text.count)/\(maxCharacterCount)"
    }
    
    init(text: Binding<String>, prompt: String, maxCharacterCount: Int? = nil) {
        self._text = text
        self.prompt = prompt
        self.maxCharacterCount = maxCharacterCount
    }
    
    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                
                ZStack(alignment: .bottomTrailing) {
                    
                    // Text field
                    TextField(prompt, text: $text)
                        .font(.system(size: 20, weight: .regular))
                        .textFieldStyle(.plain)
                        .autocorrectionDisabled()
                        .foregroundStyle(AppColours.offBlack)
                        .padding(Constants.Padding.textField)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius))
                        .overlay {
                            RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius)
                                .stroke(.tint, lineWidth: Constants.Sizing.borderWidth)
                        }
                    
                    // Character count label
                    if let characterCountText {
                        Text(characterCountText)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(AppColours.offBlack)
                            .padding(.trailing, Constants.Padding.characterCount.trailing)
                            .padding(.bottom, Constants.Padding.characterCount.bottom)
                    }
                }
                
                if isNameLabelShowing {
                    Text(prompt)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.tint)
                        .frame(height: Constants.Sizing.labelHeight)
                        .padding(.horizontal, Constants.Padding.textFieldHorizontal)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .offset(x: Constants.Padding.textFieldLeading, y: -Constants.Sizing.labelOffset)
                }
            }
            .padding(.top, Constants.Sizing.labelOffset)
            .background(.clear)
        }
        .onChange(of: text) { oldValue, newValue in
            withAnimation(.easeInOut(duration: 0.1)) {
                textChanged(oldValue: oldValue, newValue: newValue)
            }
        }
        .onAppear {
            showHideNameLabel()
        }
    }
    
    private func textChanged(oldValue: String, newValue: String) {
        
        showHideNameLabel()
        
        if let maxCharacterCount {
            if newValue.count > maxCharacterCount {
                text = oldValue
            }
        }
    }
    
    private func showHideNameLabel() {
        if text.isEmpty {
            if isNameLabelShowing {
                isNameLabelShowing = false
            }
        } else {
            if !isNameLabelShowing {
                isNameLabelShowing = true
            }
        }
    }
}


#Preview {
    
    // Labelled text field
    @Previewable @State var text = ""
    LabelledTextField(text: $text, prompt: "Name", maxCharacterCount: 30)
}
