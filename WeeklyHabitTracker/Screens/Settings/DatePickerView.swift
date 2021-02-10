//
//  DatePickerView.swift
//  BetterRest
//
//  Created by SHUBHAM DHINGRA on 11/20/20.
//

import SwiftUI

struct DatePickerView: View {
    @State private var wakeUp = Date()
    var body: some View {
        
//        DatePicker("Select Date ", selection: $wakeUp ,  in: Date()...).labelsHidden()
        
//        let now = Date()
//        let tomorrow = Date().addingTimeInterval(86400)
//        let range = now...tomorrow
        DatePicker("Please select a date",selection: $wakeUp, displayedComponents : .hourAndMinute).labelsHidden()
    }
}

struct DatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerView()
    }
}
