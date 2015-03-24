//
//  DataPhoto.swift
//  Duang
//
//  Created by David Yu on 15/3/23.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import Foundation

class DataPhoto {
    class func photoArray(objects: [PFObject]) -> [DataPhoto]{
        func photo(object: PFObject) -> DataPhoto {
            let photo = DataPhoto()
            if let imageFile = object[TablePhoto.Image] as? PFFile {
                photo.imageFile = imageFile
            }
            if let owner = object[TablePhoto.Owner] as? PFUser {
                photo.owner = owner
            }
            if let description = object[TablePhoto.Description] as? String {
                photo.description = description
            }
            if let number = object[TablePhoto.ImageWidth] as? NSNumber {
                photo.imageWidth = CGFloat(number.doubleValue)
            }
            if let number = object[TablePhoto.ImageHeight] as? NSNumber {
                photo.imageHeight = CGFloat(number.doubleValue)
            }
            return photo
        }
        var returnValue = [DataPhoto]()
        for object in objects {
            returnValue.append(photo(object))
        }
        return returnValue
    }

    var imageFile: PFFile?
    var owner: PFUser?
    var description: String?
    var imageWidth: CGFloat?
    var imageHeight: CGFloat?
    
    func cellHeight() -> CGFloat? {
        if let width = imageWidth {
            if let height = imageHeight {
                return DuangGlobal.screenWidth * height / width
            }
        }
        return nil
    }
}