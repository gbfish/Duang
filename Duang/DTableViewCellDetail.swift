//
//  DTableViewCellDetail.swift
//  Duang
//
//  Created by YU GUOBIN on 15/4/23.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import UIKit

protocol DTableViewCellDetailProtocol
{
    func dTableViewCellDetailButtonAction(modelRow: DTableViewModelRow)
    
    func dTableViewCellDetailButtonActionFollow(user: PFUser)
    func dTableViewCellDetailButtonActionUnfollow(user: PFUser)
}

class DTableViewCellDetail: UITableViewCell
{
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailButton: UIButton!
    
    var delegate: DTableViewCellDetailProtocol?
    var modelRow: DTableViewModelRow?
    
    private var userFollow: PFUser?
    
    func reloadView() {
        if let theModelRow = modelRow {
            switch theModelRow.rowType {
            case .DetailImage(let image, let imageFile, let detailTitle, let detailButtonItem):
                detailLabel.text = detailTitle
                
                if let theImage = image {
                    detailImageView.image = theImage
                } else {
                    detailImageView.image = ImagePlaceholder.Image
                    APIManager.fetchImageFromFile(imageFile, success: { (image) -> () in
                        self.detailImageView.image = image
                    })
                }
                
                prepareButton(detailButtonItem)
                
            case .DetailUser(let user, let detailButtonType):
                detailImageView.layer.cornerRadius = detailImageView.frame.size.height / 2.0
                detailImageView.image = ImagePlaceholder.Avatar
                
                if let theUser = user {
                    APIManager.fetchUser(theUser, success: { (theUserResult) -> () in
                        self.userFollow = theUserResult
                        self.detailLabel.text = APIManager.getNameFromUser(theUserResult)
                        
                        APIManager.fetchImageFromFile(APIManager.getFileFromUser(theUserResult, key: TableUser.Avatar), success: { (image) -> () in
                            self.detailImageView.image = image
                        })
                        
                        if let theDetailButtonType = detailButtonType {
                            self.detailButton.hidden = false
                            switch theDetailButtonType {
                            case .ButtonItem(let buttonItem):
                                self.detailButton.setButton(buttonItem, buttonSize: self.detailButton.frame.size)
                                self.detailButton.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                            case .Follow:
                                if !APIManager.ifCurrentUser(theUserResult) {
                                    APIManager.ifFollowUser(theUserResult, success: { (followed) -> () in
                                        if followed {
                                            self.setDetailButtonUnfollow()
                                        } else {
                                            self.setDetailButtonFollow()
                                        }
                                    })
                                } else {
                                    self.detailButton.hidden = true
                                }
                            }
                        } else {
                            self.detailButton.hidden = true
                        }
                        /*
                        self.detailButton.hidden = false
                        if let theDetailButtonItem = detailButtonItem {
                            self.detailButton.setButton(theDetailButtonItem, buttonSize: self.detailButton.frame.size)
                            self.detailButton.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                        } else {
                            if !APIManager.ifCurrentUser(theUserResult) {
                                APIManager.ifFollowUser(theUserResult, success: { (followed) -> () in
                                    if followed {
                                        self.setDetailButtonUnfollow()
//                                        let buttonItem = DTableViewModelRow.ButtonItem.ButtonItemTitle(style: DTableViewModelRow.ButtonItem.ButtonItemStyle.Normal, buttonText: "Unfollow", function: DTableViewModelRow.Function.Nothing)
//                                        self.detailButton.setButton(buttonItem, buttonSize: self.detailButton.frame.size)
//                                        self.detailButton.addTarget(self, action: "buttonActionUnfollow:", forControlEvents: UIControlEvents.TouchUpInside)
                                    } else {
                                        self.setDetailButtonFollow()
//                                        let buttonItem = DTableViewModelRow.ButtonItem.ButtonItemTitle(style: DTableViewModelRow.ButtonItem.ButtonItemStyle.Normal, buttonText: "Follow", function: DTableViewModelRow.Function.Nothing)
//                                        self.detailButton.setButton(buttonItem, buttonSize: self.detailButton.frame.size)
//                                        self.detailButton.addTarget(self, action: "buttonActionFollow:", forControlEvents: UIControlEvents.TouchUpInside)
                                    }
                                })
                            } else {
                                self.detailButton.hidden = true
                            }
                        }*/
                    })
                }
                

                
                
            default:
                break
            }
        }
    }
    
    func prepareButton(buttonItem: DTableViewModelRow.ButtonItem?) {
        if let theButtonItem = buttonItem {
            detailButton.hidden = false
            detailButton.setButton(theButtonItem, buttonSize: detailButton.frame.size)
            detailButton.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        } else {
            detailButton.hidden = true
        }
    }
    
    private func setDetailButtonFollow() {
        let buttonItem = DTableViewModelRow.ButtonItem.ButtonItemTitle(style: DTableViewModelRow.ButtonItem.ButtonItemStyle.Normal, buttonText: "Follow", function: DTableViewModelRow.Function.Nothing)
        detailButton.setButton(buttonItem, buttonSize: self.detailButton.frame.size)
        detailButton.addTarget(self, action: "buttonActionFollow:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    private func setDetailButtonUnfollow() {
        let buttonItem = DTableViewModelRow.ButtonItem.ButtonItemTitle(style: DTableViewModelRow.ButtonItem.ButtonItemStyle.Normal, buttonText: "Unfollow", function: DTableViewModelRow.Function.Nothing)
        detailButton.setButton(buttonItem, buttonSize: self.detailButton.frame.size)
        detailButton.addTarget(self, action: "buttonActionUnfollow:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func buttonAction(sender: UIButton) {
        if let theModelRow = modelRow {
            delegate?.dTableViewCellDetailButtonAction(theModelRow)
        }
    }
    
    func buttonActionUnfollow(sender: UIButton) {
        println("buttonActionUnfollow")
        if let theUserFollow = userFollow {
            delegate?.dTableViewCellDetailButtonActionUnfollow(theUserFollow)
            setDetailButtonFollow()
        }
    }
    
    func buttonActionFollow(sender: UIButton) {
        println("buttonActionFollow")
        if let theUserFollow = userFollow {
            delegate?.dTableViewCellDetailButtonActionFollow(theUserFollow)
            setDetailButtonUnfollow()
        }
    }
}
