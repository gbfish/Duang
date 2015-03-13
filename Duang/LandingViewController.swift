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

    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        navigationController?.navigationBar.backgroundColor = DuangColor.NavigationBackground
//        navigationController?.navigationBar.tintColor = DuangColor.Navigation
        
//        dynamicAnimator.addBehavior(snapBehavior)
        
        login("gbfish", password: "801023")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//
        
        setNavigationBarStyle()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        checkButtons()
    }
    
    // MARK: - Dynamic Animation
    
//    @IBOutlet var mainView: UIView!
//    let snapBehavior = UISnapBehavior()
//    
//    lazy var dynamicAnimator: UIDynamicAnimator = {
//        let returnValue = UIDynamicAnimator(referenceView: self.mainView)
//        return returnValue
//    }()
    
    
    
    // MARK: - View Controller State
    
    enum ViewControllerState {
        case Login
        case Signup
    }
    
    func checkButtons() {
        var buttonRectUp = CGRectMake(Button.Spacing, DuangGlobal.screenHeight - ((Button.Spacing + Button.Height) * 2), DuangGlobal.screenWidth - (Button.Spacing * 2), Button.Height)
        let buttonRectDown = CGRectMake(Button.Spacing, DuangGlobal.screenHeight - Button.Spacing - Button.Height, DuangGlobal.screenWidth - (Button.Spacing * 2), Button.Height)
        
        switch viewControllerState {
        case ViewControllerState.Login:
            loginButton.setButtonStyleNormal()
            loginButton.layer.frame = buttonRectUp
//            loginButton.frame = CGRectZero
            
//            UIView.animateWithDuration(1.0, animations: { () -> Void in
//                self.loginButton.layer.transform = CATransform3DMakeScale( -1.0,1.0, 1.0)
//            })
            
            
//            roleview.layer.transform = CATransform3DMakeScale( -1.0,-1.0,1.0);
            
            
            
            signupButton.setButtonStyleUnselected()
            signupButton.layer.frame = buttonRectDown
            
        case ViewControllerState.Signup:
            signupButton.setButtonStyleNormal()
            loginButton.layer.frame = buttonRectDown
//            UIView.animateWithDuration(1.0, animations: { () -> Void in
//                self.loginButton.layer.transform = CATransform3DMakeScale( 1.0,1.0,1.0)
//            })
            
            
            loginButton.setButtonStyleUnselected()
            signupButton.layer.frame = buttonRectUp
        }
    }
    
    var viewControllerState: ViewControllerState = ViewControllerState.Login
        {
        didSet {
            checkButtons()
            
            
//            let buttonRectUp = CGRectMake(Button.Spacing, DuangGlobal.screenHeight - ((Button.Spacing + Button.Height) * 2), DuangGlobal.screenWidth - (Button.Spacing * 2), Button.Height)
//            let buttonRectDown = CGRectMake(Button.Spacing, DuangGlobal.screenHeight - Button.Spacing - Button.Height, DuangGlobal.screenWidth - (Button.Spacing * 2), Button.Height)
//            
//            println("buttonRectUp = \(buttonRectUp)")
//            println("buttonRectDown = \(buttonRectDown)")
//            
////            UIView.animateWithDuration(0.5, animations: { () -> Void in
////                switch self.viewControllerState {
////                case ViewControllerState.Login:
////                    self.loginButton.setButtonStyleNormal()
////                    self.loginButton.frame = buttonRectUp
////                    
////                    self.signupButton.setButtonStyleUnselected()
////                    self.signupButton.frame = buttonRectDown
////                    
////                case ViewControllerState.Signup:
////                    self.signupButton.setButtonStyleNormal()
////                    self.loginButton.frame = buttonRectDown
////                    
////                    self.loginButton.setButtonStyleUnselected()
////                    self.signupButton.frame = buttonRectUp
////                }
////            })
//            
//            switch viewControllerState {
//            case ViewControllerState.Login:
//                loginButton.setButtonStyleNormal()
//                loginButton.frame = buttonRectUp
//                
//                signupButton.setButtonStyleUnselected()
////                signupButton.frame = buttonRectDown
//                
//            case ViewControllerState.Signup:
//                signupButton.setButtonStyleNormal()
//                loginButton.frame = buttonRectDown
//                
//                loginButton.setButtonStyleUnselected()
////                signupButton.frame = buttonRectUp
//            }
        }
    }
    
    // MARK: -
    
    struct Button {
        static let Spacing: CGFloat = 10.0
        static let Height: CGFloat = 40.0
    }
    
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            
            loginButton.setButtonStyleNormal()
        }
    }
    
    @IBAction func loginButtonAction(sender: UIButton) {
        if viewControllerState == ViewControllerState.Signup {
            viewControllerState = ViewControllerState.Login
        } else {
            
        }
    }
    
    @IBOutlet weak var signupButton: UIButton! {
        didSet {
            signupButton.setButtonStyleUnselected()
        }
    }
    
    @IBAction func signupButtonAction(sender: UIButton) {
        if viewControllerState == ViewControllerState.Login {
            viewControllerState = ViewControllerState.Signup
        } else {
            
        }
    }
    
    // MARK: - 
    
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
