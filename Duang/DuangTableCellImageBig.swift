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
