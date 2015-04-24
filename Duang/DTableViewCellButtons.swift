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
            let spacing: CGFloat = 5.0
            let buttonWidth = (self.bounds.width - (spacing * CGFloat(theButtonItemArray.count + 1))) / CGFloat(theButtonItemArray.count)
            let buttonHeight = self.bounds.height - (spacing * 2)
            
            for var index = 0; index < theButtonItemArray.count; ++index {
                let buttonRect = CGRectMake((buttonWidth + spacing) * CGFloat(index) + spacing, spacing, buttonWidth, buttonHeight)
                let button = UIButton(frame: buttonRect)
                
                switch theButtonItemArray[index] {
                case .ButtonItemTitleImage(let style, let buttonText, let buttonImage, _):
                    let imageAndTitleSpacing: CGFloat = 6.0
                    let imageSize = CGSizeMake(20.0, 20.0)
                    let titleSize = APIManager.sizeForString(buttonText, font: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline), width: CGFloat.max, height: CGFloat.max)
                    
                    let buttonImageView = UIImageView()
                    buttonImageView.image = buttonImage
                    let buttonImageViewX = (buttonRect.width - (imageSize.width + imageAndTitleSpacing + titleSize.width)) / 2
                    let buttonImageViewY = (buttonRect.height - imageSize.height) / 2
                    buttonImageView.frame = CGRectMake(buttonImageViewX, buttonImageViewY, imageSize.width, imageSize.height)
                    button.addSubview(buttonImageView)
                    
                    let buttonTitleLabel = UILabel()
                    buttonTitleLabel.text = buttonText
                    buttonTitleLabel.textColor = style.buttonTextColor()
                    buttonTitleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
                    let buttonTitleLabelX = buttonImageViewX + imageSize.width + imageAndTitleSpacing
                    let buttonTitleLabelY = (buttonRect.height - titleSize.height) / 2
                    buttonTitleLabel.frame = CGRectMake(buttonTitleLabelX, buttonTitleLabelY, titleSize.width, titleSize.height)
                    button.addSubview(buttonTitleLabel)
                    
                    button.backgroundColor = style.buttonBackgroundColor()
                    button.layer.borderColor = style.borderColor()
                    button.layer.borderWidth = 1.0
                    button.layer.masksToBounds = true
                    button.layer.cornerRadius = 5.0
                    button.tag = index
                    button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                    
                    addSubview(button)
                    
                case .ButtonItemTitle(let style, let buttonText, _):
                    let titleSize = APIManager.sizeForString(buttonText, font: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline), width: CGFloat.max, height: CGFloat.max)
                    
                    let buttonTitleLabel = UILabel()
                    buttonTitleLabel.text = buttonText
                    buttonTitleLabel.textColor = style.buttonTextColor()
                    buttonTitleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
                    let buttonTitleLabelX = (buttonRect.width - titleSize.width) / 2
                    let buttonTitleLabelY = (buttonRect.height - titleSize.height) / 2
                    buttonTitleLabel.frame = CGRectMake(buttonTitleLabelX, buttonTitleLabelY, titleSize.width, titleSize.height)
                    button.addSubview(buttonTitleLabel)
                    
                    button.backgroundColor = style.buttonBackgroundColor()
                    button.layer.borderColor = style.borderColor()
                    button.layer.borderWidth = 1.0
                    button.layer.masksToBounds = true
                    button.layer.cornerRadius = 5.0
                    button.tag = index
                    button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                    
                    addSubview(button)
                    
                default:
                    break
                }
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