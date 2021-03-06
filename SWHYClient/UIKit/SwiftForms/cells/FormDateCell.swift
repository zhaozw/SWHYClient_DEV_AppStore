//
//  FormDateCell.swift
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 22/08/14.
//  Copyright (c) 2016 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

public class FormDateCell: FormValueCell {
    
    // MARK: Properties
    
    private let datePicker = UIDatePicker()
    private let hiddenTextField = UITextField(frame: CGRectZero)
    
    private let defaultDateFormatter = NSDateFormatter()
    
    // MARK: FormBaseCell
    
    public override func configure() {
        super.configure()
        contentView.addSubview(hiddenTextField)
        hiddenTextField.inputView = datePicker
        datePicker.datePickerMode = .Date
        datePicker.addTarget(self, action: #selector(FormDateCell.valueChanged(_:)), forControlEvents: .ValueChanged)
    }
    
    public override func update() {
        super.update()
        
        if let showsInputToolbar = rowDescriptor?.configuration.cell.showsInputToolbar where showsInputToolbar && hiddenTextField.inputAccessoryView == nil {
            hiddenTextField.inputAccessoryView = inputAccesoryView()
        }
        
        titleLabel.text = rowDescriptor?.title
        
        if let rowType = rowDescriptor?.type {
            switch rowType {
            case .Date:
                datePicker.datePickerMode = .Date
                defaultDateFormatter.dateStyle = .LongStyle
                defaultDateFormatter.timeStyle = .NoStyle
            case .Time:
                datePicker.datePickerMode = .Time
                defaultDateFormatter.dateStyle = .NoStyle
                defaultDateFormatter.timeStyle = .ShortStyle
            default:
                datePicker.datePickerMode = .DateAndTime
                defaultDateFormatter.dateStyle = .LongStyle
                defaultDateFormatter.timeStyle = .ShortStyle
            }
        }
        
        if let date = rowDescriptor?.value as? NSDate {
            datePicker.date = date
            valueLabel.text = getDateFormatter().stringFromDate(date)
        }
    }
    
    public override class func formViewController(formViewController: FormViewController, didSelectRow selectedRow: FormBaseCell) {
        guard let row = selectedRow as? FormDateCell else { return }
        
        if row.rowDescriptor?.value == nil {
            let date = NSDate()
            row.rowDescriptor?.value = date
            row.valueLabel.text = row.getDateFormatter().stringFromDate(date)
            row.update()
        }
        
        row.hiddenTextField.becomeFirstResponder()
    }
    
    public override func firstResponderElement() -> UIResponder? {
        return hiddenTextField
    }
    
    public override class func formRowCanBecomeFirstResponder() -> Bool {
        return true
    }
    
    // MARK: Actions
    
    internal func valueChanged(sender: UIDatePicker) {
        rowDescriptor?.value = sender.date
        valueLabel.text = getDateFormatter().stringFromDate(sender.date)
        update()
    }
    
    // MARK: Private interface
    
    private func getDateFormatter() -> NSDateFormatter {
        guard let dateFormatter = rowDescriptor?.configuration.date.dateFormatter else { return defaultDateFormatter }
        return dateFormatter
    }
}
