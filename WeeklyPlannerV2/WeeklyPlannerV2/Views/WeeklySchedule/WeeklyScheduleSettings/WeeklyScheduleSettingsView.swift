//
//  WeeklyScheduleSettingsView.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-12-01.
//

import SwiftUI

struct WeeklyScheduleSettingsView: View {
    
    private enum Constants {
        enum Padding {
            static let allAround: CGFloat = 20
            static let top: CGFloat = 20
        }
        enum Spacing {
            static let mainVertical: CGFloat = 60
        }
    }
    
    @Environment(\.managedObjectContext) private var moc
    let weeklySchedule: WeeklySchedule
    let changeScheduleAction: () -> Void
    
    @State private var isPresentingEditScheduleSheet: Bool = false
    @State private var isPresentingDeleteScheduleAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Constants.Spacing.mainVertical) {
                    
                    Button {
                        isPresentingEditScheduleSheet = true
                    } label: {
                        Text("Update schedule info")
                            .font(AppFonts.controlLabel)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, Constants.Padding.top)
                    
                    Button {
                        changeScheduleAction()
                    } label: {
                        Text("Change schedule")
                            .font(AppFonts.controlLabel)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button {
                        isPresentingDeleteScheduleAlert = true
                    } label: {
                        Text("Delete schedule")
                            .font(AppFonts.deleteTextButton)
                            .tint(.red)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(Constants.Padding.allAround)
            }
            .navigationTitle("Settings")
            
            // Edit schedule sheet
            .sheet(isPresented: $isPresentingEditScheduleSheet) {
                AddEditWeeklyScheduleView(weeklySchedule: weeklySchedule)
            }
            
            // Delete schedule alert
            .alert("Delete schedule", isPresented: $isPresentingDeleteScheduleAlert) {
                Button("No", role: .cancel) {}
                Button("Yes", role: .destructive) {
                    deleteWeeklySchedule()
                }
            } message: {
                Text("Are you sure you want to delete this schedule?")
            }
        }
    }
}

// MARK: - Functionality


extension WeeklyScheduleSettingsView {
    
    private func deleteWeeklySchedule() {
        
        moc.delete(weeklySchedule)
        
        do {
            
            try moc.save()
            changeScheduleAction()
        } catch let error {
            
            print(error)
        }
    }
}


// MARK - Subviews


//extension WeeklyScheduleSettingsView {
//    
//    struct SettingsTile: View {
//        
//        private enum Constants {
//            enum Padding {
//                static let horizontal: CGFloat = 20
//            }
//            enum Sizing {
//                static let borderWidth: CGFloat = 1
//                static let cornerRadius: CGFloat = 10
//                static let height: CGFloat = 60
//            }
//        }
//        
//        let title: String
//        let onPress: () -> Void
//        
//        var body: some View {
//            Button {
//                
//                onPress()
//            } label: {
//                
//                HStack {
//                    
//                    FormHeadingLabel(title)
//                    
//                    Spacer()
//                }
//                .padding(.horizontal, Constants.Padding.horizontal)
//                .frame(height: Constants.Sizing.height)
//                .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius))
//                .overlay {
//                    RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius)
//                        .stroke(.black, lineWidth: Constants.Sizing.borderWidth)
//                }
//            }
//            .tint(.black)
//        }
//    }
//}


// MARK: - Previews


struct WeeklyScheduleSettingsView_Previews: PreviewProvider {
    
    static let previewContext = PersistenceController.preview.container.viewContext
    static let weeklySchedule = PersistenceController.createMockWeeklySchedule(moc: previewContext)
    
    static var previews: some View {
        WeeklyScheduleSettingsView(weeklySchedule: weeklySchedule) {}
            .environment(\.managedObjectContext, previewContext)
    }
}
