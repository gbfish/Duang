//
//  LoginViewController.swift
//  Duang
//
//  Created by David Yu on 15/3/13.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import UIKit

protocol LoginViewControllerProtocol {
    func loginSuccess()
}

class LoginViewController: UIViewController {

    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Log in"
    }
    
    // MARK: - Protocol
    
    var delegate: LoginViewControllerProtocol?
    
    // MARK: - UITextField
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField === usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField === passwordTextField {
            textField.resignFirstResponder()
            login()
        }
        return true
    }
    
    // MARK: - Login Button
    
    @IBAction func loginButtonAction(sender: UIButton) {
        login()
    }
    
    // MARK: - Login
    
    func login() {
        let userName = usernameTextField.text
        let password = passwordTextField.text
        
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
        } else {
            APIManager.sharedInstance.login(userName, password: password, success: { () -> () in
                self.loginSuccess()
                }) { () -> () in
                self.loginFailure()
            }
        }
    }
    
    func loginSuccess() {
        delegate?.loginSuccess()
        println("login success")
    }
    
    func loginFailure() {
        var deleteAlert = UIAlertController(title: "Sorry", message: "The user name and password do not match our records.", preferredStyle: UIAlertControllerStyle.Alert)
        deleteAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
        }))
        presentViewController(deleteAlert, animated: true, completion: nil)
    }
}
