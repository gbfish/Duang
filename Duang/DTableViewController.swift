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
    func protocolLogInSuccess()
}

class DTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DTableViewControllerProtocol, DTableViewModelProtocol, DTableViewCellButtonsProtocol, DTableViewCellTextFieldProtocol, DTableViewCellTextViewProtocol
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
        showMainTabBarController()
    }
    
    func protocolLogInSuccess() {
        showMainTabBarController()
    }
    
    
    
    // MARK: - DTableViewModel
    
    var dTableViewModel = DTableViewModel()
    
    // MARK: DTableViewModelProtocol
    
    func dataDidLoad() {
        title = dTableViewModel.viewControllerTitle
        tableView.reloadData()
        
        switch dTableViewModel.tableType {
        case .Landing:
            if APIManager.sharedInstance.isCurrentUserAuthenticated {
                showMainTabBarController()
            }
        default:
            break
        }
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
                
            case .Detail(let image, let imageFile, let isRound, let detailTitle, let detailButton):
                if let cell = tableView.dequeueReusableCellWithIdentifier(modelRow.cellIdentifier(), forIndexPath: indexPath) as? DTableViewCellDetail {
//                    cell.delegate = self
                    cell.detailText = detailTitle
                    
                    cell.detailImage = image
                    cell.detailImageFile = imageFile
                    cell.detailImageIsRound = isRound

                    cell.buttonItem = detailButton
                    
                    cell.reloadView()
                    return cell
                }
                
            case .Label(let text, let font):
                if let cell = tableView.dequeueReusableCellWithIdentifier(modelRow.cellIdentifier(), forIndexPath: indexPath) as? DTableViewCellLabel {
                    cell.cellLabelText = text
                    cell.cellLabelFont = font
                    cell.reloadView()
                    return cell
                }
                
            case .TextView(_, let textViewTitle, let textViewText, let textViewTitleWidth):
                if let cell = tableView.dequeueReusableCellWithIdentifier(modelRow.cellIdentifier(), forIndexPath: indexPath) as? DTableViewCellTextView {
                    cell.delegate = self
                    cell.textViewTitle = textViewTitle
                    cell.textViewText = textViewText
                    cell.textViewTitleWidth = textViewTitleWidth
                    cell.reloadView()
                    addTextView(cell, modelRow: modelRow)
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
    
    // MARK: - Cell DTableViewCellTextField
    
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
    
    func getTextArray() -> [String] {
        textFieldIfGoNext = false
        textFieldFirstResponder.cellTextField.resignFirstResponder()
        
        var textArray = [String]()
        for var index = 0; index < textFieldModelRowArray.count; ++index {
            switch textFieldModelRowArray[index].rowType {
            case .TextField(_, let textFieldText, _):
                textArray.append(textFieldText ?? "")
            default:
                break
            }
        }
        return textArray
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
    
    // MARK: - Cell DTableViewCellTextView
    
    var textViewArray = [DTableViewCellTextView]()
    var textViewModelRowArray = [DTableViewModelRow]()
    
    func addTextView(textView: DTableViewCellTextView, modelRow: DTableViewModelRow) {
        for temTextView in textViewArray {
            if temTextView == textView {
                return
            }
        }
        textViewArray.append(textView)
        textViewModelRowArray.append(modelRow)
    }
    
    // MARK: DTableViewCellTextViewProtocol
    
    func dTableViewCellTextViewCellHeight(dTableViewCellTextView: DTableViewCellTextView, newHeightForRow: CGFloat) {
        
        for var index = 0; index < textViewArray.count; ++index {
            if dTableViewCellTextView == textViewArray[index] {
                var modelRow = textViewModelRowArray[index]
                
                switch modelRow.rowType {
                case .TextView(let heightForRow, let textViewTitle, let textViewText, let textViewTitleWidth):
                    if heightForRow != newHeightForRow {
                        modelRow.rowType = DTableViewModelRow.RowType.TextView(heightForRow: newHeightForRow, textViewTitle: textViewTitle, textViewText: textViewText, textViewTitleWidth: textViewTitleWidth)
                        tableView.beginUpdates()
                        tableView.endUpdates()
                    }
                default:
                    break
                }
                
                
            }
        }
    }
    
    // MARK: - Alert
    
    func showAlert(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in }))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - Function
    
    func setDTableViewModelFunctions() {
        switch dTableViewModel.tableType {
        case .Landing:
            dTableViewModel.functionShowSignUp = DTableViewModelRow.Function.Function(argumentCount: 0, function: showSignUp)
            dTableViewModel.functionShowLogIn = DTableViewModelRow.Function.Function(argumentCount: 0, function: showLogIn)
        case .SignUp:
            dTableViewModel.functionSignUp = DTableViewModelRow.Function.Function(argumentCount: 0, function: signUp)
        case .LogIn:
            dTableViewModel.functionLogIn = DTableViewModelRow.Function.Function(argumentCount: 0, function: logIn)
        default:
            break
        }
    }
    
    // MARK: Show ViewController
    
    func showDTableViewController(presentedViewTableType: DTableViewModel.TableType) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DTableViewController") as? DTableViewController {
            viewController.delegate = self
            viewController.dTableViewModel.tableType = presentedViewTableType
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func showSignUp() {
        showDTableViewController(DTableViewModel.TableType.SignUp)
    }
    
    func showLogIn() {
        showDTableViewController(DTableViewModel.TableType.LogIn)
    }
    
    func showMainTabBarController() {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MainTabBarController") as? MainTabBarController {
            navigationController?.presentViewController(viewController, animated: true, completion: nil)
        }
    }
    
    // MARK: SignUp
    
    func signUp() {
        let textArray = getTextArray()
        
        let userName = textArray[0]
        let password = textArray[1]
        let email = textArray[2]
        
        if userName == "" {
            showAlert("Sorry", message: "User name is empty.")
        } else if password == "" {
            showAlert("Sorry", message: "Password is empty.")
        } else if !APIManager.validateEmail(email) {
            showAlert("Sorry", message: "That email address is not valid.")
        } else {
            APIManager.sharedInstance.signup(userName, password: password, email: email, success: { () -> () in
                self.signUpSuccess()
            }, failure: { (error) -> () in
                self.signUpFailure(error)
            })
        }
    }
    
    func signUpSuccess() {
        delegate?.protocolSignUpSuccess()
        navigationController?.popViewControllerAnimated(true)
    }
    
    func signUpFailure(error: NSError?) {
        var errorString = "There was a problem processing your request."
        if let theError = error {
            if let userInfo = theError.userInfo as? [NSObject: NSObject] {
                if let errorInfoString: String = userInfo["error"] as? String {
                    errorString = errorInfoString
                }
            }
        }
        showAlert("Sorry", message: "\(errorString)")
    }
    
    // MARK: LogIn
    
    func logIn() {
        let textArray = getTextArray()
        
        let userName = textArray[0]
        let password = textArray[1]
        
        if userName == "" {
            showAlert("Sorry", message: "User name is empty.")
        } else if password == "" {
            showAlert("Sorry", message: "Password is empty.")
        } else {
            APIManager.sharedInstance.login(userName, password: password, success: { () -> () in
                self.logInSuccess()
            }) { () -> () in
                self.logInFailure()
            }
        }
    }
    
    func logInSuccess() {
        delegate?.protocolLogInSuccess()
        navigationController?.popViewControllerAnimated(true)
    }
    
    func logInFailure() {
        showAlert("Sorry", message: "The user name and password do not match our records.")
    }


}
