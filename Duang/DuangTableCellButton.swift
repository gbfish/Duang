//
//  DuangTableCellButton.swift
//  Duang
//
//  Created by David Yu on 15/3/17.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import UIKit

class DuangTableCellButton: UITableViewCell
{
    @IBOutlet weak var buttonLabel: UILabel!
    
    var buttonText = ""
    var buttonTextColor = UIColor()
    var buttonBackgroundColor = UIColor()
    
    func reloadView() {
        buttonLabel.text = buttonText
        buttonLabel.textColor = buttonTextColor
        buttonLabel.backgroundColor = buttonBackgroundColor
    }
}
