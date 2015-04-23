//
//  DTableViewController.swift
//  Duang
//
//  Created by David Yu on 15/4/21.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import UIKit

protocol DTableViewControllerProtocol
{
    func protocolSignUpSuccess()
}

class DTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DTableViewControllerProtocol, DTableViewModelProtocol, DTableViewCellButtonsProtocol, DTableViewCellTextFieldProtocol
{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dTableViewModel.delegate = self
        
        
        setDTableViewModelFunctions()
        
        dTableViewModel.dataWillLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - DTableViewControllerProtocol
    
    var delegate: DTableViewControllerProtocol?
    
    func protocolSignUpSuccess() {
        println("protocolSignUpSuccess")
        
        showMainTabBarController()
        
//        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DTableViewController") as? DTableViewController {
//            viewController.delegate = self
//            viewController.dTableViewModel.tableType = DTableViewModel.TableType.Landing
//            
//            
//            navigationController?.presentViewController(viewController, animated: true, completion: nil)
//            
////            presentViewController(viewController, animated: true, completion: nil)
//            
////            self.navigationController?.pushViewController(viewController, animated: true)
//        }
        
//        performSegueWithIdentifier("MainTabBar", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("prepareForSegue")
        
        
        
    }
    
    // MARK: - DTableViewModel
    
    var dTableViewModel = DTableViewModel()
    
    // MARK: DTableViewModelProtocol
    
    func dataDidLoad() {
        title = dTableViewModel.viewControllerTitle
        tableView.reloadData()
    }
    
    // MARK: - TableView
    
    @IBOutlet weak var tableView: UITableView!

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dTableViewModel.numberOfSections()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dTableViewModel.numberOfRowsInSection(section)
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dTableViewModel.titleForHeaderInSection(section)
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerFooterView = view as? UITableViewHeaderFooterView {
            headerFooterView.textLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
            headerFooterView.textLabel.text = headerFooterView.textLabel.text?.capitalizedString
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return dTableViewModel.heightForRowAtIndexPath(indexPath)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let modelRow = dTableViewModel.row(indexPath) {
            switch modelRow.rowType {
            case .Buttons(let buttonItemArray):
                if let cell = tableView.dequeueReusableCellWithIdentifier(modelRow.cellIdentifier(), forIndexPath: indexPath) as? DTableViewCellButtons {
                    cell.delegate = self
                    cell.buttonItemArray = buttonItemArray
                    cell.reloadView()
                    return cell
                }
            case .Image(_, let image, let imageFile, _):
                if let cell = tableView.dequeueReusableCellWithIdentifier(modelRow.cellIdentifier(), forIndexPath: indexPath) as? DTableViewCellImage {
                    cell.cellImage = image
                    cell.cellImageFile = imageFile
                    cell.reloadView()
                    return cell
                }
            case .TextField(let textFieldTitle, let textFieldText, let textFieldTitleWidth):
                if let cell = tableView.dequeueReusableCellWithIdentifier(modelRow.cellIdentifier(), forIndexPath: indexPath) as? DTableViewCellTextField {
                    cell.delegate = self
                    cell.cellTitle = textFieldTitle
                    cell.cellText = textFieldText
                    cell.cellTitleWidth = textFieldTitleWidth
                    cell.reloadView()
                    addTextField(cell, modelRow: modelRow)
                    return cell
                }
            default:
                break
            }
        }
        return UITableViewCell()
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
        
//        selectedIndexPath = indexPath
//        duangTableData.sectionArray[indexPath.section].rowArray[indexPath.row].tapAction()
        
        
    }
    
    // MARK: - Cell DTableViewCellButtonsProtocol
    
    func dTableViewCellButtonsAction(buttonItem: DTableViewModelRow.ButtonItem) {
        buttonItem.functionAction()
    }
    
    // MARK: - DTableViewCellTextField
    
    var textFieldArray = [DTableViewCellTextField]()
    var textFieldModelRowArray = [DTableViewModelRow]()
    var textFieldIfGoNext = true
    var textFieldFirstResponder = DTableViewCellTextField()
    
