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
    func duangTableCellButtonsAction(indexPath: NSIndexPath, buttonIndex: NSInteger)
}

class DuangTableCellButtons: UITableViewCell
{
    var indexPath: NSIndexPath =  NSIndexPath(forRow: 0, inSection: 0)
    var buttonArray: [DuangTableDataSection.DuangTableDataRow]?
    var delegate: DuangTableCellButtonsProtocol?
    
//    var post: PFObject?
    var likeButton: UIButton?
//    var hasLikeButton = false
    
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
                case .ButtonItem(let buttonText, let buttonTextColor, let buttonBackgroundColor, let borderColor, let buttonImage, let tapAction):
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
                    buttonTitleLabel.textColor = buttonTextColor
                    buttonTitleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
                    let buttonTitleLabelX = buttonImageViewX + imageSize.width + imageAndTitleSpacing
                    let buttonTitleLabelY = (buttonRect.height - titleSize.height) / 2
                    buttonTitleLabel.frame = CGRectMake(buttonTitleLabelX, buttonTitleLabelY, titleSize.width, titleSize.height)
                    button.addSubview(buttonTitleLabel)
                    
                    button.backgroundColor = buttonBackgroundColor
                    button.layer.borderColor = borderColor.CGColor
                    button.layer.borderWidth = 2.0
                    button.layer.masksToBounds = true
                    button.layer.cornerRadius = 5.0
                    button.tag = index
                    button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                    
                    addSubview(button)
                    
//                    if hasLikeButton && index == 2 {
//                        likeButton = button
//                        if let thePost = post {
//                            APIManager.sharedInstance.hasLikedPost(thePost, hasLiked: { (hasLiked) -> () in
//                                if hasLiked {
//                                    self.likeButton?.backgroundColor = DuangColor.Red
//                                } else {
//                                    self.likeButton?.backgroundColor = DuangColor.White
//                                }
//                            })
//                        }
//                    }
                    
                default:
                    break
                }
            }
        }
    }
    
    func buttonAction(sender: UIButton) {
        delegate?.duangTableCellButtonsAction(indexPath, buttonIndex: sender.tag)
    }

}
