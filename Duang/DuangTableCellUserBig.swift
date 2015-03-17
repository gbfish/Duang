//
//  DuangTableCellUserBig.swift
//  Duang
//
//  Created by David Yu on 15/3/17.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import UIKit

class DuangTableCellUserBig: UITableViewCell {

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
}
