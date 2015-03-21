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
    
    // MARK: - Table User
    
    private struct TableUser {
        static let Avatar = "avatar"
        static let Banner = "banner"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Description = "description"
    }
    
    // MARK: - User
    
    func login(userName: String, password: String, success: () -> (), failure: () -> ()) {
        PFUser.logInWithUsernameInBackground(userName, password: password) { (user, error) -> Void in
            if user != nil {
                self.saveUsernameAndPassowrd(userName, password: password)
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

        user.signUpInBackgroundWithBlock { (succeeded, error) -> Void in
            if error == nil {
                self.saveUsernameAndPassowrd(userName, password: password)
                success()
            } else {
                failure(error: error)
            }
        }
    }
    
    func logout() {
        PFUser.logOut()
    }
    
    func saveUsernameAndPassowrd(userName: String, password: String) {
        saveUsername(userName)
        savePassowrd(password)
    }
    
    func saveUsername(userName: String) {
        NSUserDefaults.standardUserDefaults().setObject(userName, forKey: "CurrentUserUserName")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func savePassowrd(password: String) {
        NSUserDefaults.standardUserDefaults().setObject(password, forKey: "CurrentPassword")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    
    
    var isCurrentUserAuthenticated: Bool {
        if let currentUser = PFUser.currentUser() {
            if currentUser.isAuthenticated() {
                return true
            }
        }
        return false
    }

    // MARK: - Current User
    
    var currentUser: PFUser {
        get {
            if let currentUser = PFUser.currentUser() {
                return currentUser
            } else {
                // show the signup or login screen
            }
            return PFUser()
        }
    }
    
    // MARK: Username
    
    func getCurrentUserUsername() -> String {
        return currentUser.username
    }
    
    func setCurrentUserUsername(username: String) -> String? {
        currentUser.username = username
        var error: NSError? = nil
        currentUser.save(&error)
        if let theError = error {
            return APIManager.errorMessage(theError)
        } else {
            saveUsername(username)
        }
        return nil
    }
    
    // MARK: Password
    
    func changePassword(oldPassword: String, newPassword: String) -> String? {
        if let currentPassword = NSUserDefaults.standardUserDefaults().objectForKey("CurrentPassword") as? String {
            if currentPassword == oldPassword {
                currentUser.password = newPassword
                var error: NSError? = nil
                currentUser.save(&error)
                if let theError = error {
                    return APIManager.errorMessage(theError)
                } else {
                    savePassowrd(newPassword)
                }
            } else {
                return "Your old password was entered incorrectly. Please enter it again."
            }
        }
        return nil
    }
    
    // MARK: Email
    
    func getCurrentUserEmail() -> String {
        return currentUser.email
    }
    
    func setCurrentUserEmail(email: String) -> String? {
        currentUser.email = email
        var error: NSError? = nil
        currentUser.save(&error)
        if let theError = error {
            return APIManager.errorMessage(theError)
        }
        return nil
    }
    
    // MARK: Avatar
    
    struct Placeholder {
        static let Avatar = UIImage(named: "placeholder_user")
        static let Image = UIImage(named: "placeholder_image")
    }

    
//    let imagePlaceholderAvatar = UIImage(named: "placeholder_user")
//    let imagePlaceholderImage = UIImage(named: "placeholder_image")
    
    
    func getCurrentUserAvatarFile() -> PFFile? {
        if let imageFile = currentUser[TableUser.Avatar] as? PFFile {
            return imageFile
        }
        return nil
    }
    
    func setCurrentUserAvatar(image: UIImage) {
        let imageData = UIImagePNGRepresentation(image)
        let imageFile = PFFile(name:"image.png", data:imageData)
        currentUser[TableUser.Avatar] = imageFile
        currentUser.saveInBackground()
    }
    
    // MARK: Banner

    func getCurrentUserBannerFile() -> PFFile? {
        if let imageFile = currentUser[TableUser.Banner] as? PFFile {
            return imageFile
        }
        return nil
    }
    
    func setCurrentUserBanner(image: UIImage) {
        let imageData = UIImagePNGRepresentation(image)
        let imageFile = PFFile(name:"image.png", data:imageData)
        currentUser[TableUser.Banner] = imageFile
        currentUser.saveInBackground()
    }
    
    // MARK: First Name
    
    func getCurrentUserFirstName() -> String {
        if let returnValue = currentUser[TableUser.FirstName] as? String {
            return returnValue
        }
        return ""
    }
    
    func setCurrentUserFirstName(firstName: String) {
        currentUser[TableUser.FirstName] = firstName
        currentUser.saveInBackground()
    }
    
    // MARK: Last Name
    
    func getCurrentUserLastName() -> String {
        if let returnValue = currentUser[TableUser.LastName] as? String {
            return returnValue
        }
        return ""
    }
    
    func setCurrentUserLastName(lastName: String) {
        currentUser[TableUser.LastName] = lastName
        currentUser.saveInBackground()
    }
    
    // MARK: Description
    
    func getCurrentUserDescription() -> String {
        if let returnValue = currentUser[TableUser.Description] as? String {
            return returnValue
        }
        return ""
    }
    
    func setCurrentUserDescription(lastName: String) {
        currentUser[TableUser.Description] = lastName
        currentUser.saveInBackground()
    }
    
    // MARK: - Table Photo
    
    private struct TablePhoto {
        static let ClassName = "Photo"
        
        static let Image = "image"
        static let Owner = "owner"
        static let Description = "description"
    }
    
    func addNewPhoto(image: UIImage, description: String, success: () -> (), failure: (error: NSError) -> ()) {
        var photo = PFObject(className:TablePhoto.ClassName)
        
        let imageData = UIImagePNGRepresentation(image)
        let imageFile = PFFile(name:"image.png", data:imageData)
        photo[TablePhoto.Image] = imageFile
        
        photo[TablePhoto.Owner] = currentUser
        photo[TablePhoto.Description] = description
        
        photo.saveInBackgroundWithBlock { (ifSuccess, error) -> Void in
            if (ifSuccess) {
                success()
            } else {
                failure(error: error)
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