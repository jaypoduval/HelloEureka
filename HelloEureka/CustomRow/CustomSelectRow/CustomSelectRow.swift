//
//  CustomSelectRow.swift
//  HelloEureka
//
//  Created by Jay on 12/14/18.
//  Copyright © 2018 Jay. All rights reserved.
//

import UIKit

open class _CustomSelectRow<Cell: CellType>: OptionsRow<Cell>, PresenterRowType where Cell: BaseCell, Cell.Value == String {
 
    public typealias PresenterRow = DatePickerViewController
    
    /// Defines how the view controller will be presented, pushed, etc.
    open var presentationMode: PresentationMode<PresenterRow>?
    
    /// Will be called before the presentation occurs.
    open var onPresentCallback: ((FormViewController, PresenterRow) -> Void)?
    
    var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?
    
    public required init(tag: String?) {
        
        super.init(tag: tag)
   
        presentationMode =   .segueName(segueName: "CustomSegue", onDismiss: { [weak self] vc in
            self?.select()
            vc.dismiss(animated: true)
        })
        
        self.displayValueFor = nil
    }
    
    /// Extends `didSelect` method
    open override func customDidSelect() {
        guard !isDisabled else {
            super.customDidSelect()
            return
        }
        deselect()
        if let presentationMode = presentationMode, !isDisabled {
            if let controller = presentationMode.makeController(){
                controller.row = self
                onPresentCallback?(cell.formViewController()!, controller)
                presentationMode.present(controller, row: self, presentingController: cell.formViewController()!)
            }
            else{
                presentationMode.present(nil, row: self, presentingController: cell.formViewController()!)
            }
        }
    }
    
    /**
     Prepares the pushed row setting its title and completion callback.
     */
    open override func prepare(for segue: UIStoryboardSegue) {
        super.prepare(for: segue)
        
        guard let  navigationController = segue.destination as? UINavigationController  else { return }
        
        guard let rowVC = navigationController.topViewController as? PresenterRow else { return }
        rowVC.title = selectorTitle ?? rowVC.title
        rowVC.onDismissCallback = presentationMode?.onDismissCallback ?? rowVC.onDismissCallback
        onPresentCallback?(cell.formViewController()!, rowVC)
        rowVC.row = self
        
        self.halfModalTransitioningDelegate = HalfModalTransitioningDelegate(viewController: cell.formViewController()!, presentingViewController: segue.destination)
        
        segue.destination.modalPresentationStyle = .custom
        segue.destination.transitioningDelegate = self.halfModalTransitioningDelegate
    }
    
    open override func customUpdateCell() {
        super.customUpdateCell()
        
        cell.accessoryType = .none
        cell.editingAccessoryView = .none
        
        if let text = self.value {
            cell.textLabel?.text = text
        } else {
            cell.textLabel?.text = ""
        }
    }
}

/// A selector row where the user can pick an image
public final class CustomSelectRow : _CustomSelectRow<PushSelectorCell<String>>, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
    }
}

