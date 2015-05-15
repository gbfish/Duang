//
//  DTableViewCellImage.swift
//  Duang
//
//  Created by David Yu on 15/4/22.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import UIKit

class DTableViewCellImage: UITableViewCell
{
    @IBOutlet weak var cellImageView: UIImageView!
    
    var cellImage: UIImage?
    var cellImageFile: PFFile?
    
    func reloadView() {
        if let theCellImage = cellImage {
            cellImageView.image = theCellImage
        }
        
        APIManager.fetchImageFromFile(cellImageFile, success: { (image) -> () in
            self.cellImageView.image = image
        })
    }
}
