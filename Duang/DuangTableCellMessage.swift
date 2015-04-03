//
//  DuangTableCellMessage.swift
//  Duang
//
//  Created by David Yu on 15/4/3.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import UIKit
import ParseUI

class DuangTableCellMessage: UITableViewCell
{
    @IBOutlet weak var messageOwnerAvatarImageView: PFImageView!
    @IBOutlet weak var messageTextLabel: UILabel!

    enum MessageStyle {
        case Left
        case Right
    }
    var messageStyle = MessageStyle.Left
    
}
