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
            
            Section("Custom Switch")
            
            <<< CustomSwitchRow() {
                $0.cellProvider = CellProvider<CustomSwitchCell>(nibName: "CustomSwitchCell", bundle: Bundle.main)
                $0.cell.height = { 67 }
                $0.cell.switchLabel?.text = "Alarm"
                $0.cell.detailSwitchLabel?.text = "Alarm Off"
                }.onChange { row in
                    row.cell.detailSwitchLabel?.text = (row.value ?? false) ? "Alarm On" : "Alarm Off"
                    row.updateCell()
                }.cellSetup { cell, row in
                    cell.backgroundColor = .lightGray
                }.cellUpdate { cell, row in
                    cell.textLabel?.font = .italicSystemFont(ofSize: 18.0)
            }
            
            +++ Section("Date Picker")
            
            <<< CustomSelectRow() {
                $0.title = "Date Picker"
                $0.value =  "Select a Value"
                }.onChange { row in
                    row.updateCell()
                }.cellUpdate {
                    cell, row in
                    cell.textLabel?.font = .italicSystemFont(ofSize: 18.0)
        }
    }
}
