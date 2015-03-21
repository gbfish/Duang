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
    
    var duangTableDataRow: DuangTableDataRow? {
        didSet {
            if let row = duangTableDataRow {
                if let text = row.getTextArray(0) {
                    buttonLabel.text = text
                }
                
                if let color = row.getColorArray(0) {
                    buttonLabel.textColor = color
                }
                
                if let color = row.getColorArray(1) {
                    buttonLabel.backgroundColor = color
                }
            }
        }
    }
}
