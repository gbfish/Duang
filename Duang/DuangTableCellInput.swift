//
//  DuangTableCellInput.swift
//  Duang
//
//  Created by David Yu on 15/3/18.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import UIKit

protocol DuangTableCellInputProtocol {
    func duangTableCellInputDoneAction()
}

class DuangTableCellInput: UITableViewCell, UITextViewDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        inputTextView.delegate = self
    }

    var delegate: DuangTableCellInputProtocol?

    @IBOutlet weak var inputTextView: UITextView!
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            delegate?.duangTableCellInputDoneAction()
            return false
        } else {
            return true
        }
    }
}
