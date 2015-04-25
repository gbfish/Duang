//
//  DTableViewCellButtons.swift
//  Duang
//
//  Created by David Yu on 15/4/22.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import UIKit

protocol DTableViewCellButtonsProtocol
{
    func dTableViewCellButtonsAction(buttonItem: DTableViewModelRow.ButtonItem)
}

class DTableViewCellButtons: UITableViewCell
{
    var buttonItemArray: [DTableViewModelRow.ButtonItem]?
    var delegate: DTableViewCellButtonsProtocol?
    
    var buttons = [UIButton]()
    
    func reloadView() {
        for button in buttons {
            button.removeFromSuperview()
        }
        
        if let theButtonItemArray = buttonItemArray {
            
            let buttonWidth = (self.bounds.width - (DuangGlobal.spacing * CGFloat(theButtonItemArray.count + 1))) / CGFloat(theButtonItemArray.count)
            let buttonHeight = self.bounds.height - (DuangGlobal.spacing * 2)
            
            for var index = 0; index < theButtonItemArray.count; ++index {
                let buttonRect = CGRectMake((buttonWidth + DuangGlobal.spacing) * CGFloat(index) + DuangGlobal.spacing, DuangGlobal.spacing, buttonWidth, buttonHeight)
                let button = UIButton(frame: buttonRect)
                
                button.setButton(theButtonItemArray[index], buttonSize: buttonRect.size)
                button.tag = index
                button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                addSubview(button)
                
                buttons.append(button)
            }
        }
    }
    
    func buttonAction(sender: UIButton) {
        if let theButtonItemArray = buttonItemArray {
            if sender.tag < theButtonItemArray.count {
                delegate?.dTableViewCellButtonsAction(theButtonItemArray[sender.tag])
            }
        }
    }
}
