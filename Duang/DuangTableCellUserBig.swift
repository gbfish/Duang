//
//  DuangTableCellUserBig.swift
//  Duang
//
//  Created by David Yu on 15/3/17.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import UIKit
import Parse

class DuangTableCellUserBig: UITableViewCell
{
    @IBOutlet weak var mainBackgroundView: UIView!
    @IBOutlet weak var userBannerImageView: UIImageView!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userDescriptionLabel: UILabel!
    
    var userName = ""
    var userDescription = ""
    var userAvatarPlaceholder = UIImage()
    var userAvatarFile: PFFile?
    var userBannerPlaceholder = UIImage()
    var userBannerFile: PFFile?
    
    func reloadView() {
        userNameLabel.text = userName
        userDescriptionLabel.text = userDescription
        
        userAvatarImageView.image = userAvatarPlaceholder
        if let file = userAvatarFile {
            file.getDataInBackgroundWithBlock { (imageData, error) -> Void in
                if error == nil {
                    if let image = UIImage(data:imageData) {
                        self.userAvatarImageView.image = image
                    }
                }
            }
        }
        
        userBannerImageView.image = userBannerPlaceholder
        if let file = userBannerFile {
            file.getDataInBackgroundWithBlock { (imageData, error) -> Void in
                if error == nil {
                    if let image = UIImage(data:imageData) {
                        self.userBannerImageView.image = image
                    }
                }
            }
        }
    }
    
    /*
    var duangTableDataRow: DuangTableDataRow? {
        didSet {
            if let row = duangTableDataRow {
                userAvatarImageView.image = APIManager.Placeholder.Avatar
                if let imageFile = row.getImageFileArray(0) {
                    imageFile.getDataInBackgroundWithBlock { (imageData, error) -> Void in
                        if error == nil {
                            if let image = UIImage(data:imageData) {
                                self.userAvatarImageView.image = image
                            }
                        }
                    }
                }
                
                userBannerImageView.image = APIManager.Placeholder.Image
                if let imageFile = row.getImageFileArray(1) {
                    imageFile.getDataInBackgroundWithBlock { (imageData, error) -> Void in
                        if error == nil {
                            if let image = UIImage(data:imageData) {
                                self.userBannerImageView.image = image
                            }
                        }
                    }
                }
                
                if let text = row.getTextArray(0) {
                    userNameLabel.text = text
                }
                
                if let text = row.getTextArray(1) {
                    userDescriptionLabel.text = text
                }
            }
        }
    }*/
}
