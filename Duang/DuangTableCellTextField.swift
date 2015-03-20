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
    var delegate: DuangTableCellTextFieldProtocol?

    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        delegate?.duangTableCellTextFieldReturn(self)
        return true
    }
}