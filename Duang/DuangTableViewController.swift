//
//  DuangTableViewController.swift
//  Duang
//
//  Created by David Yu on 15/3/17.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol DuangTableViewControllerProtocol {
    func duangTableViewControllerInput(inputString: NSString)
}

class DuangTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, DuangTableViewControllerProtocol, DuangTableCellInputProtocol , DuangTableCellTextFieldProtocol{

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableType = TableType.Profile
        
        
        
        if tableType == nil {
            tableType = TableType.Profile
        }
        
        
        checkTableType()
        
        title = titleString
    }
    
    
    
    var titleString = ""
    
    // MARK: - Table Type

    enum TableType {
        case Profile
        case ProfileEdit
        case Settings
        case ChangePassword
        case Input
    }
    
    var tableType: TableType?
    
//    var profileEditAvatarImage = UIImage(named: "placeholder_user")
    
    func checkTableType() {
        if let type = tableType {
            switch type {
            case TableType.Profile:// MARK: Profile
                titleString = "Me"
                var row = DuangTableDataRow()
                var section = DuangTableDataSection()
                
                row.rowType = DuangTableDataRow.RowType.UserBig
                row.rowTitleString = APIManager.sharedInstance.getCurrentUserUsername()
                row.didSelectFunc = DuangTableDataRow.DidSelectFunc.Function1(showEditUser)
                
                section.rowArray.append(row)
                duangTableData.sectionArray.append(section)
                section = DuangTableDataSection()

                row = DuangTableDataRow()
                row.rowType = DuangTableDataRow.RowType.DefaultRightDetail
                row.rowTitleString = "Settings"
                row.didSelectFunc = DuangTableDataRow.DidSelectFunc.Function1(showSettings)
                
                section.rowArray.append(row)
                duangTableData.sectionArray.append(section)
                
            case TableType.ProfileEdit:// MARK: ProfileEdit
                titleString = "Edit Profile"
                var row = DuangTableDataRow()
                var section = DuangTableDataSection()
                
                row.rowType = DuangTableDataRow.RowType.UserSmall
                row.rowTitleString = "Profile Picture"
                row.didSelectFunc = DuangTableDataRow.DidSelectFunc.Function1(selectImage)
                row.rowImageFile = APIManager.sharedInstance.currentUserAvatarFile
                
                section.rowArray.append(row)
                duangTableData.sectionArray.append(section)
                
                section = DuangTableDataSection()
                section.sectionTitleForHeader = "Username"
                
                row = DuangTableDataRow()
                row.rowType = DuangTableDataRow.RowType.DefaultRightDetail
                row.rowTitleString = APIManager.sharedInstance.getCurrentUserUsername()
                row.didSelectFunc = DuangTableDataRow.DidSelectFunc.Function1(showInput)
                
                section.rowArray.append(row)
                duangTableData.sectionArray.append(section)
                
                section = DuangTableDataSection()
                section.sectionTitleForHeader = "Password"
                
                row = DuangTableDataRow()
                row.rowType = DuangTableDataRow.RowType.DefaultRightDetail
                row.rowTitleString = "Username"
                row.rowDetailString = APIManager.sharedInstance.getCurrentUserUsername()
                row.didSelectFunc = DuangTableDataRow.DidSelectFunc.Function1(showInput)
                
                section.rowArray.append(row)
                
                duangTableData.sectionArray.append(section)
                
            case TableType.Input:
                titleString = selectedSection.sectionTitleForHeader
                
                // TextField
                duangTableData.sectionArray.append(DuangTableDataSection.initSectionInput(sectionTitleForHeader: ""))
                
                // Done
                duangTableData.sectionArray.append(DuangTableDataSection.initSectionButton(sectionTitleForHeader: "", rowTitleString: "Done", buttonStyle: DuangTableDataRow.ButtonStyle.Nomal, didSelectFunc: DuangTableDataRow.DidSelectFunc.Function1(doneInput)))
                
            case TableType.Settings:
                titleString = "Settings"
                
                // Username
                duangTableData.sectionArray.append(DuangTableDataSection.initSectionDefaultRightDetail(sectionTitleForHeader: "Username", rowTitleString: APIManager.sharedInstance.getCurrentUserUsername(), rowDetailString: "", didSelectFunc: DuangTableDataRow.DidSelectFunc.Function1(showInput)))
                
                // Password
                duangTableData.sectionArray.append(DuangTableDataSection.initSectionDefaultRightDetail(sectionTitleForHeader: "Password", rowTitleString: "Change Password", rowDetailString: "", didSelectFunc: DuangTableDataRow.DidSelectFunc.Function1(showChangePassword)))
                
                // Email
                duangTableData.sectionArray.append(DuangTableDataSection.initSectionDefaultRightDetail(sectionTitleForHeader: "Email", rowTitleString: APIManager.sharedInstance.getCurrentUserEmail(), rowDetailString: "", didSelectFunc: DuangTableDataRow.DidSelectFunc.Function1(showInput)))
                
                // Log out
                duangTableData.sectionArray.append(DuangTableDataSection.initSectionButton(sectionTitleForHeader: "", rowTitleString: "Log out", buttonStyle: DuangTableDataRow.ButtonStyle.Nomal, didSelectFunc: DuangTableDataRow.DidSelectFunc.Function1(logout)))
                
            case TableType.ChangePassword:
                titleString = "Change Password"
                
                // Old Password
                duangTableData.sectionArray.append(DuangTableDataSection.initSectionTextField(sectionTitleForHeader: "Old Password", rowTitleString: "password"))
                
                // New Password
                duangTableData.sectionArray.append(DuangTableDataSection.initSectionTextField(sectionTitleForHeader: "New Password", rowTitleString: "password"))
                
                // Retype Password
                duangTableData.sectionArray.append(DuangTableDataSection.initSectionTextField(sectionTitleForHeader: "Retype Password", rowTitleString: "password"))
                
                // Done
                duangTableData.sectionArray.append(DuangTableDataSection.initSectionButton(sectionTitleForHeader: "", rowTitleString: "Done", buttonStyle: DuangTableDataRow.ButtonStyle.Nomal, didSelectFunc: DuangTableDataRow.DidSelectFunc.Function1(changePasswordDone)))
            }
        }
        
    }

    // MARK: - Did Select Func
    
    func showEditUser() {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DuangTableViewController") as DuangTableViewController
        viewController.tableType = TableType.ProfileEdit
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showSettings() {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DuangTableViewController") as DuangTableViewController
        viewController.tableType = TableType.Settings
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showChangePassword() {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DuangTableViewController") as DuangTableViewController
        viewController.tableType = TableType.ChangePassword
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func changePasswordDone() {
        if duangTableCellTextFieldArray.count == 3 {
            if let oldPassword = duangTableCellTextFieldArray[0].textField.text {
                if let newPassword = duangTableCellTextFieldArray[1].textField.text {
                    if let retypePassword = duangTableCellTextFieldArray[2].textField.text {
                        
                        if newPassword == retypePassword {
                            
                            if let errorString = APIManager.sharedInstance.changePassword(oldPassword, newPassword: newPassword) {
                                var deleteAlert = UIAlertController(title: "Sorry", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                                deleteAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in }))
                                presentViewController(deleteAlert, animated: true, completion: nil)
                            } else {
                                navigationController?.popViewControllerAnimated(true)
                            }
                        } else {
                            var deleteAlert = UIAlertController(title: "Sorry", message: "New password don't match.", preferredStyle: UIAlertControllerStyle.Alert)
                            deleteAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in }))
                            presentViewController(deleteAlert, animated: true, completion: nil)
                        }
                    }
                }
            }
            
            
            
        }
        
        
    }
    
    func selectImage() {
        var deleteAlert = UIAlertController(title: "Photo", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        deleteAlert.addAction(UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            self.takePhoto()
        }))
        deleteAlert.addAction(UIAlertAction(title: "Choose Existing Photo", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            self.choosePhoto()
        }))
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
        }))
        presentViewController(deleteAlert, animated: true, completion: nil)
    }
    
    func tapAction() {
        println("tapAction")
    }
    
    func tapAction2() {
        println("tapAction2")
    }
    
    // MARK: Input
    
    var duangTableCellInput = DuangTableCellInput()
    
    func showInput() {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DuangTableViewController") as DuangTableViewController
        viewController.delegate = self
        viewController.tableType = TableType.Input
        viewController.selectedSection = selectedSection
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func doneInput() {
        if let inputString = duangTableCellInput.inputTextView.text {
            delegate?.duangTableViewControllerInput(inputString)
        }
        navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: Log out
    
    func logout() {
        APIManager.sharedInstance.logout()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Camera
    
    var imagePickerController: UIImagePickerController?
    
    func takePhoto() {
        if isCameraAvailable() && doesCameraSupportTakingPhotos() {
            imagePickerController = UIImagePickerController()
            if let theController = imagePickerController {
                theController.sourceType = UIImagePickerControllerSourceType.Camera
                theController.mediaTypes = [kUTTypeImage as String]
                theController.allowsEditing = true
                theController.delegate = self
                
                presentViewController(theController, animated: true, completion: nil)
            }
        } else {
            println("Camera is not available")
        }
    }
    
    func choosePhoto() {
        imagePickerController = UIImagePickerController()
        if let theController = imagePickerController {
            theController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            theController.mediaTypes = [kUTTypeImage as String]
            theController.allowsEditing = true
            theController.delegate = self
            
            presentViewController(theController, animated: true, completion: nil)
        }
    }
    
    func loadImagePickerController(isTakePhoto: Bool) {
        if isCameraAvailable() && doesCameraSupportTakingPhotos() {
            imagePickerController = UIImagePickerController()
            if let theController = imagePickerController {
                if isTakePhoto {
                    theController.sourceType = UIImagePickerControllerSourceType.Camera
                } else {
                    theController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                }
                theController.mediaTypes = [kUTTypeImage as String]
                theController.allowsEditing = true
                theController.delegate = self
                
                presentViewController(theController, animated: true, completion: nil)
            }
        } else {
            println("Camera is not available")
        }
    }
    
    func isCameraAvailable() -> Bool{
        return UIImagePickerController.isSourceTypeAvailable(.Camera)
    }
    
    func doesCameraSupportTakingPhotos() -> Bool{
        return cameraSupportsMedia(kUTTypeImage as String, sourceType: .Camera)
    }
    
    func cameraSupportsMedia(mediaType: String, sourceType: UIImagePickerControllerSourceType) -> Bool {
        let availableMediaTypes = UIImagePickerController.availableMediaTypesForSourceType(sourceType) as [String]?
        if let types = availableMediaTypes {
            for type in types{
                if type == mediaType{
                    return true
                }
            }
        }
        return false
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let mediaType:AnyObject? = info[UIImagePickerControllerMediaType]
        
        if let type:AnyObject = mediaType {
            if type is String{
                let stringType = type as String
                
                if stringType == kUTTypeMovie as String{
                    let urlOfVideo = info[UIImagePickerControllerMediaURL] as? NSURL
                    if let url = urlOfVideo{
                        println("Video URL = \(url)")
                    }
                } else if stringType == kUTTypeImage as String {
                    if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                        handleImage(image)
                    }
                }
            }
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Handle Image
    
    func handleImage (image: UIImage) {
        if let type = tableType {
            switch type {
            case TableType.ProfileEdit:
                APIManager.sharedInstance.currentUserAvatar = image
                
                selectedSection.rowArray[0].rowImageFile = APIManager.sharedInstance.currentUserAvatarFile
                tableView.reloadData()
            default:
                break
            }
        }
    }

    // MARK: - TableView Data
    
    var duangTableData = DuangTableData()
    
    
    
    // MARK: - TableView
    
    @IBOutlet weak var tableView: UITableView!
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return duangTableData.sectionArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return duangTableData.sectionArray[section].rowArray.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return duangTableData.sectionArray[section].sectionTitleForHeader
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerFooterView = view as? UITableViewHeaderFooterView {
            headerFooterView.textLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
            headerFooterView.textLabel.text = headerFooterView.textLabel.text?.capitalizedString
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let row = duangTableData.sectionArray[indexPath.section].rowArray[indexPath.row]
        switch row.rowType {
        case DuangTableDataRow.RowType.UserBig:
            return 100.0
        case DuangTableDataRow.RowType.UserSmall:
            return 50.0
        case DuangTableDataRow.RowType.Input:
            return 200.0
        case DuangTableDataRow.RowType.TextField:
            return 50.0
        case DuangTableDataRow.RowType.Button:
            return 50.0
        case DuangTableDataRow.RowType.DefaultRightDetail:
            return 50.0
        }
    }
    
    private struct CellIdentifier {
        static let UserBig = "DuangTableCellUserBig"
        static let UserSmall = "DuangTableCellUserSmall"
        static let Input = "DuangTableCellInput"
        static let Button = "DuangTableCellButton"
        static let TextField = "DuangTableCellTextField"
        static let DefaultCell = "DefaultCell"
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let row = duangTableData.sectionArray[indexPath.section].rowArray[indexPath.row]
        switch row.rowType {
        case DuangTableDataRow.RowType.UserBig:
            let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.UserBig, forIndexPath: indexPath) as DuangTableCellUserBig
            cell.userAvatarImageView.image = UIImage(named: "placeholder_user")
            cell.userNameLabel.text = row.rowTitleString
            return cell
            
        case DuangTableDataRow.RowType.UserSmall:
            let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.UserSmall, forIndexPath: indexPath) as DuangTableCellUserSmall
            cell.userAvatarImageView.layer.cornerRadius = cell.userAvatarImageView.frame.size.height / 2.0
            cell.imageFile = row.rowImageFile
            cell.userNameLabel.text = row.rowTitleString
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            
            cell.reloadView()
            return cell
            
        case DuangTableDataRow.RowType.Input:
            duangTableCellInput = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.Input, forIndexPath: indexPath) as DuangTableCellInput
            duangTableCellInput.delegate = self
            duangTableCellInput.inputTextView.text = selectedSection.rowArray[0].rowTitleString
            return duangTableCellInput
            
        case DuangTableDataRow.RowType.TextField:
            let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.TextField, forIndexPath: indexPath) as DuangTableCellTextField
            cell.delegate = self
            cell.textField.placeholder = row.rowTitleString
            addDuangTableCellTextField(cell)
            return cell
            
        case DuangTableDataRow.RowType.Button:
            let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.Button, forIndexPath: indexPath) as DuangTableCellButton
            cell.buttonLabel.text = row.rowTitleString
            cell.buttonLabel.textColor = row.buttonTextColor
            cell.buttonLabel.backgroundColor = row.buttonBackgroundColor
            return cell
            
        case DuangTableDataRow.RowType.DefaultRightDetail:
            var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: CellIdentifier.DefaultCell)
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.textLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
            cell.textLabel?.text = row.rowTitleString
            cell.detailTextLabel?.text = row.rowDetailString
            return cell
        }
    }
    
    var selectedSection = DuangTableDataSection()
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
        
        selectedSection = duangTableData.sectionArray[indexPath.section]
        
        let didSelectFunc = duangTableData.sectionArray[indexPath.section].rowArray[indexPath.row].didSelectFunc
        switch didSelectFunc {
        case DuangTableDataRow.DidSelectFunc.Nothing:
            println("Nothing")
        case let DuangTableDataRow.DidSelectFunc.Function1(didSelectFuncAction):
            didSelectFuncAction()
        default:
            break
        }
        
    }
    
    // MARK: - DuangTableViewControllerProtocol
    
    var delegate: DuangTableViewControllerProtocol?
    
    func duangTableViewControllerInput(inputString: NSString) {
        if let type = tableType {
            switch type {
            case TableType.Settings:
                if selectedSection.sectionTitleForHeader == "Username" {
                    if let errorString = APIManager.sharedInstance.setCurrentUserUsername(inputString) {
                        var deleteAlert = UIAlertController(title: "Sorry", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                        deleteAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in }))
                        presentViewController(deleteAlert, animated: true, completion: nil)
                    } else {
                        selectedSection.rowArray[0].rowTitleString = inputString
                        tableView.reloadData()
                    }
                } else if selectedSection.sectionTitleForHeader == "Email" {
                    if let errorString = APIManager.sharedInstance.setCurrentUserEmail(inputString) {
                        var deleteAlert = UIAlertController(title: "Sorry", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                        deleteAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in }))
                        presentViewController(deleteAlert, animated: true, completion: nil)
                    } else {
                        selectedSection.rowArray[0].rowTitleString = inputString
                        tableView.reloadData()
                    }
                }
            default:
                break
            }
        }
    }
    
    // MARK: - DuangTableCellInputProtocol
    
    func duangTableCellInputDoneAction() {
        doneInput()
    }
    
    // MARK: - DuangTableCellTextFieldProtocol
    
    var duangTableCellTextFieldArray = [DuangTableCellTextField]()
    
    func addDuangTableCellTextField(duangTableCellTextField: DuangTableCellTextField) {
        for temDuangTableCellTextField in duangTableCellTextFieldArray {
            if temDuangTableCellTextField == duangTableCellTextField {
                return
            }
        }
        duangTableCellTextFieldArray.append(duangTableCellTextField)
    }
    
    func duangTableCellTextFieldReturn(duangTableCellTextField: DuangTableCellTextField) {
        duangTableCellTextField.textField.resignFirstResponder()
        
        for var index = 0; index < duangTableCellTextFieldArray.count; ++index {
            let temDuangTableCellTextField = duangTableCellTextFieldArray[index]
            if temDuangTableCellTextField == duangTableCellTextField && index < duangTableCellTextFieldArray.count - 1 {
                let nextDuangTableCellTextField = duangTableCellTextFieldArray[index + 1]
                nextDuangTableCellTextField.textField.becomeFirstResponder()
            }
        }
    }
}
