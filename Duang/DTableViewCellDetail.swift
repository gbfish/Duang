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
}

class DTableViewCellDetail: UITableViewCell
{
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailButton: UIButton!
    
    var delegate: DTableViewCellDetailProtocol?
    var modelRow: DTableViewModelRow?
    
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
                
            case .DetailUser(let image, let user, let detailButtonItem):
                detailImageView.layer.cornerRadius = detailImageView.frame.size.height / 2.0
                
                if let theImage = image {
                    detailImageView.image = theImage
                } else {
                    detailImageView.image = ImagePlaceholder.Avatar
                    if let theUser = user {
                        APIManager.sharedInstance.fetchUser(theUser, success: { (theUserResult) -> () in
                            APIManager.fetchImageFromFile(APIManager.getFileFromUser(theUserResult, key: TableUser.Avatar), success: { (image) -> () in
                                self.detailImageView.image = image
                            })
                        })
                    }
                }
                
                if let theUser = user {
                    APIManager.sharedInstance.fetchUser(theUser, success: { (theUserResult) -> () in
                        self.detailLabel.text = APIManager.getNameFromUser(theUserResult)
                    })
                }
                
                prepareButton(detailButtonItem)
                
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
    
    func buttonAction(sender: UIButton) {
        if let theModelRow = modelRow {
            delegate?.dTableViewCellDetailButtonAction(theModelRow)
        }
    }
}
