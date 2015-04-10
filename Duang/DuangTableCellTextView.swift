//
//  DuangTableCellTextView.swift
//  Duang
//
//  Created by David Yu on 15/3/27.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import UIKit

protocol DuangTableCellTextViewProtocol
{
    func duangTableCellTextViewDoneAction()
}

class DuangTableCellTextView: UITableViewCell, UITextViewDelegate
{
    var delegate: DuangTableCellTextViewProtocol?
    
    var placeholder: String?
    func reloadView() {
        textView.text = placeholder
    }
    
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.delegate = self
        }
    }
    
    // MARK: - UITextViewDelegate
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            delegate?.duangTableCellTextViewDoneAction()
            return false
        } else {
            return true
        }
    }
}
