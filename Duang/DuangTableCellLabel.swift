//
//  DuangTableCellLabel.swift
//  Duang
//
//  Created by David Yu on 15/4/1.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import UIKit

class DuangTableCellLabel: UITableViewCell {

    @IBOutlet weak var theLabel: UILabel!
    
    var theLabelText = ""
    var theLabelFont = UIFont()
    
    
    func reloadView() {
        theLabel.text = theLabelText
        theLabel.font = theLabelFont
    }
}
