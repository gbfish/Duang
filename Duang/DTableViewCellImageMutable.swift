//
//  DTableViewCellImageMutable.swift
//  Duang
//
//  Created by David Yu on 15/5/15.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import UIKit

class DTableViewCellImageMutable: UITableViewCell
{
    var modelRow: DTableViewModelRow?
    
    func reloadView() {
        if let theModelRow = modelRow {
            switch theModelRow.rowType {
            case .ImageMutable(let collection):
                let photos = collection.relationForKey(TablePhotoCollection.Photos)
                if let photosQuery = photos.query() {
                    photosQuery.findObjectsInBackgroundWithBlock({ (objectArray, error) -> Void in
                        println("objectArray = \(objectArray?.count)")
                    })
                }
                
                
            default:
                break
            }
        }
    }
}
