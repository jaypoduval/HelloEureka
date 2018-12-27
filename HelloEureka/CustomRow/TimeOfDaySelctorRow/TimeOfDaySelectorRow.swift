//
//  TimeOfDaySelectorSelectorRow.swift
//  HelloEureka
//
//  Created by Jay on 12/26/18.
//  Copyright © 2018 Jay. All rights reserved.
//

import UIKit

public class TimeOfDaySelectorCell : Cell<Date>, CellType {
    
    @IBOutlet var titleLabel: UILabel!
  
    var selectedButton: UIButton?
    
    open override func setup() {
        height = { 60 }
        titleLabel.text = row.title
        row.title = nil
        super.setup()
        selectionStyle = .none
    }
    
    open override func update() {
        row.title = nil
        super.update()
        let value = row.value
        print("value \(String(describing: value))")
    }
    
    @IBAction func dayTapped(_ sender: UIButton) {
        selectedButton = sender
        row.value = Date()
        row.didSelect()
    }
}

public final class TimeOfDaySelectorRow: Row<TimeOfDaySelectorCell>, RowType {
    
    public var datePickerMode: UIDatePicker.Mode = .time
    public var titleText: String =  ""
    public var detailText: String =  ""
    public var selectedButtonTag: Int =  0
    
    public typealias PresenterRow = DatePickerViewController
    
    /// Defines how the view controller will be presented, pushed, etc.
    public var presentationMode: PresentationMode<PresenterRow>?
    
    /// Will be called before the presentation occurs.
    public var onPresentCallback: ((FormViewController, PresenterRow) -> Void)?
    
    var customModalTransitioningDelegate: CustomModalTransitioningDelegate?
    
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
        cellProvider = CellProvider<TimeOfDaySelectorCell>(nibName: "TimeOfDaySelectorCell")
        
        presentationMode = .presentModally(controllerProvider: ControllerProvider.callback { return DatePickerViewController() }, onDismiss: { [weak self] vc in
            self?.select()
            
            if let text = self?.formattedDate(self?.cell.row.value, datePickerMode: .time), let button =  self?.cell.selectedButton {
                button.setTitle(text, for: .normal)
            }
            vc.dismiss(animated: true)
        })
    }
    
    /// Extends `didSelect` method
    public override func customDidSelect() {
        super.customDidSelect()
        if let presentationMode = presentationMode, !isDisabled {
            if let controller = presentationMode.makeController(){
                controller.row = self
                onPresentCallback?(cell.formViewController()!, controller)
                
                self.customModalTransitioningDelegate = CustomModalTransitioningDelegate(viewController: controller, presentingViewController: cell.formViewController()! )
                
                controller.datePickerMode = self.datePickerMode
                controller.titleText = self.titleText
                controller.detailText = self.detailText
                controller.modalPresentationStyle = .custom
                controller.transitioningDelegate = self.customModalTransitioningDelegate
                presentationMode.present(controller, row: self, presentingController: cell.formViewController()!)
            }
            else{
                presentationMode.present(nil, row: self, presentingController: cell.formViewController()!)
            }
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
