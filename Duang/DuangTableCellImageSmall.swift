//
//  DuangTableCellImageSmall.swift
//  Duang
//
//  Created by David Yu on 15/3/20.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import UIKit
import Parse

class DuangTableCellImageSmall: UITableViewCell
{
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellTitleLabel: UILabel!
    
    var imageTitle = ""
    var imagePlaceholder = UIImage()
    var imageFile: PFFile?
    var isRound = false
    
    func reloadView() {
        cellTitleLabel.text = imageTitle
        
        if isRound {
            cellImageView.layer.cornerRadius = cellImageView.frame.size.height / 2.0
        }
        
        cellImageView.image = imagePlaceholder
        if let file = imageFile {
            file.getDataInBackgroundWithBlock { (imageData, error) -> Void in
                if error == nil {
                    if let theImageData = imageData, image = UIImage(data:theImageData) {
                        self.cellImageView.image = image
                    }
                }
            }
        }
    }
}
