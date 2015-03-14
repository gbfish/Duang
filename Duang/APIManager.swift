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
        
//        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (!error) {
//        // Hooray! Let them use the app now.
//        } else {
//        NSString *errorString = [error userInfo][@"error"];
//        // Show the errorString somewhere and let the user try again.
//        }
//        }];
//        
//        PFUser.logInWithUsernameInBackground(userName, password: password) { (user, error) -> Void in
//            if user != nil {
//                success()
//            } else {
//                failure()
//            }
//        }
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