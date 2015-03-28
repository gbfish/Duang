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
                    if let image = UIImage(data:imageData) {
                        self.cellImageView.image = image
                    }
                }
            }
        }
    }
    /*
    var duangTableDataRow: DuangTableDataRow? {
        didSet {
            if let row = duangTableDataRow {
                if isRound {
                    cellImageView.layer.cornerRadius = cellImageView.frame.size.height / 2.0
                }
                
                if let text = row.getTextArray(0) {
                    cellTitleLabel.text = text
                }
                
                if let image = row.getImageArray(0) {
                    cellImageView.image = image
                }
                
                if let imageFile = row.getImageFileArray(0) {
                    imageFile.getDataInBackgroundWithBlock { (imageData, error) -> Void in
                        if error == nil {
                            if let image = UIImage(data:imageData) {
                                self.cellImageView.image = image
                            }
                        }
                    }
                }
            }
        }
    }*/
}
