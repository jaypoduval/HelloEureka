//
//  DatePickerViewController.swift
//  HelloEureka
//
//  Created by Jay on 12/14/18.
//  Copyright © 2018 Jay. All rights reserved.
//

import UIKit

open class DatePickerViewController: FormViewController, TypedRowControllerType  {
    
    /// The row that pushed or presented this controller
    public var row: RowOf<String>!
    
    /// A closure to be called when the controller disappears.
    public var onDismissCallback : ((UIViewController) -> ())?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++
            
            Section()
            
            <<< ButtonRow(){
                $0.title = "Change Value from child view controller"
                }
                .onCellSelection { (cell, row) in
                    self.row.value =  "Value Changed"
                    self.onDismissCallback?(self)
        }
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}

