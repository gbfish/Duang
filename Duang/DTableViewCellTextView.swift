//
//  DTableViewCellTextView.swift
//  Duang
//
//  Created by David Yu on 15/4/24.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import UIKit

protocol DTableViewCellTextViewProtocol
{
    func dTableViewCellTextViewCellHeight(dTableViewCellTextView: DTableViewCellTextView, newHeightForRow: CGFloat)
    
}

class DTableViewCellTextView: UITableViewCell, UITextViewDelegate
{
    var delegate: DTableViewCellTextViewProtocol?
    
    var textViewTitle: String?
    var textViewTitleWidth: CGFloat?
    
    var textViewText: String?
    
    var cellTitleLabel = UILabel()
    var cellTextView = UITextView()
    
    let spacing: CGFloat = 5.0
    let itemHeight: CGFloat = 40.0
    
    func reloadView() {
        
        var textViewX = spacing
        
        cellTitleLabel.removeFromSuperview()
        cellTextView.removeFromSuperview()
        
        if let theTextViewTitle = textViewTitle, theTextViewTitleWidth = textViewTitleWidth {
            cellTitleLabel = UILabel()
            cellTitleLabel.frame = CGRectMake(spacing, spacing, theTextViewTitleWidth, itemHeight)
            cellTitleLabel.text = theTextViewTitle
            addSubview(cellTitleLabel)
            
            textViewX = textViewX + theTextViewTitleWidth + spacing
        }
        
        cellTextView = UITextView()
        cellTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
        cellTextView.layer.borderWidth = 1.0
        cellTextView.layer.masksToBounds = true
        cellTextView.layer.cornerRadius = 5.0
        cellTextView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        
        cellTextView.delegate = self
        cellTextView.frame = CGRectMake(textViewX, spacing, self.bounds.width - textViewX - spacing, itemHeight)
        
        if let theTextViewText = textViewText {
            cellTextView.text = theTextViewText
        }
        addSubview(cellTextView)
    }
    
    // MARK: - UITextViewDelegate
    
    var textViewHeight: CGFloat = 40.0 {
        didSet {
            if textViewHeight != oldValue {
                println("value change!")
                
                delegate?.dTableViewCellTextViewCellHeight(self, newHeightForRow: textViewHeight + (spacing * 2))
            }
        }
    }
    
    func textViewDidChangeSelection(textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSizeMake(fixedWidth, CGFloat.max))
        var newFrame = textView.frame
        
        if newSize.height < 40.0 {
            textViewHeight = 40.0
        } else {
            textViewHeight = newSize.height
        }
        
        
        println("newSize.height = \(newSize.height) - textViewHeight = \(textViewHeight)")
        
        newFrame.size = CGSizeMake(fixedWidth, textViewHeight)
        textView.frame = newFrame
    }
    
//    func textFieldDidBeginEditing(textField: UITextField) {
//        delegate?.dTableViewCellTextFieldDidBeginEditing(self)
//    }
//    
//    func textFieldDidEndEditing(textField: UITextField) {
//        delegate?.dTableViewCellTextFieldDidEndEditing(self)
//    }
//    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }

}
