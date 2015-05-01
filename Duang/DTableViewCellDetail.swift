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
            case .Detail(let image, let imageFile, let isRound, let detailTitle, let detailButtonItem):
                detailLabel.text = detailTitle
                
                if isRound {
                    detailImageView.layer.cornerRadius = detailImageView.frame.size.height / 2.0
                }
                
                detailImageView.image = image
                
                APIManager.fetchImageFromFile(imageFile, success: { (image) -> () in
                    self.detailImageView.image = image
                })
                
//                if let theImageFile = imageFile {
//                    theImageFile.getDataInBackgroundWithBlock { (imageData, error) -> Void in
//                        if error == nil {
//                            if let theImageData = imageData, image = UIImage(data:theImageData) {
//                                self.detailImageView.image = image
//                            }
//                        }
//                    }
//                }
                
                if let theDetailButtonItem = detailButtonItem {
                    detailButton.hidden = false
                    detailButton.setButton(theDetailButtonItem, buttonSize: detailButton.frame.size)
                    detailButton.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                } else {
                    detailButton.hidden = true
                
                }
                
            case .DetailUser(let user, let detailButtonItem):
                detailImageView.image = ImagePlaceholder.Avatar
                detailImageView.layer.cornerRadius = detailImageView.frame.size.height / 2.0
                
                if let theUser = user {
                    APIManager.sharedInstance.fetchUser(theUser, success: { (theUserResult) -> () in
                        APIManager.fetchImageFromFile(APIManager.getFileFromUser(theUserResult, key: TableUser.Avatar), success: { (image) -> () in
                            self.detailImageView.image = image
                        })
                        
//                        if let theImageFile = APIManager.getFileFromUser(theUserResult, key: TableUser.Avatar) {
//                            
//                            
//                            theImageFile.getDataInBackgroundWithBlock { (imageData, error) -> Void in
//                                if error == nil {
//                                    if let theImageData = imageData, image = UIImage(data:theImageData) {
//                                        self.detailImageView.image = image
//                                    }
//                                }
//                            }
//                        }
                        
                        self.detailLabel.text = APIManager.getNameFromUser(theUserResult)
                        
                        }, failure: { (error) -> () in
                            println("error = \(error)")
                    })
                }
                
                
                if let theDetailButtonItem = detailButtonItem {
                    detailButton.hidden = false
                    detailButton.setButton(theDetailButtonItem, buttonSize: detailButton.frame.size)
                    detailButton.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                } else {
                    detailButton.hidden = true
                    
                }
                
                
            default:
                break
            }
        }
    }
    
    func buttonAction(sender: UIButton) {
        if let theModelRow = modelRow {
            delegate?.dTableViewCellDetailButtonAction(theModelRow)
        }
    }
}
