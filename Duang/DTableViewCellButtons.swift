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
    var delegate: DTableViewCellButtonsProtocol?
    var modelRow: DTableViewModelRow?
    
    var photo: PFObject?
    
    var buttonItemArray: [DTableViewModelRow.ButtonItem]?
    
    
    var buttons = [UIButton]()
    
    func reloadView() {
        for button in buttons {
            button.removeFromSuperview()
        }
        buttons = [UIButton]()
        
        if let theModelRow = modelRow {
            switch theModelRow.rowType {
            case .Buttons(let buttonItemArray):
                self.buttonItemArray = buttonItemArray
                
                let buttonWidth = (self.bounds.width - (DuangGlobal.spacing * CGFloat(buttonItemArray.count + 1))) / CGFloat(buttonItemArray.count)
                let buttonHeight = self.bounds.height - (DuangGlobal.spacing * 2)
                
                for var index = 0; index < buttonItemArray.count; ++index {
                    let buttonRect = CGRectMake((buttonWidth + DuangGlobal.spacing) * CGFloat(index) + DuangGlobal.spacing, DuangGlobal.spacing, buttonWidth, buttonHeight)
                    let button = UIButton(frame: buttonRect)
                    
                    button.setButton(buttonItemArray[index], buttonSize: buttonRect.size)
                    button.tag = index
                    button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                    addSubview(button)
                    
                    buttons.append(button)
                }
            case .ButtonsWaterfall(let photo):
                println("ButtonsWaterfall")
            default:
                break
            }
        }
        
//        if let theButtonItemArray = buttonItemArray {
//            
//            let buttonWidth = (self.bounds.width - (DuangGlobal.spacing * CGFloat(theButtonItemArray.count + 1))) / CGFloat(theButtonItemArray.count)
//            let buttonHeight = self.bounds.height - (DuangGlobal.spacing * 2)
//            
//            for var index = 0; index < theButtonItemArray.count; ++index {
//                let buttonRect = CGRectMake((buttonWidth + DuangGlobal.spacing) * CGFloat(index) + DuangGlobal.spacing, DuangGlobal.spacing, buttonWidth, buttonHeight)
//                let button = UIButton(frame: buttonRect)
//                
//                button.setButton(theButtonItemArray[index], buttonSize: buttonRect.size)
//                button.tag = index
//                button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
//                addSubview(button)
//                
//                buttons.append(button)
//            }
//        }
    }
    
    func buttonAction(sender: UIButton) {
        if let theButtonItemArray = buttonItemArray {
            if sender.tag < theButtonItemArray.count {
                delegate?.dTableViewCellButtonsAction(theButtonItemArray[sender.tag])
            }
        }
    }
}
