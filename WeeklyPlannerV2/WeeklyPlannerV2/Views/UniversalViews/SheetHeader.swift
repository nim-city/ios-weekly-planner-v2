//
//  SheetHeader.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-11-02.
//

import SwiftUI


struct SheetHeaderModifier: ViewModifier {
    
    enum CancelButtonStyle {
        case back
        case close
    }
    
    private enum Constants {
        
        static let subduedOpacity: Double = 0.5
        enum ImageName {
            static let backButton = "arrow.backward"
            static let closeButton = "xmark"
            static let saveButton = "checkmark"
        }
        enum Sizing {
            static let headerButtonSize: CGFloat = 16
        }
    }
    
    private let title: String
    private let cancelButtonStyle: CancelButtonStyle
    private let isSaveEnabled: Bool
    private let cancelAction: (() -> Void)?
    private let saveAction: (() -> Void)?
    private let cancelButtonImageName: String
    
    private var saveButtonOpacity: Double {
        isSaveEnabled ? 1.0 : Constants.subduedOpacity
    }
    
    init(title: String, cancelButtonStyle: CancelButtonStyle, isSaveEnabled: Bool = true, cancelAction: (() -> Void)? = nil, saveAction: (() -> Void)? = nil) {
        
        self.title = title
        self.cancelButtonStyle = cancelButtonStyle
        self.isSaveEnabled = isSaveEnabled
        self.cancelAction = cancelAction
        self.saveAction = saveAction
        
        switch cancelButtonStyle {
        case .back:
            cancelButtonImageName = Constants.ImageName.backButton
        case .close:
            cancelButtonImageName = Constants.ImageName.closeButton
        }
    }
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                // Cancel button
                if let cancelAction {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            cancelAction()
                        } label: {
                            Image(systemName: cancelButtonImageName)
                                .font(AppFonts.sheetButton)
                                .foregroundStyle(.tint)
                        }
                    }
                }
                
                // Title
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .font(AppFonts.sheetTitle)
                }
                
                // Save button
                if let saveAction {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            saveAction()
                        } label: {
                            Image(systemName: Constants.ImageName.saveButton)
                                .font(AppFonts.sheetButton)
                                .foregroundStyle(.tint.opacity(saveButtonOpacity))
                        }
                        .disabled(!isSaveEnabled)
                    }
                }
            }
    }
}

extension View {
    
    func sheetHeader(title: String,
                      cancelButtonStyle: SheetHeaderModifier.CancelButtonStyle = .close,
                      isSaveEnabled: Bool = true,
                      cancelAction: (() -> Void)? = nil,
                      saveAction: (() -> Void)? = nil) -> some View {
        
        self.modifier(SheetHeaderModifier(title: title,
                                          cancelButtonStyle: cancelButtonStyle,
                                          isSaveEnabled: isSaveEnabled,
                                          cancelAction: cancelAction,
                                          saveAction: saveAction))
    }
}
