//
//  LandingViewController.swift
//  Duang
//
//  Created by David Yu on 15/3/11.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import UIKit
import Parse

class LandingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        navigationController?.navigationBar.backgroundColor = DuangColor.NavigationBackground
//        navigationController?.navigationBar.tintColor = DuangColor.Navigation
        
        login("gbfish", password: "801023")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBarStyle()
    }
    
    func login(userName: String, password: String) {
        
        PFUser.logInWithUsernameInBackground(userName, password: password) { (user, error) -> Void in
            if user == nil {
                println("The login failed. Check error to see why.")
            } else {
                println("Do stuff after successful login.")
            }
        }
        
        
        
        
        /*
        let query: PFQuery = PFQuery(className: "_User")
        query.whereKey("username", equalTo: userName)
        query.findObjectsInBackgroundWithBlock { (objectsArray, error) -> Void in
            if (error == nil) {
                println("objectsArray \(objectsArray.count) = \(objectsArray)")
                
                for object in objectsArray {
                    if let user = object as? PFObject {
                        println("user.objectId = \(user.objectId)")
                        let password = user.objectForKey("password") as String
                        println("user.password = \(password)")
                    }
                }
            } else {
                println("Error: \(error)")
            }
        }*/
    }
}
