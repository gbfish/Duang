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
    func dTableViewCellTextViewDidBeginEditing(dTableViewCellTextView: DTableViewCellTextView)
    func dTableViewCellTextViewDidEndEditing(dTableViewCellTextView: DTableViewCellTextView)
}

class DTableViewCellTextView: UITableViewCell, UITextViewDelegate
{
    var delegate: DTableViewCellTextViewProtocol?
    
    var textViewTitle: String?
    var textViewTitleWidth: CGFloat?
    
    var textViewText: String?
    
    var cellTitleLabel = UILabel()
    var cellTextView = UITextView()
    

    let itemHeight: CGFloat = 40.0
    
    func reloadView() {
        
        var textViewX = DuangGlobal.spacing
        
        cellTitleLabel.removeFromSuperview()
        cellTextView.removeFromSuperview()
        
        if let theTextViewTitle = textViewTitle, theTextViewTitleWidth = textViewTitleWidth {
            cellTitleLabel = UILabel()
            cellTitleLabel.frame = CGRectMake(DuangGlobal.spacing, DuangGlobal.spacing, theTextViewTitleWidth, itemHeight)
            cellTitleLabel.text = theTextViewTitle
            addSubview(cellTitleLabel)
            
            textViewX = textViewX + theTextViewTitleWidth + DuangGlobal.spacing
        }
        
        cellTextView = UITextView()
        cellTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
        cellTextView.layer.borderWidth = 1.0
        cellTextView.layer.masksToBounds = true
        cellTextView.layer.cornerRadius = 5.0
        cellTextView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        
        cellTextView.delegate = self
        cellTextView.frame = CGRectMake(textViewX, DuangGlobal.spacing, self.bounds.width - textViewX - DuangGlobal.spacing, itemHeight)
        
        if let theTextViewText = textViewText {
            cellTextView.text = theTextViewText
        }
        addSubview(cellTextView)
        textViewDidChangeSelection(cellTextView)
    }
    
    // MARK: - UITextViewDelegate
    
    var textViewHeight: CGFloat = 40.0 {
        didSet {
            if textViewHeight != oldValue {
                delegate?.dTableViewCellTextViewCellHeight(self, newHeightForRow: textViewHeight + (DuangGlobal.spacing * 2))
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
        newFrame.size = CGSizeMake(fixedWidth, textViewHeight)
        textView.frame = newFrame
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        delegate?.dTableViewCellTextViewDidBeginEditing(self)
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        delegate?.dTableViewCellTextViewDidEndEditing(self)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        } else {
            return true
        }
    }
}
