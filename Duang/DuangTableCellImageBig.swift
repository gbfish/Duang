//
//  DuangTableCellImageBig.swift
//  Duang
//
//  Created by David Yu on 15/3/23.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import UIKit

class DuangTableCellImageBig: UITableViewCell {

    @IBOutlet weak var cellImageView: UIImageView!
    
    var imagePlaceholder = UIImage()
    var imageFile: PFFile?
    
    func reloadView() {
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
