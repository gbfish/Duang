//
//  DTableViewCellDetail.swift
//  Duang
//
//  Created by YU GUOBIN on 15/4/23.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import UIKit

class DTableViewCellDetail: UITableViewCell
{
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailButton: UIButton!
    
    var detailText: String?
    
    var detailImage: UIImage?
    var detailImageFile: PFFile?
    var detailImageIsRound = false
    
    var buttonItem: DTableViewModelRow.ButtonItem?
    
    func reloadView() {
        detailLabel.text = detailText
        
        if detailImageIsRound {
            detailImageView.layer.cornerRadius = detailImageView.frame.size.height / 2.0
        }
        
        detailImageView.image = detailImage
        if let file = detailImageFile {
            file.getDataInBackgroundWithBlock { (imageData, error) -> Void in
                if error == nil {
                    if let theImageData = imageData, image = UIImage(data:theImageData) {
                        self.detailImageView.image = image
                    }
                }
            }
        }
        
        if let theButtonItem = buttonItem {
            detailButton.hidden = false
        } else {
            detailButton.hidden = true
        }
    }
}
