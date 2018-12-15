//
//  CustomSwitchCell.swift
//  HelloEureka
//
//  Created by Jay on 12/14/18.
//  Copyright © 2018 Jay. All rights reserved.
//

import Foundation
import UIKit

// MARK: SwitchCell

open class CustomSwitchCell: Cell<Bool>, CellType {
    
    @IBOutlet public weak var switchControl: UISwitch!
    @IBOutlet public weak var switchLabel: UILabel!
    @IBOutlet public weak var detailSwitchLabel: UILabel!

    
    required public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let switchC = UISwitch()
        switchControl = switchC
        accessoryView = switchControl
        editingAccessoryView = accessoryView
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func setup() {
        super.setup()
        selectionStyle = .none
        switchControl.addTarget(self, action: #selector(SwitchCell.valueChanged), for: .valueChanged)
    }
    
    deinit {
        switchControl?.removeTarget(self, action: nil, for: .allEvents)
    }
    
    open override func update() {
        super.update()
        switchControl.isOn = row.value ?? false
        switchControl.isEnabled = !row.isDisabled
    }
    
    @objc func valueChanged() {
        row.value = switchControl?.isOn ?? false
    }
}

// MARK: CustomSwitchRow

open class _CustomSwitchRow: Row<CustomSwitchCell> {
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
    }
}

/// Boolean row that has a UISwitch as accessoryType
public final class CustomSwitchRow: _CustomSwitchRow, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}
