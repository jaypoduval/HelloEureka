//
//  CustomSelectorRow.swift
//  HelloEureka
//
//  Created by Jay on 12/23/18.
//  Copyright © 2018 Jay. All rights reserved.
//

import UIKit

public final class CustomSelectorRow: OptionsRow<PushSelectorCell<Date>>, PresenterRowType, RowType  {
    
    public var datePickerMode: UIDatePicker.Mode = .date
    public var titleText: String =  ""
    public var detailText: String =  ""
    
    public typealias PresenterRow = DatePickerViewController
    
    /// Defines how the view controller will be presented, pushed, etc.
    public var presentationMode: PresentationMode<PresenterRow>?
    
    /// Will be called before the presentation occurs.
    public var onPresentCallback: ((FormViewController, PresenterRow) -> Void)?
    
    var customModalTransitioningDelegate: CustomModalTransitioningDelegate?
    
    public required init(tag: String?) {
        
        super.init(tag: tag)
        
        presentationMode = .presentModally(controllerProvider: ControllerProvider.callback { return DatePickerViewController() }, onDismiss: { [weak self] vc in
            self?.select()
            vc.dismiss(animated: true)
        })
    }
    
    public override func customUpdateCell() {
        super.customUpdateCell()
        cell.accessoryType = .none
        cell.editingAccessoryView = .none
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
}
