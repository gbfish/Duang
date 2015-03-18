//
//  LandingViewController.swift
//  Duang
//
//  Created by David Yu on 15/3/11.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import UIKit
//import Parse

class LandingViewController: UIViewController, LoginViewControllerProtocol {

    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Duang"
//        login("gbfish", password: "801023")
//        
//        dynamicAnimator = UIDynamicAnimator(referenceView: view)
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBarStyle()
        
        if APIManager.sharedInstance.isCurrentUser {
            loginSuccess()
        }
    }
    
    
    
    // MARK: - LoginViewControllerProtocol
    
    func loginSuccess() {
        performSegueWithIdentifier("mainView", sender: nil)
    }
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("prepareForSegue")
        
        if let identifier = segue.identifier {
            switch identifier {
            case "login":
                if let destination = segue.destinationViewController as? LoginViewController {
                    destination.delegate = self
                }
            default:
                break
            }
        }
        
    }
    
    /*
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        checkButtons()
    }
    
    // MARK: - Dynamic Animation
    
    var snapBehavior: UISnapBehavior!
    var dynamicAnimator: UIDynamicAnimator!
    
//    func animationCleanUp() {
//        if (snapBehavior != nil) {
//            dynamicAnimator.removeBehavior(snapBehavior)
//        }
//        snapBehavior = UISnapBehavior(item: usernameView, snapToPoint: Point.Bottom)
//        dynamicAnimator.addBehavior(snapBehavior)
//        
//        snapBehavior = UISnapBehavior(item: passwordView, snapToPoint: Point.Bottom)
//        dynamicAnimator.addBehavior(snapBehavior)
//    }
    
    func animationLogin() {
        if (snapBehavior != nil) {
            dynamicAnimator.removeBehavior(snapBehavior)
        }
        snapBehavior = UISnapBehavior(item: titleView, snapToPoint: Point.Number1)
        dynamicAnimator.addBehavior(snapBehavior)
        
        snapBehavior = UISnapBehavior(item: usernameView, snapToPoint: Point.Number2)
        dynamicAnimator.addBehavior(snapBehavior)
        
        snapBehavior = UISnapBehavior(item: passwordView, snapToPoint: Point.Number3)
        dynamicAnimator.addBehavior(snapBehavior)
        
        snapBehavior = UISnapBehavior(item: emailView, snapToPoint: Point.BottomNone)
        dynamicAnimator.addBehavior(snapBehavior)
        
        snapBehavior = UISnapBehavior(item: loginButton, snapToPoint: Point.Number4)
        dynamicAnimator.addBehavior(snapBehavior)
        
        snapBehavior = UISnapBehavior(item: signupButton, snapToPoint: Point.Bottom)
        dynamicAnimator.addBehavior(snapBehavior)
        
        
    }
    
    func animationSignup() {
        if (snapBehavior != nil) {
            dynamicAnimator.removeBehavior(snapBehavior)
        }
        snapBehavior = UISnapBehavior(item: titleView, snapToPoint: Point.Number1)
        dynamicAnimator.addBehavior(snapBehavior)
        
        snapBehavior = UISnapBehavior(item: usernameView, snapToPoint: Point.Number2)
        dynamicAnimator.addBehavior(snapBehavior)
        
        snapBehavior = UISnapBehavior(item: passwordView, snapToPoint: Point.Number3)
        dynamicAnimator.addBehavior(snapBehavior)
        
        snapBehavior = UISnapBehavior(item: emailView, snapToPoint: Point.Number4)
        dynamicAnimator.addBehavior(snapBehavior)
        
        snapBehavior = UISnapBehavior(item: loginButton, snapToPoint: Point.Bottom)
        dynamicAnimator.addBehavior(snapBehavior)
        
        snapBehavior = UISnapBehavior(item: signupButton, snapToPoint: Point.Number5)
        dynamicAnimator.addBehavior(snapBehavior)
    }
    
    // MARK: - View Controller State
    
    enum ViewControllerState {
        case Login
        case Signup
    }
    
    func checkButtons() {
        var buttonRectUp = CGRectMake(Button.Spacing, DuangGlobal.screenHeight - ((Button.Spacing + Button.Height) * 2), DuangGlobal.screenWidth - (Button.Spacing * 2), Button.Height)
        let buttonRectDown = CGRectMake(Button.Spacing, DuangGlobal.screenHeight - Button.Spacing - Button.Height, DuangGlobal.screenWidth - (Button.Spacing * 2), Button.Height)
        /*
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
        }*/
    }
    
    var viewControllerState: ViewControllerState = ViewControllerState.Login
        {
        didSet {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.checkButtons()
            })
            
            
//            view.setNeedsLayout()
//            checkButtons()
            
            
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
    
    // MARK: - Input View
    
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var emailView: UIView!
    
    private struct Point {
        static let Number1 = CGPointMake(DuangGlobal.screenWidth / 2, 94.0)
        static let Number2 = CGPointMake(DuangGlobal.screenWidth / 2, 94.0 + 40.0)
        static let Number3 = CGPointMake(DuangGlobal.screenWidth / 2, 94.0 + (40.0 * 2))
        static let Number4 = CGPointMake(DuangGlobal.screenWidth / 2, 94.0 + (40.0 * 3))
        static let Number5 = CGPointMake(DuangGlobal.screenWidth / 2, 94.0 + (40.0 * 4))
        static let Bottom = CGPointMake(DuangGlobal.screenWidth / 2, DuangGlobal.screenHeight - 30.0)
        static let BottomNone = CGPointMake(DuangGlobal.screenWidth / 2, DuangGlobal.screenHeight + 20.0)
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
        animationLogin()
        
        /*
        if viewControllerState == ViewControllerState.Signup {
            viewControllerState = ViewControllerState.Login
        } else {
//            animationCleanUp()
            
           
            animationLogin()
        }*/
    }
    
    @IBOutlet weak var signupButton: UIButton! {
        didSet {
            signupButton.setButtonStyleUnselected()
        }
    }
    
    @IBAction func signupButtonAction(sender: UIButton) {
        animationSignup()
        /*
        if viewControllerState == ViewControllerState.Login {
            viewControllerState = ViewControllerState.Signup
        } else {
            animationSignup()
        }*/
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
*/
}
