//
//  Global.swift
//  Duang
//
//  Created by David Yu on 15/3/11.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import Foundation
import UIKit

struct ImagePlaceholder {
    static let Avatar = UIImage(named: "placeholder_user")!
    static let Image = UIImage(named: "placeholder_image")!
}

struct DuangImage {
    static let Share = UIImage(named: "Action_Share")!
    static let Comment = UIImage(named: "Action_Comment")!
    static let Like = UIImage(named: "Action_Like")!
    
    static let Welcome = UIImage(named: "welcome")!
}

struct DuangColor {
    
    static let Navigation = UIColor(red: 230.0/255.0, green: 179.0/255.0, blue: 61.0/255.0, alpha: 1.0)
    static let NavigationBackground = UIColor(red: 23.0/255.0, green: 44.0/255.0, blue: 60.0/255.0, alpha: 1.0)
    
    static let Text = UIColor(red: 23.0/255.0, green: 44.0/255.0, blue: 60.0/255.0, alpha: 1.0)
    
    static let ButtonNormal = UIColor(red: 217.0/255.0, green: 104.0/255.0, blue: 49.0/255.0, alpha: 1.0)
    static let ButtonNormalBackground = UIColor(red: 39.0/255.0, green: 72.0/255.0, blue: 98.0/255.0, alpha: 1.0)
    
    static let ButtonAlert = UIColor(red: 153.0/255.0, green: 80.0/255.0, blue: 84.0/255.0, alpha: 1.0)
    static let ButtonAlertBackground = UIColor(red: 23.0/255.0, green: 44.0/255.0, blue: 60.0/255.0, alpha: 1.0)
    
    static let ButtonUnselected = UIColor(red: 39.0/255.0, green: 72.0/255.0, blue: 98.0/255.0, alpha: 1.0)
    static let ButtonUnselectedBackground = UIColor(red: 217.0/255.0, green: 104.0/255.0, blue: 49.0/255.0, alpha: 1.0)
    
    static let Black = UIColor.blackColor()
    static let White = UIColor.whiteColor()
    static let DarkBlue = UIColor(red: 23.0/255.0, green: 44.0/255.0, blue: 60.0/255.0, alpha: 1.0)
    static let Blue = UIColor(red: 39.0/255.0, green: 72.0/255.0, blue: 98.0/255.0, alpha: 1.0)
    static let Red = UIColor(red: 153.0/255.0, green: 80.0/255.0, blue: 84.0/255.0, alpha: 1.0)
    static let Orange = UIColor(red: 217.0/255.0, green: 104.0/255.0, blue: 49.0/255.0, alpha: 1.0)
    static let Yellow = UIColor(red: 230.0/255.0, green: 179.0/255.0, blue: 61.0/255.0, alpha: 1.0)
}


struct DuangGlobal {
    static let spacing: CGFloat = 5.0
    
//    static var screenWidth: CGFloat {
//        let currentOrientation = UIDevice.currentDevice().orientation
//        if currentOrientation == UIDeviceOrientation.Portrait || currentOrientation == UIDeviceOrientation.PortraitUpsideDown {
//            return UIScreen.mainScreen().bounds.width
//        } else {
//            return UIScreen.mainScreen().bounds.height
//        }
//    }
//    
//    static var screenHeight: CGFloat {
//        let currentOrientation = UIDevice.currentDevice().orientation
//        if currentOrientation == UIDeviceOrientation.Portrait || currentOrientation == UIDeviceOrientation.PortraitUpsideDown {
//            return UIScreen.mainScreen().bounds.height
//        } else {
//            return UIScreen.mainScreen().bounds.width
//        }
//    }
}

struct TabBarTitle {
    static let Feed = "Feed"
    static let Users = "Users"
    static let AddPhoto = "Add photo"
    static let MyProfile = "Me"
}

// MARK: - Table

struct TableUser {
    static let ClassName = "_User"
    
    static let Id = "objectId"
    static let Avatar = "avatar"
    static let Banner = "banner"
    static let FirstName = "firstName"
    static let LastName = "lastName"
    static let Description = "description"
}

struct TableUserFollow {
    static let ClassName = "UserFollow"
    
    static let User = "user"
    static let UserFollowed = "userFollowed"
}

struct TablePhoto {
    static let ClassName = "Photo"
    
    static let Image = "image"
    static let Owner = "owner"
    static let Description = "description"
    static let ImageWidth = "imageWidth"
    static let ImageHeight = "imageHeight"
}

struct TablePhotoLike {
    static let ClassName = "PhotoLike"
    
    static let User = "user"
    static let Photo = "photo"
}

struct TablePhotoComment {
    static let ClassName = "PhotoComment"
    
    static let User = "user"
    static let Photo = "photo"
    static let Message = "message"
}


