//
//  Extension.swift
//  Duang
//
//  Created by David Yu on 15/3/11.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func setNavigationBarStyle() {
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        navigationController?.navigationBar.barTintColor = DuangColor.NavigationBackground
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: DuangColor.Navigation]
    }
}

extension UIButton {
    func setButton(buttonItem: DTableViewModelRow.ButtonItem, buttonSize: CGSize) {
        let subViews = self.subviews
        for subView in subViews {
            subView.removeFromSuperview()
        }
        
        
        var buttonStytle = DTableViewModelRow.ButtonItem.ButtonItemStyle.Normal
        
        switch buttonItem {
        case .ButtonItemTitle(let style, let buttonText, _):
            buttonStytle = style
            
            let titleSize = APIManager.sizeForString(buttonText, font: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline), width: CGFloat.max, height: CGFloat.max)
            
            let buttonTitleLabel = UILabel()
            buttonTitleLabel.text = buttonText
            buttonTitleLabel.textColor = style.buttonTextColor()
            buttonTitleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
            let buttonTitleLabelX = (buttonSize.width - titleSize.width) / 2
            let buttonTitleLabelY = (buttonSize.height - titleSize.height) / 2
            buttonTitleLabel.frame = CGRectMake(buttonTitleLabelX, buttonTitleLabelY, titleSize.width, titleSize.height)
            self.addSubview(buttonTitleLabel)
            
        case .ButtonItemTitleImage(let style, let buttonText, let buttonImage, _):
            buttonStytle = style
            
            let imageAndTitleSpacing: CGFloat = 6.0
            let imageSize = CGSizeMake(20.0, 20.0)
            let titleSize = APIManager.sizeForString(buttonText, font: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline), width: CGFloat.max, height: CGFloat.max)
            
            let buttonImageView = UIImageView()
            buttonImageView.image = buttonImage
            let buttonImageViewX = (buttonSize.width - (imageSize.width + imageAndTitleSpacing + titleSize.width)) / 2
            let buttonImageViewY = (buttonSize.height - imageSize.height) / 2
            buttonImageView.frame = CGRectMake(buttonImageViewX, buttonImageViewY, imageSize.width, imageSize.height)
            self.addSubview(buttonImageView)
            
            let buttonTitleLabel = UILabel()
            buttonTitleLabel.text = buttonText
            buttonTitleLabel.textColor = style.buttonTextColor()
            buttonTitleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
            let buttonTitleLabelX = buttonImageViewX + imageSize.width + imageAndTitleSpacing
            let buttonTitleLabelY = (buttonSize.height - titleSize.height) / 2
            buttonTitleLabel.frame = CGRectMake(buttonTitleLabelX, buttonTitleLabelY, titleSize.width, titleSize.height)
            self.addSubview(buttonTitleLabel)
            
        case .ButtonItemTitleSubtitle(let style, let buttonTitleText, let buttonSubtitleText, _):
            buttonStytle = style
            
            let buttonTitleLabelHeight = (buttonSize.height - (DuangGlobal.spacing * 2)) / 2
            
            let buttonTitleLabel = UILabel()
            buttonTitleLabel.text = buttonTitleText
            buttonTitleLabel.textColor = style.buttonTextColor()
            buttonTitleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
            buttonTitleLabel.frame = CGRectMake(DuangGlobal.spacing, DuangGlobal.spacing, buttonSize.width - (DuangGlobal.spacing * 2), buttonTitleLabelHeight)
            self.addSubview(buttonTitleLabel)
            
            let buttonSubtitleLabel = UILabel()
            buttonSubtitleLabel.text = buttonSubtitleText
            buttonSubtitleLabel.textColor = style.buttonTextColor()
            buttonSubtitleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
            buttonSubtitleLabel.frame = CGRectMake(DuangGlobal.spacing, DuangGlobal.spacing + buttonTitleLabelHeight, buttonSize.width - (DuangGlobal.spacing * 2), (buttonSize.height - (DuangGlobal.spacing * 2)) / 2)
            self.addSubview(buttonSubtitleLabel)
        }
        
        self.backgroundColor = buttonStytle.buttonBackgroundColor()
        self.layer.borderColor = buttonStytle.borderColor()
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5.0
    }
}