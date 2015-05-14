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
            if let errorInfoString: String = userInfo["error"] as? String {
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
            
            relation.query()?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if error == nil {
                    var returnValue = [PFFile]()
                    if let theObjects = objects {
                        for object in theObjects {
                            if let file = object[TablePhoto.Image] as? PFFile {
                                returnValue.append(file)
                            }
                        }
                        success(returnValue)
                    }
                }
            })
        }
    }
    
    class func getFileFromObject(object: PFObject, key: String) -> PFFile? {
        if let returnValue = object[key] as? PFFile {
            return returnValue
        }
        return nil
    }
    
    class func getUserFromObject(object: PFObject?, key: String) -> PFUser? {
        if let theObject = object {
            if let returnValue = theObject[key] as? PFUser {
                return returnValue
            }
        }
        return nil
    }
    
    class func getObjectFromObject(object: PFObject?, key: String) -> PFObject? {
        if let theObject = object {
            if let returnValue = theObject[key] as? PFObject {
                return returnValue
            }
        }
        return nil
    }
    
    class func fetchImageFromFile(file: PFFile?, success: (UIImage) -> ()) -> () {
        if let theFile = file {
            theFile.getDataInBackgroundWithBlock { (imageData, error) -> Void in
                if error == nil {
                    if let theImageData = imageData, image = UIImage(data:theImageData) {
                        success(image)
                    }
                }
            }
        }
    }
    
    // MARK: - Photo
    
    class func getHeightFromPhoto(object: PFObject) -> CGFloat? {
        if let width = object[TablePhoto.ImageWidth] as? CGFloat, height = object[TablePhoto.ImageHeight] as? CGFloat {
            return UIScreen.mainScreen().bounds.width * height / width
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
    
    class func getNameFromUser(user: PFUser?) -> String {
        var returnValue = ""
        if user != nil {
            if let firstName = APIManager.getStringFromUser(user, key: TableUser.FirstName) {
                returnValue = "\(firstName) "
            }
            if let lastName = APIManager.getStringFromUser(user, key: TableUser.LastName) {
                returnValue = "\(returnValue)\(lastName)"
            }
            
        }
        return returnValue
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
    
    func signup(userName: String, password: String, email: String, success: () -> (), failure: (error: NSError?) -> ()) {
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
    
    class func ifCurrentUser(user: PFUser) -> Bool {
        if user == PFUser.currentUser() {
            return true
        } else {
            return false
        }
    }
    
    // MARK: Username
    
    func getCurrentUserUsername() -> String? {
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
    
    func getCurrentUserEmail() -> String? {
        return currentUser.email
    }
    
    func setCurrentUserEmail(email: String) -> String? {
        let oldValue = currentUser.email
        currentUser.email = email
        var error: NSError? = nil
        currentUser.save(&error)
        if let theError = error {
            currentUser.email = oldValue
            currentUser.save()
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
    
    func setCurrentUserDescription(description: String) {
        currentUser[TableUser.Description] = description
        currentUser.saveInBackground()
    }
    
    // MARK: - Table Post
    
    func addPost(title: String, description: String, photoArray: NSArray, success: () -> (), failure: (NSError?) -> ()) {
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
    
    func addPhotoForPost(post: PFObject, photoArray: NSArray, success: () -> (), failure: (NSError?) -> ()) {
        
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
    
    func getPostArray(success: ([PFObject]) -> (), failure: (NSError?) -> ()) {
        var query = PFQuery(className:TablePost.ClassName)
        query.limit = 20
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    success(objects)
                }
            } else {
                failure(error)
            }
        }
    }
    
    func hasLikedPost(post: PFObject, hasLiked: (Bool) -> ()) {
        if let likeQuery = post.relationForKey(TablePost.Like).query(), theCurrentUser = PFUser.currentUser(), theCurrentUserObjectId = theCurrentUser.objectId{
            likeQuery.whereKey(TableUser.Id, equalTo: theCurrentUserObjectId)
            likeQuery.countObjectsInBackgroundWithBlock { (likeCount, error) -> Void in
                if likeCount == 1 {
                    hasLiked(true)
                } else {
                    hasLiked(false)
                }
            }
        }
    }
    /*
    func likePost(post: PFObject) {
        var like = post.relationForKey(TablePost.Like)
        like.addObject(PFUser.currentUser())
        post.saveInBackgroundWithBlock { (objects, error) -> Void in
            like.query().countObjectsInBackgroundWithBlock({ (count, error) -> Void in
                post[TablePost.LikeCount] = NSInteger(count)
                post.saveInBackground()
            })
        }
    }*/
    
    func likePost(post: PFObject, success: () -> ()) {//增加like 表
//        var like = post.relationForKey(TablePost.Like)
//        like.addObject(PFUser.currentUser())
//        post.saveInBackgroundWithBlock { (objects, error) -> Void in
//            like.query().countObjectsInBackgroundWithBlock({ (count, error) -> Void in
//                post[TablePost.LikeCount] = NSInteger(count)
//                post.saveInBackgroundWithBlock({ (finish, error) -> Void in
//                    success()
//                })
//            })
//        }
    }
    /*
    func unlikePost(post: PFObject) {
        var like = post.relationForKey(TablePost.Like)
        like.removeObject(PFUser.currentUser())
        post.saveInBackgroundWithBlock { (objects, error) -> Void in
            like.query().countObjectsInBackgroundWithBlock({ (count, error) -> Void in
                post[TablePost.LikeCount] = NSInteger(count)
                post.saveInBackground()
            })
        }
    }*/
    
    func unlikePost(post: PFObject, success: () -> ()) {//增加like 表
//        var like = post.relationForKey(TablePost.Like)
//        like.removeObject(PFUser.currentUser())
//        post.saveInBackgroundWithBlock { (objects, error) -> Void in
//            like.query().countObjectsInBackgroundWithBlock({ (count, error) -> Void in
//                post[TablePost.LikeCount] = NSInteger(count)
//                post.saveInBackgroundWithBlock({ (finish, error) -> Void in
//                    success()
//                })
//            })
//        }
    }

    
    // MARK: - Table Photo
    
    func addNewPhoto(image: UIImage, description: String, success: () -> (), failure: (error: NSError?) -> ()) {
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
    
    func getPhotoArray(pageSize: Int, page: Int, user: PFUser?, success: ([PFObject]) -> (), failure: (NSError?) -> ()) {
        var query = PFQuery(className: TablePhoto.ClassName)
        query.limit = pageSize
        query.skip = (page - 1) * pageSize
        query.orderByDescending("updatedAt")
        if let theUser = user {
            query.whereKey(TablePhoto.Owner, equalTo: theUser)
        }
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    success(objects)
                }
            } else {
                failure(error)
            }
        }
    }
    
    class func fetchPhotoTotal(user: PFUser, success: (Int32) -> ()) {
        var query = PFQuery(className: TablePhoto.ClassName)

        query.whereKey(TablePhoto.Owner, equalTo: user)
        
        query.countObjectsInBackgroundWithBlock { (countNumber, error) -> Void in
            if error == nil {
                success(countNumber)
            }
        }
    }
    
    // MARK: - Table PhotoLike
    
    class func likePhoto(photo: PFObject) {
        if let user = PFUser.currentUser() {
            let query = PFQuery(className: TablePhotoLike.ClassName)
            query.whereKey(TablePhotoLike.User, equalTo: user)
            query.whereKey(TablePhotoLike.Photo, equalTo: photo)
            query.countObjectsInBackgroundWithBlock { (likeTotal, error) -> Void in
                if likeTotal == 0 {
                    //like
                    var photoLike = PFObject(className:TablePhotoLike.ClassName)
                    photoLike[TablePhotoLike.User] = user
                    photoLike[TablePhotoLike.Photo] = photo
                    photoLike.saveInBackground()
                } else if likeTotal == 1 {
                    //already like
                } else {
                    //something wrong
                    query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                        if error == nil {
                            if let photoLikeArray = objects as? [PFObject] {
                                for photoLike in photoLikeArray {
                                    photoLike.deleteInBackground()
                                }
                            }
                        }
                        var photoLike = PFObject(className:TablePhotoLike.ClassName)
                        photoLike[TablePhotoLike.User] = user
                        photoLike[TablePhotoLike.Photo] = photo
                        photoLike.saveInBackground()
                    })
                }
            }
        }
    }
    
    class func unlikePhoto(photo: PFObject) {
        if let user = PFUser.currentUser() {
            let query = PFQuery(className: TablePhotoLike.ClassName)
            query.whereKey(TablePhotoLike.User, equalTo: user)
            query.whereKey(TablePhotoLike.Photo, equalTo: photo)
            query.countObjectsInBackgroundWithBlock { (likeTotal, error) -> Void in
                if likeTotal != 0 {
                    query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                        if error == nil {
                            if let photoLikeArray = objects as? [PFObject] {
                                for photoLike in photoLikeArray {
                                    photoLike.deleteInBackground()
                                }
                            }
                        }
                    })
                }
            }
        }
    }
    
    class func ifLikePhoto(user: PFUser, photo: PFObject, success: (Bool) -> ()) {
        var query = PFQuery(className: TablePhotoLike.ClassName)
        
        query.whereKey(TablePhotoLike.User, equalTo: user)
        query.whereKey(TablePhotoLike.Photo, equalTo: photo)
        
        query.countObjectsInBackgroundWithBlock { (countNumber, error) -> Void in
            if error == nil {
                if countNumber == 1 {
                    success(true)
                } else {
                    success(false)
                }
            }
        }
    }
    
    class func fetchLikeTotalPhoto(photo: PFObject, success: (Int32) -> ()) {
        var query = PFQuery(className: TablePhotoLike.ClassName)
        
        query.whereKey(TablePhotoLike.Photo, equalTo: photo)
        
        query.countObjectsInBackgroundWithBlock { (countNumber, error) -> Void in
            if error == nil {
                success(countNumber)
            }
        }
    }
    
    class func fetchLikeTotalUser(user: PFUser, success: (Int32) -> ()) {
        var query = PFQuery(className: TablePhotoLike.ClassName)
        
        query.whereKey(TablePhotoLike.User, equalTo: user)
        
        query.countObjectsInBackgroundWithBlock { (countNumber, error) -> Void in
            if error == nil {
                success(countNumber)
            }
        }
    }
    
    class func fetchPhotoArrayLike(pageSize: Int, page: Int, user: PFUser, success: ([PFObject]) -> (), failure: (NSError?) -> ()) {
        var query = PFQuery(className: TablePhotoLike.ClassName)
        query.limit = pageSize
        query.skip = (page - 1) * pageSize
        query.orderByDescending("updatedAt")
        query.whereKey(TablePhotoLike.User, equalTo: user)
        query.findObjectsInBackgroundWithBlock {
            (photoLikeArray, error) -> Void in
            if error == nil {
                if let thePhotoLikeArray = photoLikeArray as? [PFObject] {
                    
                    var photoArray = [PFObject]()
                    
                    for photoLike in thePhotoLikeArray {
                        
                        if let photo = APIManager.getObjectFromObject(photoLike, key: TablePhotoLike.Photo) {
                            photoArray.append(photo)
                        }
                    }
                    
                    success(photoArray)
                }
            } else {
                failure(error)
            }
        }
    }
    
    // MARK: - Table PhotoComment
    
    class func addComment(photo: PFObject, message: String) {
        var comment = PFObject(className:TablePhotoComment.ClassName)
        
        comment[TablePhotoComment.Message] = message
        comment[TablePhotoComment.Photo] = photo
        comment[TablePhotoComment.User] = PFUser.currentUser()
        
        comment.saveInBackground()
    }
    
    class func fetchCommentTotalPhoto(photo: PFObject, success: (Int32) -> ()) {
        var query = PFQuery(className: TablePhotoComment.ClassName)
        query.whereKey(TablePhotoComment.Photo, equalTo: photo)
        query.countObjectsInBackgroundWithBlock { (countNumber, error) -> Void in
            if error == nil {
                success(countNumber)
            }
        }
    }
    
    class func fetchCommentArray(pageSize: Int, page: Int, photo: PFObject, success: ([PFObject]) -> (), failure: (NSError?) -> ()) {
        var query = PFQuery(className: TablePhotoComment.ClassName)
        query.limit = pageSize
        query.skip = (page - 1) * pageSize
        query.orderByDescending("updatedAt")
        query.whereKey(TablePhotoComment.Photo, equalTo: photo)
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
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
    
    func getUsers(success: ([PFUser]) -> (), failure: (NSError?) -> ()) {
        if let query = PFUser.query() {
            query.limit = 20
            query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                if error == nil {
                    if let theObjects = objects as? [PFUser] {
                        success(theObjects)
                    }
                } else {
                    failure(error)
                }
            }
        }
    }
    
    class func fetchUser(user: PFUser, success: (PFUser) -> ()) {
        user.fetchIfNeededInBackgroundWithBlock { (object, error) -> Void in
            if error == nil {
                if let theObject = object as? PFUser {
                    success(theObject)
                }
            }
        }
    }
    
    // MARK: - Table UserFollow
    
    class func ifFollowUser(user: PFUser, success: (Bool) -> ()) {
        if let currentUser = PFUser.currentUser() {
            var query = PFQuery(className: TableUserFollow.ClassName)
            query.whereKey(TableUserFollow.User, equalTo: currentUser)
            query.whereKey(TableUserFollow.UserFollowed, equalTo: user)
            
            query.countObjectsInBackgroundWithBlock { (countNumber, error) -> Void in
                if error == nil {
                    if countNumber == 1 {
                        success(true)
                    } else {
                        success(false)
                    }
                }
            }
        }
    }
    
    // MARK: - Table Comment
    

    
    func addNewComment(post: PFObject, image: UIImage, commentText: String, success: () -> (), failure: (NSError?) -> ()) {
        var comments = post.relationForKey(TablePost.Comments)
        
        var comment = PFObject(className:TableComment.ClassName)
        
        comment[TableComment.Message] = commentText
        comment[TableComment.Owner] = PFUser.currentUser()
        
        let imageData = UIImagePNGRepresentation(image)
        let imageFile = PFFile(name:"image.png", data:imageData)
        comment[TableComment.Image] = imageFile
        comment.save()
        
        comments.addObject(comment)
        post.saveInBackgroundWithBlock { (ifSuccess, error) -> Void in
            if (ifSuccess) {
                success()
            } else {
                failure(error)
            }
        }
    }
    
    // MARK: - Class Function
    
    class func validateEmail(email: NSString) -> Bool {
        if (email.rangeOfString("@").length != 0) && (email.rangeOfString(".").length != 0) {
            let tmpInvalidCharSet = NSCharacterSet.alphanumericCharacterSet().invertedSet as NSCharacterSet
            let tmpInvalidMutableCharSet = tmpInvalidCharSet.mutableCopy() as! NSMutableCharacterSet
            tmpInvalidMutableCharSet.removeCharactersInString("_-")
            
            let range1 = email.rangeOfString("@", options: NSStringCompareOptions.CaseInsensitiveSearch) as NSRange
            
            let userNameString = email.substringToIndex(range1.location) as NSString
            let userNameArray = userNameString.componentsSeparatedByString(".") as NSArray
            for string in userNameArray {
                let rangeOfInavlidChars = string.rangeOfCharacterFromSet(tmpInvalidMutableCharSet) as NSRange
                if rangeOfInavlidChars.length != 0 || string as! NSString == "" {
                    return false
                }
            }
            
            let domainString = email.substringFromIndex(range1.location + 1) as NSString
            let domainArray = domainString.componentsSeparatedByString(".") as NSArray
            for string in domainArray {
                let rangeOfInavlidChars = string.rangeOfCharacterFromSet(tmpInvalidMutableCharSet)
                if rangeOfInavlidChars.length != 0 || string as! NSString == "" {
                    return false
                }
            }
            return true
        } else {
            return false
        }
    }
    
    class func sizeForString(string: String?, font: UIFont, width: CGFloat, height: CGFloat) -> CGSize {
        if let theString = string {
            let attributesDictionary = NSDictionary(object: font, forKey: NSFontAttributeName) as [NSObject : AnyObject]
            let attributedString = NSMutableAttributedString(string: theString, attributes: attributesDictionary)
            let rect = attributedString.boundingRectWithSize(CGSize(width: width, height: height), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
            return rect.size
        } else {
            return CGSizeZero
        }
    }
    
//    class func cellTextViewHeightForRow(string: String?, font: UIFont, width: CGFloat) -> CGFloat {
//        var returnValue: CGFloat = 0
//        
//        
//        if let theString = string {
//            var textView = UITextView()
//            textView.text = theString
//            textView.font = font
//            returnValue = textView.sizeThatFits(CGSizeMake(width, CGFloat.max)).height + (DuangGlobal.spacing * 2)
//        }
//        
//        if returnValue < 50.0 {
//            returnValue = 50.0
//        }
//        return returnValue
//    }
//
//    class func sizeForTextView(string: String?, font: UIFont, width: CGFloat, height: CGFloat) -> CGSize {
//        if let theString = string {
//            var textView = UITextView()
//            textView.text = theString
//            textView.font = font
//            return textView.sizeThatFits(CGSizeMake(width, height))
//        } else {
//            return CGSizeZero
//        }
//    }
    
    class func widthMaxForStrings(stringArray: [String], font: UIFont) -> CGFloat {
        var returnValue: CGFloat = 0.0
        for string in stringArray {
            let stringWidth = APIManager.sizeForString(string, font: font, width: CGFloat.max, height: CGFloat.max).width
            if stringWidth > returnValue {
                returnValue = stringWidth
            }
        }
        return returnValue
    }
}