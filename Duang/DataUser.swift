//
//  DataUser.swift
//  Duang
//
//  Created by David Yu on 15/3/23.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import Foundation

class DataUser {
    func user(object: PFUser) -> DataUser {
        let user = DataUser()
        if let string = object[TableUser.FirstName] as? String {
            user.firstName = string
        }
        if let string = object[TableUser.LastName] as? String {
            user.lastName = string
        }
        if let imageFile = object[TableUser.Avatar] as? PFFile {
            user.imageFileAvatar = imageFile
        }
        if let imageFile = object[TableUser.Banner] as? PFFile {
            user.imageFileBanner = imageFile
        }
        return user
    }
    
    var firstName: String?
    var lastName: String?
    
    var imageFileAvatar: PFFile?
    var imageFileBanner: PFFile?
}