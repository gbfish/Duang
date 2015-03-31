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
    
    // MARK: - PFObject
    
    class func getStringFromObject(object: PFObject, key: String) -> String? {
        if let returnValue = object[key] as? String {
            return returnValue
        }
        return nil
    }
    
    class func getFloatFromObject(object: PFObject, key: String) -> CGFloat? {
        if let returnValue = object[key] as? CGFloat {
            return returnValue
        }
        return nil
    }
    
    class func getFileArrayFromPost(object: PFObject, success: ([PFFile]) -> (), failure: (error: NSError) -> ()) {
        
        if let relation = object[TablePost.Photos] as? PFRelation {            
            relation.query().findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]!, error: NSError!) -> Void in
                if error != nil {
                    // There was an error
                } else {
                    var returnValue = [PFFile]()
                    for object in objects {
                        if let file = object[TablePhoto.Image] as? PFFile {
                            returnValue.append(file)
                        }
                    }
                    success(returnValue)
                }
            }
        }
//        return nil
        
        /*
        if let array = object[key] as? NSArray {
            var returnValue = [PFFile]()
            for objectInArray in array {
                
//                if objectInArray != nil {
//                    objectInArray![TablePhoto.Image]
//                }
                
                if let photo = objectInArray as? PFObject {
                    
                    println("--photo = \(photo)")
                    
//                    returnValue.append(photo[TablePhoto.Image]!)
                    
                    let imageFile = photo[TablePhoto.Image] as PFFile
                    
                    println("--imageFile = \(imageFile)")
                    
                    returnValue.append(imageFile)
                    
//                    if let imageFile = photo[TablePhoto.Image] as? PFFile {
//                        returnValue.append(imageFile)
//                        
//                    } else {
//                        println("else ")
//                    }
                    
                    
                }
            }
            if returnValue.count > 0 {
                return returnValue
            }
        }
        return nil
*/
    }
    
    class func getFileFromObject(object: PFObject, key: String) -> PFFile? {
        if let returnValue = object[key] as? PFFile {
            return returnValue
        }
        return nil
    }
    
    class func getUserFromObject(object: PFObject?, key: String) -> PFUser? {
        if object != nil {
            if let returnValue = object![key] as? PFUser {
                return returnValue
            }
        }
        return nil
    }
    
    class func getHeightFromObject(object: PFObject, keyWidth: String, keyHeight: String) -> CGFloat? {
        if let width = object[keyWidth] as? CGFloat {
            if let height = object[keyHeight] as? CGFloat {
                return DuangGlobal.screenWidth * height / width
            }
        }
        return nil
    }
    
    // MARK: - PFUser
    
    class func getStringFromUser(user: PFUser?, key: String) -> String? {
        if user != nil {
            if let returnValue = user![key] as? String {
                return returnValue
            }
        }
        return nil
    }
    
    class func getFileFromUser(user: PFUser?, key: String) -> PFFile? {
        if user != nil {
            if let returnValue = user![key] as? PFFile {
                return returnValue
            }
        }
        return nil
    }
    
    class func getNameFromUser(user: PFUser?) -> String? {
        if user != nil {
            var returnValue = ""
            if let firstName = APIManager.getStringFromUser(user, key: TableUser.FirstName) {
                returnValue = "\(firstName) "
            }
            if let lastName = APIManager.getStringFromUser(user, key: TableUser.LastName) {
                returnValue = "\(returnValue)\(lastName)"
            }
            return returnValue
        }
        return nil
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
        let oldUsername = currentUser.username
        currentUser.username = username
        var error: NSError? = nil
        currentUser.save(&error)
        if let theError = error {
            currentUser.username = oldUsername
            currentUser.save()
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
                    currentUser.password = oldPassword
                    currentUser.save()
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
    
    // MARK: - Table Post
    
    func addPost(title: String, description: String, photoArray: NSArray, success: () -> (), failure: (NSError) -> ()) {
        var post = PFObject(className:TablePost.ClassName)
        post[TablePost.Title] = title
        post[TablePost.Description] = description
        post[TablePost.Owner] = PFUser.currentUser()
        
        post.save()
        
        var photos = post.relationForKey(TablePost.Photos)
        
//        var postPhotoArray = [PFObject]()
        for photoData in photoArray {
            if let photoDictionary = photoData as? NSDictionary {
                if let photoImage = photoDictionary.objectForKey("photo") as? UIImage {
                    if let photoDescriptionData = photoDictionary.objectForKey("description") as? String {
                        var photo = PFObject(className:TablePhoto.ClassName)
                        photo[TablePhoto.Description] = photoDescriptionData
                        photo[TablePhoto.ImageWidth] = photoImage.size.width
                        photo[TablePhoto.ImageHeight] = photoImage.size.height
                        
                        let imageData = UIImagePNGRepresentation(photoImage)
                        let imageFile = PFFile(name:"image.png", data:imageData)
                        photo[TablePhoto.Image] = imageFile
                        photo[TablePhoto.Owner] = PFUser.currentUser()
//                        photo.saveInBackground()
                        
//                        postPhotoArray.append(photo)
                        
                        photo.save()
                        
                        photos.addObject(photo)
                    }
                }
            }
        }
//        post[TablePost.PhotoArray] = postPhotoArray

        post.saveInBackgroundWithBlock { (ifSuccess, error) -> Void in
            if error == nil {
                success()
            } else {
                failure(error)
            }
        }
    }
    
    func addPhotoForPost(post: PFObject, photoArray: NSArray, success: () -> (), failure: (NSError) -> ()) {
        
        var photos = post.relationForKey(TablePost.Photos)
        
        for photoData in photoArray {
            if let photoDictionary = photoData as? NSDictionary {
                if let photoImage = photoDictionary.objectForKey("photo") as? UIImage {
                    if let photoDescriptionData = photoDictionary.objectForKey("description") as? String {
                        var photo = PFObject(className:TablePhoto.ClassName)
                        photo[TablePhoto.Description] = photoDescriptionData
                        photo[TablePhoto.ImageWidth] = photoImage.size.width
                        photo[TablePhoto.ImageHeight] = photoImage.size.height
                        
                        let imageData = UIImagePNGRepresentation(photoImage)
                        let imageFile = PFFile(name:"image.png", data:imageData)
                        photo[TablePhoto.Image] = imageFile
                        photo[TablePhoto.Owner] = PFUser.currentUser()
                        
                        
                        photos.addObject(photo)
                    }
                }
            }
        }
        
        post.saveInBackgroundWithBlock({ (ifSuccess, error) -> Void in
            if error == nil {
                success()
            } else {
                failure(error)
            }
        })

    }
    
    func getPostArray(success: ([PFObject]) -> (), failure: (NSError) -> ()) {
        var query = PFQuery(className:TablePost.ClassName)
        query.limit = 20
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    success(objects)
                }
            } else {
                failure(error)
            }
        }
    }
    
    // MARK: - Table Photo
    
    func addNewPhoto(image: UIImage, description: String, success: () -> (), failure: (error: NSError) -> ()) {
        var photo = PFObject(className:TablePhoto.ClassName)
        
        photo[TablePhoto.Description] = description
        photo[TablePhoto.ImageWidth] = image.size.width
        photo[TablePhoto.ImageHeight] = image.size.height
        
        let imageData = UIImagePNGRepresentation(image)
        let imageFile = PFFile(name:"image.png", data:imageData)
        photo[TablePhoto.Image] = imageFile
        
                
        photo[TablePhoto.Owner] = PFUser.currentUser()
        
        photo.saveInBackgroundWithBlock { (ifSuccess, error) -> Void in
            if (ifSuccess) {
                success()
            } else {
                failure(error: error)
            }
        }
    }
    
    func getFeed(success: ([PFObject]) -> (), failure: (NSError) -> ()) {
        var query = PFQuery(className:TablePhoto.ClassName)
        query.limit = 20
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    success(objects)
                }
            } else {
                failure(error)
            }
        }
    }
    
    // MARK: - Table User
    
    func getUsers(success: ([PFUser]) -> (), failure: (NSError) -> ()) {
        var query = PFUser.query()
        query.limit = 20
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                if let objects = objects as? [PFUser] {
                    success(objects)
                }
            } else {
                failure(error)
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