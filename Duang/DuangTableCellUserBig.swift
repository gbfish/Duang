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
    
    var imageFile: PFFile = PFFile()
    
    func reloadView() {
        userAvatarImageView.image = APIManager.sharedInstance.imagePlaceholderAvatar
        imageFile.getDataInBackgroundWithBlock { (imageData, error) -> Void in
            if error == nil {
                if let image = UIImage(data:imageData) {
                    self.userAvatarImageView.image = image
                }
            }
        }
    }
}
