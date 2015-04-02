//
//  DuangTableCellButtons.swift
//  Duang
//
//  Created by David Yu on 15/4/1.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import UIKit

protocol DuangTableCellButtonsProtocol
{
    func duangTableCellButtonsAction(index: NSInteger, buttonIndex: NSInteger)
}

class DuangTableCellButtons: UITableViewCell
{
    var index: NSInteger = 0
    var buttonArray: [DuangTableDataSection.DuangTableDataRow]?
    var delegate: DuangTableCellButtonsProtocol?
    
    func reloadView() {
        if let theButtonArray = buttonArray {
            println("theButtonArray = \(theButtonArray.count)")
            
            let spacing: CGFloat = 8.0
            let buttonWidth = (DuangGlobal.screenWidth - (spacing * CGFloat(theButtonArray.count + 1))) / CGFloat(theButtonArray.count)
            let buttonHeight = self.bounds.height - (spacing * 2)
            
            for var index = 0; index < theButtonArray.count; ++index {
                let buttonRect = CGRectMake((buttonWidth + spacing) * CGFloat(index) + spacing, spacing, buttonWidth, buttonHeight)
                let button = UIButton(frame: buttonRect)
                
                switch theButtonArray[index] {
                case .ButtonItem(let buttonText, let buttonTextColor, let buttonBackgroundColor, let buttonImage, let tapAction):
                    
                    let imageAndTitleSpacing: CGFloat = 6.0
                    let imageSize = CGSizeMake(30.0, 30.0)
                    let titleSize = APIManager.sizeForString(buttonText, font: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline), width: CGFloat.max, height: CGFloat.max)
                    
                    let buttonImageView = UIImageView()
                    buttonImageView.image = buttonImage
                    let buttonImageViewX = (buttonRect.width - (imageSize.width + imageAndTitleSpacing + titleSize.width)) / 2
                    let buttonImageViewY = (buttonRect.height - imageSize.height) / 2
                    buttonImageView.frame = CGRectMake(buttonImageViewX, buttonImageViewY, imageSize.width, imageSize.height)
                    button.addSubview(buttonImageView)
                    
                    let buttonTitleLabel = UILabel()
                    buttonTitleLabel.text = buttonText
                    buttonTitleLabel.textColor = buttonTextColor
                    buttonTitleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
                    let buttonTitleLabelX = buttonImageViewX + imageSize.width + imageAndTitleSpacing
                    let buttonTitleLabelY = (buttonRect.height - titleSize.height) / 2
                    buttonTitleLabel.frame = CGRectMake(buttonTitleLabelX, buttonTitleLabelY, titleSize.width, titleSize.height)
                    button.addSubview(buttonTitleLabel)
                    
                    
                    
//                    button.setImage(buttonImage, forState: UIControlState.Normal)
                    
//                    button.imageEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + spacing), 0.0)
//                    
//                    button.imageView?.frame.size = imageSize
//                    button.imageView?.clipsToBounds = true
//                    
//                    
//                    let titleSize = APIManager.sizeForString(buttonText, font: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline), width: CGFloat.max, height: CGFloat.max)
//                    button.setTitle(buttonText, forState: UIControlState.Normal)
//                    button.titleEdgeInsets = UIEdgeInsetsMake( -(titleSize.height + spacing), 0.0, 0.0, -titleSize.width)
                    
//                    button.setTitleColor(buttonTextColor, forState: UIControlState.Normal)
                    button.backgroundColor = buttonBackgroundColor
                    button.tag = index
                    button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                    
                    addSubview(button)
                    
                default:
                    break
                }
                
                
                
            }
        }
    }
    
    func buttonAction(sender: UIButton) {
        delegate?.duangTableCellButtonsAction(index, buttonIndex: sender.tag)
    }

}
