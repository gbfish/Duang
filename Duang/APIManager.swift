//
//  APIManager.swift
//  Duang
//
//  Created by David Yu on 15/3/11.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import Foundation
import Parse

class APIManager {
    class var sharedInstance: APIManager {
        struct Static {
            static let instance: APIManager = APIManager()
        }
        return Static.instance
    }
    
    init() {
    }
    
    class func errorMessage(error: NSError) -> String {
        var errorString = "There was a problem processing your request."
        if let userInfo = error.userInfo as? [NSObject: NSObject] {
            if let errorInfoString: NSString = userInfo["error"] as? NSString {
                errorString = errorInfoString
            }
        }
        return errorString
    }
    
    // MARK: - User
    
    func login(userName: String, password: String, success: () -> (), failure: () -> ()) {
        PFUser.logInWithUsernameInBackground(userName, password: password) { (user, error) -> Void in
            if user != nil {
                success()
            } else {
                failure()
            }
        }
    }
    
    func signup(userName: String, password: String, email: String, success: () -> (), failure: (error: NSError) -> ()) {
        var user: PFUser = PFUser()
        
        user.username = userName
        user.password = password
        user.email = email
        
        // other fields can be set just like with PFObject
//        user[@"phone"] = @"415-392-0202";
        
        user.signUpInBackgroundWithBlock { (succeeded, error) -> Void in
            if error == nil {
                success()
            } else {
                failure(error: error)
            }
        }
    }
    
    var isCurrentUser: Bool {
        var currentUser = PFUser.currentUser()
        if currentUser.isAuthenticated() {
            return true
        } else {
            return false
        }
    }
    /*
    var currentUserUsername: String {
        get {
            if let currentUser = PFUser.currentUser() {
                return currentUser.username
            } else {
                return ""
            }
        }
        set {
            if let currentUser = PFUser.currentUser() {
                currentUser.username = newValue
                var error: NSError? = nil
                currentUser.save(&error)
                if let theError = error {
                    var errorString = "There was a problem processing your request."
                    if let userInfo = theError.userInfo as? [NSObject: NSObject] {
                        if let errorInfoString: NSString = userInfo["error"] as? NSString {
                            
                            errorString = errorInfoString
                            
                            println("--errorString = \(errorString)")
                        }
                    }
                } else {
                    // Error is still nil - proceed with business logic.
                }
            }
        }
    }*/
    
    func getCurrentUserUsername() -> String {
        return PFUser.currentUser().username
    }
    
    func setCurrentUserUsername(username: String) -> String? {
        let currentUser = PFUser.currentUser()
        currentUser.username = username
        var error: NSError? = nil
        currentUser.save(&error)
        if let theError = error {
            return APIManager.errorMessage(theError)
        } else {
            return nil
        }
    }
    
//    func currentUserAvatar(success: (UIImage) -> ()) {
//        if let currentUser = PFUser.currentUser() {
//            let imageFile = currentUser["avatar"] as PFFile
//            imageFile.getDataInBackgroundWithBlock({ (imageData, error) -> Void in
//                if error == nil {
//                    if let image = UIImage(data:imageData) {
//                        success(image)
//                    }
//                }
//            })
//        }
//    }
    
    var imagePlaceholderAvatar = UIImage(named: "placeholder_user")
    
    var currentUserAvatarFile: PFFile {
        get {
            if let currentUser = PFUser.currentUser() {
                if let imageFile = currentUser["avatar"] as? PFFile {
                    return imageFile
                }
            }
            return PFFile()
        }
        
    }
    
    var currentUserAvatar: UIImage? {
        get {
            return nil
        }
        set {
            if let currentUser = PFUser.currentUser() {
                let imageData = UIImagePNGRepresentation(newValue)
                let imageFile = PFFile(name:"image.png", data:imageData)
                
                currentUser["avatar"] = imageFile
                currentUser.saveInBackground()
            }
        }
    }
    
    // MARK: - Validate Email
    
    func validateEmail(email: NSString) -> Bool {
        if (email.rangeOfString("@").length != 0) && (email.rangeOfString(".").length != 0) {
            let tmpInvalidCharSet = NSCharacterSet.alphanumericCharacterSet().invertedSet as NSCharacterSet
            let tmpInvalidMutableCharSet = tmpInvalidCharSet.mutableCopy() as NSMutableCharacterSet
            tmpInvalidMutableCharSet.removeCharactersInString("_-")
            
            let range1 = email.rangeOfString("@", options: NSStringCompareOptions.CaseInsensitiveSearch) as NSRange
            
            let userNameString = email.substringToIndex(range1.location) as NSString
            let userNameArray = userNameString.componentsSeparatedByString(".") as NSArray
            for string in userNameArray {
                let rangeOfInavlidChars = string.rangeOfCharacterFromSet(tmpInvalidMutableCharSet) as NSRange
                if rangeOfInavlidChars.length != 0 || string as NSString == "" {
                    return false
                }
            }
            
            let domainString = email.substringFromIndex(range1.location + 1) as NSString
            let domainArray = domainString.componentsSeparatedByString(".") as NSArray
            for string in domainArray {
                let rangeOfInavlidChars = string.rangeOfCharacterFromSet(tmpInvalidMutableCharSet)
                if rangeOfInavlidChars.length != 0 || string as NSString == "" {
                    return false
                }
            }
            return true
        } else {
            return false
        }
    }
}