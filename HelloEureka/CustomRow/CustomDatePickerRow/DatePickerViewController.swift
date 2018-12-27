//
//  DatePickerViewController.swift
//  HelloEureka
//
//  Created by Jay on 12/14/18.
//  Copyright © 2018 Jay. All rights reserved.
//

import UIKit

open class DatePickerViewController: FormViewController, TypedRowControllerType  {
    public var datePickerMode: UIDatePicker.Mode = .date
    public var titleText: String =  ""
    public var detailText: String =  ""
    private var selectedDate: Date?
    
    /// The row that pushed or presented this controller
    public var row: RowOf<Date>!
    
    /// A closure to be called when the controller disappears.
    public var onDismissCallback : ((UIViewController) -> ())?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
     
        tableView.alwaysBounceVertical = false
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
        
        self.selectedDate = row.value
        
        form +++
  
            Section() {
                $0.header = HeaderFooterView<UIView>(HeaderFooterProvider.class)
                $0.header?.height = { CGFloat.leastNormalMagnitude }
            }
      
            <<< CustomDatePickerRow() {
                $0.cellProvider = CellProvider<CustomDatePickerCell>(nibName: "CustomDatePickerCell", bundle: Bundle.main)
                $0.datePickerMode = self.datePickerMode
                $0.value = row.value
                $0.title = titleText
                $0.detailText = detailText
                $0.cell.cancelButton.addTarget(self, action: #selector(cancelButtonAction(_:)), for: .touchUpInside)
                $0.cell.doneButton.addTarget(self, action: #selector(doneButtonAction(_:)), for: .touchUpInside)
              }
                .onChange {  row in
                    self.selectedDate = row.value
        }
    }

    @objc func cancelButtonAction(_ sender: AnyObject) {
        self.onDismissCallback?(self)
    }
    
    @objc func doneButtonAction(_ sender: AnyObject) {
        self.row.value = selectedDate
        self.onDismissCallback?(self)
    }
}

