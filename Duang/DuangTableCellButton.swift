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
    
    /*
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
    }*/
}
