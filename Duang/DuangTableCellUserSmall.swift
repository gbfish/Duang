//
//  DuangTableCellUserSmall.swift
//  Duang
//
//  Created by David Yu on 15/3/18.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import UIKit
import Parse

class DuangTableCellUserSmall: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
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
