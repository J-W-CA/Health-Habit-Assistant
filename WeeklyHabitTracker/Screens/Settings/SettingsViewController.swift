//
//  SettingsViewController.swift
//  WeeklyHabitTracker
//
//  Created by Jason Wang on 4/20/20.
//  Copyright © 2020 Jason Wang. All rights reserved.
//

import UIKit
import SwiftUI
import CoreML

class SettingsViewController: UIHostingController<SettingsSwiftUI> {
    
}

struct SettingsSwiftUI: View {
    //    @State private var sleepingHours = 8.0
    @State private var coffeeAmount = 1
    @State private var sleepAmount = 8.0
    @State private var wakeUp = DefaultWakeUpTime
    
    @State private var alertTitle = ""
    @State private var alertMsg = ""
    @State private var showingAlert = false
    
    
    static var DefaultWakeUpTime : Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    struct ListCell: View {
        let image: Image
        let title: Text
        @State private var isOn = false
        
        var body: some View {
            HStack {
                image
                title
            }
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                VStack(alignment: .leading, spacing: 10){
                    
                    Text("When do you want to wake up?").font(.headline)
                    DatePicker("Please select a date",selection: $wakeUp, displayedComponents : .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                }
                VStack(alignment: .leading, spacing: 10){
                    
                    Text("Desired Amount of Sleep").font(.headline)
                    
                    Stepper(value : $sleepAmount, in: 4...12,step: 0.25){
                        Text("\(sleepAmount , specifier: "%g") hrs")
                    }
                }
                VStack(alignment: .leading, spacing: 10){
                    
                    Text("Daily Coffee Intake").font(.headline)
                    
                    Stepper(value : $coffeeAmount, in: 1...20){
                        if coffeeAmount == 1 {
                            Text("1 cup")
                        }
                        else {
                            Text("\(coffeeAmount) cups")
                        }
                    }
                }
                VStack(alignment: .leading, spacing: 10){
                    ListCell(image: Image("clock"), title: Text("Default Reminder Time"))
                   
                }
                VStack(alignment: .leading, spacing: 10){
                    ListCell(image: Image("app.badge"), title: Text("Due Today Icon Badge"))
                   
                }
                VStack(alignment: .leading, spacing: 10){
                    ListCell(image: Image(systemName: "faceid"), title: Text("Authentication"))
                   
                }
                
            }.navigationBarTitle(Text("Health Arrange"))
            .navigationBarItems(trailing:
                                    Button(action : calculateBedTime){
                                        Text("Calculate")
                                    })
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMsg), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func calculateBedTime(){
        
        let components = Calendar.current.dateComponents([.hour , .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 3600
        let minute = (components.minute ?? 0) * 60
        
        do {
            let model = SleepCalculator()
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: Double(sleepAmount), coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            alertMsg = formatter.string(from: sleepTime)
            alertTitle = "Your ideal bedTime is ..."
            
        }
        catch {
            alertTitle = "Error"
            alertMsg = "Sorry, there was a problem calculating your bed time !!"
            
        }
        
        showingAlert = true
        
    }
}


struct SettingsSwiftUI_Previews: PreviewProvider {
    static var previews: some View {
        Group {
           SettingsSwiftUI()
              .environment(\.colorScheme, .dark)

           SettingsSwiftUI()
              .environment(\.colorScheme, .light)
        }
    }
}
