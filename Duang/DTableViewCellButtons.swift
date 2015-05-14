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
    
    func dTableViewCellButtonsActionLike(photo: PFObject)
    func dTableViewCellButtonsActionUnlike(photo: PFObject)
    func dTableViewCellButtonsActionComment(photo: PFObject)
    func dTableViewCellButtonsActionShare(photo: PFObject)
}

class DTableViewCellButtons: UITableViewCell
{
    var delegate: DTableViewCellButtonsProtocol?
    var modelRow: DTableViewModelRow?
    
    
    
    private var buttonItemArray: [DTableViewModelRow.ButtonItem]?
    
    var buttons = [UIButton]()
    
    func reloadView() {
        for button in buttons {
            button.removeFromSuperview()
        }
        buttons = [UIButton]()
        
        if let theModelRow = modelRow {
            switch theModelRow.rowType {
            case .Buttons(let buttonItemArray):
                self.setButtons(buttonItemArray)
            case .ButtonsWaterfall(let photo):
                self.setButtons(photo)
            default:
                break
            }
        }
    }
    
    // MARK: - Nomal
    
    private func setButtons(buttonItemArray: [DTableViewModelRow.ButtonItem]) {
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
    }
    
    func buttonAction(sender: UIButton) {
        if let theButtonItemArray = buttonItemArray {
            if sender.tag < theButtonItemArray.count {
                delegate?.dTableViewCellButtonsAction(theButtonItemArray[sender.tag])
            }
        }
    }
    
    // MARK: - Waterfall
    
    private var photo: PFObject? {
        get {
            if let theModelRow = modelRow {
                switch theModelRow.rowType {
                case .ButtonsWaterfall(let photo):
                    return photo
                default:
                    break
                }
            }
            return nil
        }
    }
    
    private var likePhoto = false
    
    private var totalLike: Int32 = 0
    private var totalComment: Int32 = 0
    
    private func setButtons(photo: PFObject) {
        APIManager.fetchLikeTotalPhoto(photo, success: { (likeTotal) -> () in
            self.totalLike = likeTotal
            
            if let user = PFUser.currentUser() {
                APIManager.ifLikePhoto(user, photo: photo, success: { (like) -> () in
                    self.likePhoto = like
                    
                    APIManager.fetchCommentTotalPhoto(photo, success: { (comment) -> () in
                        self.totalComment = comment
                        
                        self.reloadButtonsData()
                    })
                })
            }
        })
    }
    
    private func reloadButtonsData() {
        var newButtonItemArray: [DTableViewModelRow.ButtonItem]?
        
        let buttonItemLike = DTableViewModelRow.ButtonItem.ButtonItemTitleImage(style: DTableViewModelRow.ButtonItem.ButtonItemStyle.Normal, buttonText: "\(totalLike)", buttonImage: DuangImage.Like, function: DTableViewModelRow.Function.Nothing)
        let buttonItemLiked = DTableViewModelRow.ButtonItem.ButtonItemTitleImage(style: DTableViewModelRow.ButtonItem.ButtonItemStyle.Selected, buttonText: "\(totalLike)", buttonImage: DuangImage.Like, function: DTableViewModelRow.Function.Nothing)
        let buttonItemComment = DTableViewModelRow.ButtonItem.ButtonItemTitleImage(style: DTableViewModelRow.ButtonItem.ButtonItemStyle.Normal, buttonText: "\(totalComment)", buttonImage: DuangImage.Comment, function: DTableViewModelRow.Function.Nothing)
        let buttonItemShare = DTableViewModelRow.ButtonItem.ButtonItemTitleImage(style: DTableViewModelRow.ButtonItem.ButtonItemStyle.Normal, buttonText: "4", buttonImage: DuangImage.Share, function: DTableViewModelRow.Function.Nothing)
        
        if likePhoto {
            newButtonItemArray = [buttonItemLiked, buttonItemComment, buttonItemShare]
        } else {
            newButtonItemArray = [buttonItemLike, buttonItemComment, buttonItemShare]
        }
        
        buttonItemArray = newButtonItemArray
        
        reloadButtonsView()
    }
    
    private func reloadButtonsView() {
        if let theButtonItemArray = self.buttonItemArray {
            let buttonWidth = (self.bounds.width - (DuangGlobal.spacing * CGFloat(theButtonItemArray.count + 1))) / CGFloat(theButtonItemArray.count)
            let buttonHeight = self.bounds.height - (DuangGlobal.spacing * 2)
            
            for var index = 0; index < theButtonItemArray.count; ++index {
                let buttonRect = CGRectMake((buttonWidth + DuangGlobal.spacing) * CGFloat(index) + DuangGlobal.spacing, DuangGlobal.spacing, buttonWidth, buttonHeight)
                let button = UIButton(frame: buttonRect)
                
                button.setButton(theButtonItemArray[index], buttonSize: buttonRect.size)
                button.tag = index
                
                switch index {
                case 0:
                    if likePhoto {
                        button.addTarget(self, action: "buttonActionUnike:", forControlEvents: UIControlEvents.TouchUpInside)
                    } else {
                        button.addTarget(self, action: "buttonActionLike:", forControlEvents: UIControlEvents.TouchUpInside)
                    }
                case 1:
                    button.addTarget(self, action: "buttonActionComment:", forControlEvents: UIControlEvents.TouchUpInside)
                case 2:
                    button.addTarget(self, action: "buttonActionShare:", forControlEvents: UIControlEvents.TouchUpInside)
                default:
                    break
                }
                self.addSubview(button)
                self.buttons.append(button)
            }
        }
    }
    
    func buttonActionLike(sender: UIButton) {
        if let thePhoto = photo {
            delegate?.dTableViewCellButtonsActionLike(thePhoto)
            
            likePhoto = true
            ++totalLike
            reloadButtonsData()
        }
    }
    
    func buttonActionUnike(sender: UIButton) {
        if let thePhoto = photo {
            delegate?.dTableViewCellButtonsActionUnlike(thePhoto)
            
            likePhoto = false
            --totalLike
            reloadButtonsData()
        }
    }
    
    func buttonActionComment(sender: UIButton) {
        if let thePhoto = photo {
            delegate?.dTableViewCellButtonsActionComment(thePhoto)
        }
    }
    
    func buttonActionShare(sender: UIButton) {
        if let thePhoto = photo {
            delegate?.dTableViewCellButtonsActionShare(thePhoto)
        }
    }
}
