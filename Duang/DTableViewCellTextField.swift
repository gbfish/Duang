//
//  DTableViewCellTextField.swift
//  Duang
//
//  Created by David Yu on 15/4/22.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import UIKit

class DTableViewCellTextField: UITableViewCell
{
    var cellTitle: String?
    var cellTitleWidth: CGFloat?
    
    var cellText: String?
    
    var cellTitleLabel = UILabel()
    var cellTextField = UITextField()
    
    func reloadView() {
        let spacing: CGFloat = 5.0
        let itemHeight = self.bounds.height - (spacing * 2)
        var textFieldX = spacing
        
        cellTitleLabel.removeFromSuperview()
        cellTextField.removeFromSuperview()
        
        if let theCellTitle = cellTitle, theCellTitleWidth = cellTitleWidth {
            cellTitleLabel.frame = CGRectMake(spacing, spacing, theCellTitleWidth, itemHeight)
            cellTitleLabel.text = cellTitle
            addSubview(cellTitleLabel)
            
            textFieldX = textFieldX + theCellTitleWidth + spacing
        }
        
        cellTextField.frame = CGRectMake(textFieldX, spacing, self.bounds.width - textFieldX - spacing, itemHeight)
        cellTextField.borderStyle = UITextBorderStyle.RoundedRect
        if let theCellText = cellText {
            cellTextField.text = theCellText
        }
        addSubview(cellTextField)
    }
}
