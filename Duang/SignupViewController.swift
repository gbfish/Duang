//
//  SignupViewController.swift
//  Duang
//
//  Created by David Yu on 15/3/13.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Sign up"
    }

    // MARK: - UITextField
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField === usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField === passwordTextField {
            emailTextField.becomeFirstResponder()
        } else if textField === emailTextField {
            textField.resignFirstResponder()
            signup()
        }
        return true
    }

    // MARK: - Signup Button
    
    @IBAction func signupButtonAction(sender: UIButton) {
        signup()
    }
    
    // MARK: - Signup
    
    func signup() {
        let userName = usernameTextField.text
        let password = passwordTextField.text
        let email = emailTextField.text
        
        if userName == "" {
            var deleteAlert = UIAlertController(title: "Sorry", message: "User name is empty.", preferredStyle: UIAlertControllerStyle.Alert)
            deleteAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            }))
            presentViewController(deleteAlert, animated: true, completion: nil)
        } else if password == "" {
            var deleteAlert = UIAlertController(title: "Sorry", message: "Password is empty.", preferredStyle: UIAlertControllerStyle.Alert)
            deleteAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            }))
            presentViewController(deleteAlert, animated: true, completion: nil)
        } else if !APIManager.sharedInstance.validateEmail(email) {
            var deleteAlert = UIAlertController(title: "Sorry", message: "That email address is not valid.", preferredStyle: UIAlertControllerStyle.Alert)
            deleteAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            }))
            presentViewController(deleteAlert, animated: true, completion: nil)
        } else {

            
            APIManager.sharedInstance.signup(userName, password: password, email: email, success: { () -> () in
                self.signupSuccess()
            }, failure: { (error) -> () in
                self.signupFailure(error)
            })
        }
    }
    
    func signupSuccess() {
        println("login success")
    }
    
    func signupFailure(error: NSError) {
        var errorString = "There was a problem processing your request."
        if let userInfo = error.userInfo as? [NSObject: NSObject] {
            if let errorInfoString: NSString = userInfo["error"] as? NSString {
                
                errorString = errorInfoString
            }
        }
        
        
        
        
        var deleteAlert = UIAlertController(title: "Sorry", message: "\(errorString)", preferredStyle: UIAlertControllerStyle.Alert)
        deleteAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
        }))
        presentViewController(deleteAlert, animated: true, completion: nil)
    }
}
