//
//  MainViewController.swift
//  HelloEureka
//
//  Created by Jay on 12/14/18.
//  Copyright © 2018 Jay. All rights reserved.
//

import UIKit

class MainViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++
            
            Section("Date Picker")
            
            <<< CustomSelectorRow() {
                $0.title = "Date Picker"
                $0.value = nil
                $0.titleText = "Date Picker"
                $0.detailText = "Date Picker Detail"
                $0.datePickerMode = .date
                }.onChange { row in
                    row.updateCell()
                }.cellUpdate {
                    cell, row in
                    cell.detailTextLabel?.text = self.formattedDate(row.value, datePickerMode:.date)
            }

            <<< CustomSelectorRow() {
                $0.title  = "Time Picker"
                $0.titleText = "Time Picker"
                $0.detailText = "Time Picker Detail"
                $0.value =  nil
                $0.datePickerMode = .time
                }.onChange { row in
                    row.updateCell()
                }.cellUpdate {
                    cell, row in
                    cell.detailTextLabel?.text = self.formattedDate(row.value, datePickerMode:.time)
            }
            
            <<< CustomSelectorRow() {
                $0.title  = "Date & Time Picker"
                $0.titleText = "Date & Time Picker"
                $0.detailText = "Date & Time  Picker Detail"
                $0.value = nil
                $0.datePickerMode = .dateAndTime
                }.onChange { row in
                    row.updateCell()
                }.cellUpdate {
                    cell, row in
                    cell.detailTextLabel?.text = self.formattedDate(row.value, datePickerMode:.dateAndTime)
        }
    }
    
    func formattedDate(_ selectedDate: Date?, datePickerMode: UIDatePicker.Mode) -> String {
        
        guard let date = selectedDate else { return "" }
    
        let dateFormatter = DateFormatter()
        
        switch datePickerMode {
        case .time:
            dateFormatter.dateFormat = "h:mm a"
        case .dateAndTime:
            dateFormatter.dateFormat = "yyyy-MM-dd h:mm a"
        default:
            dateFormatter.dateFormat = "yyyy-MM-dd"
        }
        let dateText = dateFormatter.string(from: date)
       
        return dateText
    }
}
