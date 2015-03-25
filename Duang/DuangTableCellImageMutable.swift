//
//  DuangTableCellImageMutable.swift
//  Duang
//
//  Created by David Yu on 15/3/25.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import UIKit

class DuangTableCellImageMutable: UITableViewCell {

    var duangTableDataRow: DuangTableDataRow? {
        didSet {
            if let row = duangTableDataRow {
                
//                if let image = row.getImageArray(0) {
//                    cellImageView.image = image
//                }
                
                
                println("row.imageFileArray = \(row.imageFileArray)")
                
                if let imageFileArray = row.imageFileArray {
                    switch imageFileArray.count {
                    case 1:
                        println("hello")
                        
//                    case 2:
                        
                    default:
                        break
                    }
                }
                
                
                
//                swich row.imageFileArray.count {
//                    case 1:
//                    
//                }
                
//                if let imageFile = row.getImageFileArray(0) {
//                    imageFile.getDataInBackgroundWithBlock { (imageData, error) -> Void in
//                        if error == nil {
//                            if let image = UIImage(data:imageData) {
//                                self.cellImageView.image = image
//                            }
//                        }
//                    }
//                }
            }
        }
    }
}