    func addTextField(textField: DTableViewCellTextField, modelRow: DTableViewModelRow) {
        for temTextField in textFieldArray {
            if temTextField == textField {
                return
            }
        }
        textFieldArray.append(textField)
        textFieldModelRowArray.append(modelRow)
    }
    
    // MARK: DTableViewCellTextFieldProtocol
    
    func dTableViewCellTextFieldDidBeginEditing(dTableViewCellTextField: DTableViewCellTextField) {
        textFieldIfGoNext = true
        textFieldFirstResponder = dTableViewCellTextField
    }
    
    func dTableViewCellTextFieldDidEndEditing(dTableViewCellTextField: DTableViewCellTextField) {
        for var index = 0; index < textFieldArray.count; ++index {
            if dTableViewCellTextField == textFieldArray[index] {
                var modelRow = textFieldModelRowArray[index]
                if let theTextFieldText = dTableViewCellTextField.cellTextField.text {
                    switch modelRow.rowType {
                    case .TextField(let textFieldTitle, let textFieldText, let textFieldTitleWidth):
                        modelRow.rowType = DTableViewModelRow.RowType.TextField(textFieldTitle: textFieldTitle, textFieldText: theTextFieldText, textFieldTitleWidth: textFieldTitleWidth)
                    default:
                        break
                    }
                }
                if textFieldIfGoNext && index < textFieldArray.count - 1 {
                    let nextTextField = textFieldArray[index + 1]
                    nextTextField.cellTextField.becomeFirstResponder()
                }
            }
        }
    }
    
    // MARK: - Function
    
    func setDTableViewModelFunctions() {
        switch dTableViewModel.tableType {
        case .Landing:
            dTableViewModel.functionShowSignUp = DTableViewModelRow.Function.Function(argumentCount: 0, function: showSignUp)
            dTableViewModel.functionShowLogIn = DTableViewModelRow.Function.Function(argumentCount: 0, function: showLogIn)
        case .SignUp:
            dTableViewModel.functionSignUp = DTableViewModelRow.Function.Function(argumentCount: 0, function: signUp)
        }
    }
    
    func showSignUp() {
        println("showSignUp")
        
        showDTableViewController(DTableViewModel.TableType.SignUp)
    }
    
    func showLogIn() {
        println("showLogIn")
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showDTableViewController(presentedViewTableType: DTableViewModel.TableType) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DTableViewController") as? DTableViewController {
            viewController.delegate = self
            viewController.dTableViewModel.tableType = presentedViewTableType
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func showMainTabBarController() {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MainTabBarController") as? MainTabBarController {
            navigationController?.presentViewController(viewController, animated: true, completion: nil)
        }
    }
    
    
    
    // MARK: - Signup
    
    func signUp() {
        textFieldIfGoNext = false
        textFieldFirstResponder.cellTextField.resignFirstResponder()
        
        println("signUp")
        
        var textArray = [String]()
        for var index = 0; index < textFieldModelRowArray.count; ++index {
            switch textFieldModelRowArray[index].rowType {
            case .TextField(_, let textFieldText, _):
                textArray.append(textFieldText ?? "")
            default:
                break
            }
        }
        
        let userName = textArray[0]
        let password = textArray[1]
        let email = textArray[2]
        
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
        } else if !APIManager.validateEmail(email) {
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
        delegate?.protocolSignUpSuccess()
        navigationController?.popViewControllerAnimated(true)
    }
    
    func signupFailure(error: NSError?) {
        var errorString = "There was a problem processing your request."
        if let theError = error {
            if let userInfo = theError.userInfo as? [NSObject: NSObject] {
                if let errorInfoString: String = userInfo["error"] as? String {
                    errorString = errorInfoString
                }
            }
        }
        var deleteAlert = UIAlertController(title: "Sorry", message: "\(errorString)", preferredStyle: UIAlertControllerStyle.Alert)
        deleteAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
        }))
        presentViewController(deleteAlert, animated: true, completion: nil)
    }

}
