//
//  CustomDatePickerRow.swift
//  HelloEureka
//
//  Created by Jay on 12/23/18.
//  Copyright © 2018 Jay. All rights reserved.
//

import UIKit

public protocol CustomDatePickerRowProtocol: class {
    var minimumDate: Date? { get set }
    var maximumDate: Date? { get set }
    var minuteInterval: Int? { get set }
    var datePickerMode: UIDatePicker.Mode? { get set }
    var detailText: String? { get set }
}

open class CustomDatePickerCell: Cell<Date>, CellType {
    @IBOutlet weak public var datePicker: UIDatePicker!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var detailLabel: UILabel!
    @IBOutlet public weak var cancelButton: UIButton!
    @IBOutlet public weak var doneButton: UIButton!
    
    public required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        let datePicker = UIDatePicker()
        self.datePicker = datePicker
        self.datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.datePicker)
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[picker]-0-|", options: [], metrics: nil, views: ["picker": self.datePicker]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[picker]-0-|", options: [], metrics: nil, views: ["picker": self.datePicker]))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func setup() {
        super.setup()
        selectionStyle = .none
        accessoryType = .none
        editingAccessoryType =  .none
        height = { UITableView.automaticDimension }
        datePicker.datePickerMode = (row as? CustomDatePickerRowProtocol)?.datePickerMode ?? .date
        datePicker.addTarget(self, action: #selector(DatePickerCell.datePickerValueChanged(_:)), for: .valueChanged)
        self.cancelButton.layer.borderWidth = 1.0
        self.cancelButton.layer.borderColor = UIColor.lightGray.cgColor
        self.doneButton.layer.borderWidth = 1.0
        self.doneButton.layer.borderColor = UIColor.lightGray.cgColor
        
        self.titleLabel.text = row.title ?? ""
        self.detailLabel.text = (row as? CustomDatePickerRowProtocol)?.detailText ?? ""
        
    }
    
    deinit {
        datePicker?.removeTarget(self, action: nil, for: .allEvents)
    }
    
    open override func update() {
        super.update()
        selectionStyle = row.isDisabled ? .none : .default
        datePicker.isUserInteractionEnabled = !row.isDisabled
        detailTextLabel?.text = nil
        textLabel?.text = nil
        datePicker.setDate(row.value ?? Date(), animated: row is CountDownPickerRow)
        datePicker.minimumDate = (row as? CustomDatePickerRowProtocol)?.minimumDate
        datePicker.maximumDate = (row as? CustomDatePickerRowProtocol)?.maximumDate
        if let minuteIntervalValue = (row as? CustomDatePickerRowProtocol)?.minuteInterval {
            datePicker.minuteInterval = minuteIntervalValue
        }
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        row?.value = sender.date
        
        // workaround for UIDatePicker bug when it doesn't trigger "value changed" event after trying to pick 00:00 value
        // for details see this comment: https://stackoverflow.com/questions/20181980/uidatepicker-bug-uicontroleventvaluechanged-after-hitting-minimum-internal#comment56681891_20204225
        if sender.datePickerMode == .countDownTimer && sender.countDownDuration == TimeInterval(sender.minuteInterval * 60) {
            datePicker.countDownDuration = sender.countDownDuration
        }
        
    }
}

open class _CustomDatePickerRow: Row<CustomDatePickerCell>, CustomDatePickerRowProtocol {
    open var minimumDate: Date?
    open var maximumDate: Date?
    open var minuteInterval: Int?
    open var datePickerMode: UIDatePicker.Mode?
    open var detailText: String?
    
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
    }
}

/// A row with an Date as value where the user can select a date directly.
public final class CustomDatePickerRow: _CustomDatePickerRow, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
    }
}


