//
//  WorkoutView.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-10-27.
//

import SwiftUI

extension AddEditTaskItemView {
    
    struct WorkoutView: View {
        
        private enum Constants {
            enum ImageName {
                static let add: String = "plus"
            }
            enum Padding {
                static let allAround: CGFloat = 15
            }
            enum Sizing {
                static let borderWidth: CGFloat = 1
                static let cornerRadius: CGFloat = 10
            }
            enum Spacing {
                static let headingHorizontal: CGFloat = 20
                static let listItemHorizontal: CGFloat = 5
                static let listItemVertical: CGFloat = 5
                static let mainVertical: CGFloat = 10
            }
        }
        
        @Binding var exercises: [String]
        
        var body: some View {
            VStack(alignment: .leading, spacing: Constants.Spacing.mainVertical) {
                
                header
                
                exercisesList
            }
            .frame(maxWidth: .infinity)
        }
        
        private func addExercise() {
            
            // Only add an exercise if there aren't any with empty names
            guard !exercises.contains(where: { $0.isEmpty }) else {
                return
            }
            
            exercises.append("")
        }
    }
}


// MARK: - Subviews


extension AddEditTaskItemView.WorkoutView {
    
    private var header: some View {
        HStack(spacing: Constants.Spacing.headingHorizontal) {
            
            Text("Exercises")
                .font(AppFonts.formHeading)
            
            Button {
                withAnimation {
                    addExercise()
                }
            } label: {
                Image(systemName: Constants.ImageName.add)
                    .font(.system(size: 18, weight: .semibold))
            }
            
            Spacer()
        }
    }
    
    private var exercisesList: some View {
        VStack(spacing: Constants.Spacing.listItemVertical) {
            ForEach(0..<exercises.count, id: \.self) { index in
                HStack(spacing: Constants.Spacing.listItemHorizontal) {
                    Text("\(index + 1).")
                    
                    Spacer()
                    
                    TextField("Exercise \(index) text field",
                              text: Binding(get: { exercises[index] }, set: { exercises[index] = $0 }), prompt: Text("Exercise info"))
                    .textFieldStyle(.roundedBorder)
                }
            }
        }
        .padding(Constants.Padding.allAround)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius))
        .overlay {
            RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius)
                .stroke(.tint, lineWidth: Constants.Sizing.borderWidth)
        }
    }
}
