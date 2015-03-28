//
//  DuangTableCellTextField.swift
//  Duang
//
//  Created by David Yu on 15/3/19.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import UIKit

protocol DuangTableCellTextFieldProtocol
{
    func duangTableCellTextFieldReturn(duangTableCellTextField: DuangTableCellTextField)
}

class DuangTableCellTextField: UITableViewCell, UITextFieldDelegate
{
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
        }
    }
    
    var delegate: DuangTableCellTextFieldProtocol?
    var placeholder = ""
    
    func reloadView() {
        textField.placeholder = placeholder
    }
    
    /*
    var duangTableDataRow: DuangTableDataRow? {
        didSet {
            if let row = duangTableDataRow {
                if let text = row.getTextArray(0) {
                    textField.placeholder = text
                }
            }
        }
    }*/
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        delegate?.duangTableCellTextFieldReturn(self)
        return true
    }
}
