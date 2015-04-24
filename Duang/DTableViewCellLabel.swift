//
//  DTableViewCellLabel.swift
//  Duang
//
//  Created by YU GUOBIN on 15/4/24.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import UIKit

class DTableViewCellLabel: UITableViewCell
{
    @IBOutlet weak var cellLabel: UILabel!

    var cellLabelText: String?
    var cellLabelFont: UIFont?
    
    func reloadView() {
        if let theCellLabelText = cellLabelText, theCellLabelFont = cellLabelFont {
            cellLabel.text = theCellLabelText
            cellLabel.font = theCellLabelFont
        }
    }
}
