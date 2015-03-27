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
    func duangTableViewControllerInput(inputString: String)
    func duangTableViewControllerAddPhoto(image: UIImage, description: String)
}

class DuangTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, DuangTableViewControllerProtocol, DuangTableCellInputProtocol , DuangTableCellTextFieldProtocol{

    override func viewDidLoad() {
        super.viewDidLoad()

        if tableType == nil {
            tableType = TableType.Profile
        }
        checkTableType()
        
        title = titleString
    }
    
    var titleString = ""
    
    // MARK: - Table Type

    enum TableType {
        case Feed
        case Users
        case Profile
        case ProfileEdit
        case Settings
        case ChangePassword
        case Input
        case AddPhoto
        case AddPost
    }
    
    var tableType: TableType?
    
    func checkTableType() {
        if let type = tableType {
            var section = DuangTableDataSection()
            switch type {
            case TableType.Feed:// MARK: Feed
                titleString = TabBarTitle.Feed
                
                APIManager.sharedInstance.getPostArray({ (objectArray) -> () in
                    self.setDuangTableDataFromPost(objectArray)
                }, failure: { (error) -> () in
                    println("error = \(error)")
                })
                
                /*
                APIManager.sharedInstance.getFeed({ (objectArray) -> () in
                    self.setDuangTableDataFromPhoto(objectArray)
                }, failure: { (error) -> () in
                    println("error = \(error)")
                })*/
                
            case TableType.Users:// MARK: Users
                titleString = TabBarTitle.Users
                
                APIManager.sharedInstance.getUsers({ (objectArray) -> () in
                    self.setDuangTableDataFromUser(objectArray)
                }, failure: { (error) -> () in
                    println("error = \(error)")
                })
                
            case TableType.Profile:// MARK: Profile
                titleString = TabBarTitle.Profile
                
                // Profile Picture
                section = DuangTableDataSection.initSection(sectionTitleForHeader: "",
                    rowType: DuangTableDataRow.RowType.UserBig,
                    cellHeight: nil,
                    textArray: ["\(APIManager.sharedInstance.getCurrentUserFirstName()) \(APIManager.sharedInstance.getCurrentUserLastName())", APIManager.sharedInstance.getCurrentUserDescription()],
                    imageFileArray: [APIManager.sharedInstance.getCurrentUserAvatarFile(), APIManager.sharedInstance.getCurrentUserBannerFile()],
                    imageArray: nil,
                    colorArray: nil,
                    function: DuangTableDataRow.Function.Function1(showEditUser))
                duangTableData.sectionArray.append(section)
                
                // Add a Photo
                section = DuangTableDataSection.initSection(sectionTitleForHeader: "",
                    rowType: DuangTableDataRow.RowType.Button,
                    cellHeight: nil,
                    textArray: ["Add a Photo"],
                    imageFileArray: nil,
                    imageArray: nil,
                    colorArray: [DuangColor.ButtonNormal, DuangColor.ButtonNormalBackground],
                    function: DuangTableDataRow.Function.Function1(showAddPhoto))
                duangTableData.sectionArray.append(section)
                
                // Setting
                section = DuangTableDataSection.initSection(sectionTitleForHeader: "",
                    rowType: DuangTableDataRow.RowType.DefaultRightDetail,
                    cellHeight: nil,
                    textArray: ["Settings"],
                    imageFileArray: nil,
                    imageArray: nil,
                    colorArray: nil,
                    function: DuangTableDataRow.Function.Function1(showSettings))
                duangTableData.sectionArray.append(section)
                
            case TableType.ProfileEdit:// MARK: ProfileEdit
                titleString = "Edit Profile"
                
                // Profile Picture
                section = DuangTableDataSection.initSection(sectionTitleForHeader: nil,
                    rowType: DuangTableDataRow.RowType.UserSmall,
                    cellHeight: nil,
                    textArray: [TitleName.ImageProfilePicture],
                    imageFileArray: [APIManager.sharedInstance.getCurrentUserAvatarFile()],
                    imageArray: nil,
                    colorArray: nil,
                    function: DuangTableDataRow.Function.Function1(selectImage))
                duangTableData.sectionArray.append(section)
                
                // Banner Picture
                section = DuangTableDataSection.initSection(sectionTitleForHeader: nil,
                    rowType: DuangTableDataRow.RowType.UserSmall,
                    cellHeight: nil,
                    textArray: [TitleName.ImageBannerPicture],
                    imageFileArray: [APIManager.sharedInstance.getCurrentUserBannerFile()],
                    imageArray: nil,
                    colorArray: nil,
                    function: DuangTableDataRow.Function.Function1(selectImage))
                duangTableData.sectionArray.append(section)
                
                // First Name
                section = DuangTableDataSection.initSection(sectionTitleForHeader: TitleName.InputFirstName,
                    rowType: DuangTableDataRow.RowType.DefaultRightDetail,
                    cellHeight: nil,
                    textArray: [APIManager.sharedInstance.getCurrentUserFirstName()],
                    imageFileArray: nil,
                    imageArray: nil,
                    colorArray: nil,
                    function: DuangTableDataRow.Function.Function1(showInput))
                duangTableData.sectionArray.append(section)
                
                // Last Name
                section = DuangTableDataSection.initSection(sectionTitleForHeader: TitleName.InputLastName,
                    rowType: DuangTableDataRow.RowType.DefaultRightDetail,
                    cellHeight: nil,
                    textArray: [APIManager.sharedInstance.getCurrentUserLastName()],
                    imageFileArray: nil,
                    imageArray: nil,
                    colorArray: nil,
                    function: DuangTableDataRow.Function.Function1(showInput))
                duangTableData.sectionArray.append(section)
                
                // Description
                section = DuangTableDataSection.initSection(sectionTitleForHeader: TitleName.InputAboutYou,
                    rowType: DuangTableDataRow.RowType.DefaultRightDetail,
                    cellHeight: nil,
                    textArray: [APIManager.sharedInstance.getCurrentUserDescription()],
                    imageFileArray: nil,
                    imageArray: nil,
                    colorArray: nil,
                    function: DuangTableDataRow.Function.Function1(showInput))
                duangTableData.sectionArray.append(section)
                
            case TableType.Input:// MARK: Input
                if let text = inputTitle {
                    titleString = text
                }
                
                // TextField
                section = DuangTableDataSection.initSection(sectionTitleForHeader: nil,
                    rowType: DuangTableDataRow.RowType.Input,
                    cellHeight: nil,
                    textArray: nil,
                    imageFileArray: nil,
                    imageArray: nil,
                    colorArray: nil,
                    function: nil)
                duangTableData.sectionArray.append(section)
                
                // Done
                section = DuangTableDataSection.initSection(sectionTitleForHeader: nil,
                    rowType: DuangTableDataRow.RowType.Button,
                    cellHeight: nil,
                    textArray: ["Done"],
                    imageFileArray: nil,
                    imageArray: nil,
                    colorArray: [DuangColor.ButtonNormal, DuangColor.ButtonNormalBackground],
                    function: DuangTableDataRow.Function.Function1(doneInput))
                duangTableData.sectionArray.append(section)
                
            case TableType.Settings:// MARK: Settings
                titleString = "Settings"
                
                // Username
                section = DuangTableDataSection.initSection(sectionTitleForHeader: TitleName.InputUsername,
                    rowType: DuangTableDataRow.RowType.DefaultRightDetail,
                    cellHeight: nil,
                    textArray: [APIManager.sharedInstance.getCurrentUserUsername()],
                    imageFileArray: nil,
                    imageArray: nil,
                    colorArray: nil,
                    function: DuangTableDataRow.Function.Function1(showInput))
                duangTableData.sectionArray.append(section)
                
                // Password
                section = DuangTableDataSection.initSection(sectionTitleForHeader: "Password",
                    rowType: DuangTableDataRow.RowType.DefaultRightDetail,
                    cellHeight: nil,
                    textArray: ["Change Password"],
                    imageFileArray: nil,
                    imageArray: nil,
                    colorArray: nil,
                    function: DuangTableDataRow.Function.Function1(showChangePassword))
                duangTableData.sectionArray.append(section)
                
                // Email
                section = DuangTableDataSection.initSection(sectionTitleForHeader: TitleName.InputEmail,
                    rowType: DuangTableDataRow.RowType.DefaultRightDetail,
                    cellHeight: nil,
                    textArray: [APIManager.sharedInstance.getCurrentUserEmail()],
                    imageFileArray: nil,
                    imageArray: nil,
                    colorArray: nil,
                    function: DuangTableDataRow.Function.Function1(showInput))
                duangTableData.sectionArray.append(section)
                
                // Log out
                section = DuangTableDataSection.initSection(sectionTitleForHeader: nil,
                    rowType: DuangTableDataRow.RowType.Button,
                    cellHeight: nil,
                    textArray: ["Log out"],
                    imageFileArray: nil,
                    imageArray: nil,
                    colorArray: [DuangColor.ButtonNormal, DuangColor.ButtonNormalBackground],
                    function: DuangTableDataRow.Function.Function1(logout))
                duangTableData.sectionArray.append(section)
                
            case TableType.ChangePassword:// MARK: ChangePassword
                titleString = "Change Password"
                
                // Old Password
                section = DuangTableDataSection.initSection(sectionTitleForHeader: "Old Password",
                    rowType: DuangTableDataRow.RowType.TextField,
                    cellHeight: nil,
                    textArray: ["password"],
                    imageFileArray: nil,
                    imageArray: nil,
                    colorArray: nil,
                    function: nil)
                duangTableData.sectionArray.append(section)
                
                // New Password
                section = DuangTableDataSection.initSection(sectionTitleForHeader: "New Password",
                    rowType: DuangTableDataRow.RowType.TextField,
                    cellHeight: nil,
                    textArray: ["password"],
                    imageFileArray: nil,
                    imageArray: nil,
                    colorArray: nil,
                    function: nil)
                duangTableData.sectionArray.append(section)
                
                // Retype Password
                section = DuangTableDataSection.initSection(sectionTitleForHeader: "Retype Password",
                    rowType: DuangTableDataRow.RowType.TextField,
                    cellHeight: nil,
                    textArray: ["password"],
                    imageFileArray: nil,
                    imageArray: nil,
                    colorArray: nil,
                    function: nil)
                duangTableData.sectionArray.append(section)
                
                // Done
                section = DuangTableDataSection.initSection(sectionTitleForHeader: nil,
                    rowType: DuangTableDataRow.RowType.Button,
                    cellHeight: nil,
                    textArray: ["Done"],
                    imageFileArray: nil,
                    imageArray: nil,
                    colorArray: nil,
                    function: DuangTableDataRow.Function.Function1(changePasswordDone))
                duangTableData.sectionArray.append(section)

            case TableType.AddPost:// MARK: AddPost
                titleString = TabBarTitle.AddPost
                
                // Title
                section = DuangTableDataSection.initSection(sectionTitleForHeader: TitleName.AddPostTitle,
                    rowType: DuangTableDataRow.RowType.DefaultRightDetail,
                    cellHeight: nil,
                    textArray: [""],
                    imageFileArray: nil,
                    imageArray: nil,
                    colorArray: nil,
                    function: DuangTableDataRow.Function.Function1(showInput))
                duangTableData.sectionArray.append(section)
                
                // Description
                section = DuangTableDataSection.initSection(sectionTitleForHeader: TitleName.AddPostDescription,
                    rowType: DuangTableDataRow.RowType.DefaultRightDetail,
                    cellHeight: nil,
                    textArray: [""],
                    imageFileArray: nil,
                    imageArray: nil,
                    colorArray: nil,
                    function: DuangTableDataRow.Function.Function1(showInput))
                duangTableData.sectionArray.append(section)
                
                // Add a Photo
                section = DuangTableDataSection.initSection(sectionTitleForHeader: "",
                    rowType: DuangTableDataRow.RowType.Button,
                    cellHeight: nil,
                    textArray: ["Add a Photo"],
                    imageFileArray: nil,
                    imageArray: nil,
                    colorArray: [DuangColor.ButtonNormal, DuangColor.ButtonNormalBackground],
                    function: DuangTableDataRow.Function.Function1(showAddPhoto))
                duangTableData.sectionArray.append(section)
                
                // Done
                section = DuangTableDataSection.initSection(sectionTitleForHeader: nil,
                    rowType: DuangTableDataRow.RowType.Button,
                    cellHeight: nil,
                    textArray: ["Done"],
                    imageFileArray: nil,
                    imageArray: nil,
                    colorArray: nil,
                    function: DuangTableDataRow.Function.Function1(doneAddPost))
                duangTableData.sectionArray.append(section)
                
            case TableType.AddPhoto:// MARK: AddPhoto
                titleString = "Add a Photo"
                
                // Photo
                section = DuangTableDataSection.initSection(sectionTitleForHeader: nil,
                    rowType: DuangTableDataRow.RowType.ImageSmall,
                    cellHeight: nil,
                    textArray: ["Photo"],
                    imageFileArray: nil,
                    imageArray: [APIManager.Placeholder.Image],
                    colorArray: nil,
                    function: DuangTableDataRow.Function.Function1(selectImage))
                duangTableData.sectionArray.append(section)
                
                // Description
                section = DuangTableDataSection.initSection(sectionTitleForHeader: TitleName.InputPhotoDescription,
                    rowType: DuangTableDataRow.RowType.DefaultRightDetail,
                    cellHeight: nil,
                    textArray: [""],
                    imageFileArray: nil,
                    imageArray: nil,
                    colorArray: nil,
                    function: DuangTableDataRow.Function.Function1(showInput))
                duangTableData.sectionArray.append(section)
                
                // Done
                section = DuangTableDataSection.initSection(sectionTitleForHeader: nil,
                    rowType: DuangTableDataRow.RowType.Button,
                    cellHeight: nil,
                    textArray: ["Done"],
                    imageFileArray: nil,
                    imageArray: nil,
                    colorArray: nil,
                    function: DuangTableDataRow.Function.Function1(doneAddPhoto))
                duangTableData.sectionArray.append(section)
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
    
    func showAddPhoto() {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DuangTableViewController") as DuangTableViewController
        viewController.delegate = self
        viewController.tableType = TableType.AddPhoto
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
    
    // MARK: Done
    
    func doneAddPost() {
        var ifShowAlert = true
        var messageString = "Something is wrong"
        
        if let titleString = duangTableData.getString(0, rowIndex: 0, textArrayIndex: 0) {
            if titleString == "" {
                messageString = "The title is empty."
            } else {
                if let descriptionString = duangTableData.getString(1, rowIndex: 0, textArrayIndex: 0) {
                    if descriptionString == "" {
                        messageString = "The description is empty."
                    } else {
                        if temImageArray.count > 0 {
                            
                            ifShowAlert = false
                            
                            var photoArray = [NSMutableDictionary]()
                            
                            for var index = 0; index < temImageArray.count; ++index {
                                var photoDictionary = NSMutableDictionary()
                                photoDictionary.setValue(temImageArray[index], forKey: "photo")
                                photoDictionary.setValue(temTextArray[index], forKey: "description")
                                photoArray.append(photoDictionary)
                            }
                            
                            APIManager.sharedInstance.addPost(titleString, description: descriptionString, photoArray: photoArray, success: { () -> () in
                                println("ok")
                                }, failure: { (error) -> () in
                                    println("not ok")
                            })
                        } else  {
                            messageString = "The photo is empty."
                        }
                    }
                }
            }
        }
        if ifShowAlert {
            var deleteAlert = UIAlertController(title: "Sorry", message: messageString, preferredStyle: UIAlertControllerStyle.Alert)
            deleteAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in }))
            presentViewController(deleteAlert, animated: true, completion: nil)
        }
    }
    
            
            
            
//            if let descriptionString = duangTableData.getString(1, rowIndex: 0, textArrayIndex: 0) {
//                if temImageArray.count > 0 {
//                    
//                    var photoArray = [NSMutableDictionary]()
//                    
//                    for var index = 0; index < temImageArray.count; ++index {
//                        var photoDictionary = NSMutableDictionary()
//                        photoDictionary.setValue(temImageArray[index], forKey: "photo")
//                        photoDictionary.setValue(temTextArray[index], forKey: "description")
//                        photoArray.append(photoDictionary)
//                    }
//                    
//                    APIManager.sharedInstance.addPost(titleString, description: descriptionString, photoArray: photoArray, success: { () -> () in
//                        println("ok")
//                    }, failure: { (error) -> () in
//                        println("not ok")
//                    })
//                } else  {
//                    var deleteAlert = UIAlertController(title: "Sorry", message: "The photo is empty.", preferredStyle: UIAlertControllerStyle.Alert)
//                    deleteAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in }))
//                    presentViewController(deleteAlert, animated: true, completion: nil)
//                }
//            } else {
//                var deleteAlert = UIAlertController(title: "Sorry", message: "The description is empty.", preferredStyle: UIAlertControllerStyle.Alert)
//                deleteAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in }))
//                presentViewController(deleteAlert, animated: true, completion: nil)
//            }
//        } else {
//            var deleteAlert = UIAlertController(title: "Sorry", message: "The title is empty.", preferredStyle: UIAlertControllerStyle.Alert)
//            deleteAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in }))
//            presentViewController(deleteAlert, animated: true, completion: nil)
//        }
//    }
    
    func doneAddPhoto() {
        if temImage == nil {
            var deleteAlert = UIAlertController(title: "Sorry", message: "The photo is empty.", preferredStyle: UIAlertControllerStyle.Alert)
            deleteAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in }))
            presentViewController(deleteAlert, animated: true, completion: nil)
        } else if temText == nil {
            var deleteAlert = UIAlertController(title: "Sorry", message: "The description is empty.", preferredStyle: UIAlertControllerStyle.Alert)
            deleteAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in }))
            presentViewController(deleteAlert, animated: true, completion: nil)
        } else {
            delegate?.duangTableViewControllerAddPhoto(temImage!, description: temText!)
            navigationController?.popViewControllerAnimated(true)
            
            
            /*
            var photoArray = [NSMutableDictionary]()
            var photoDictionary = NSMutableDictionary()
            photoDictionary.setValue(APIManager.Placeholder.Image, forKey: "photo")
            photoDictionary.setValue("photo 1 description", forKey: "description")
            photoArray.append(photoDictionary)
            
            
            APIManager.sharedInstance.addPost("post title", description: "post description", photoArray: photoArray, success: { () -> () in
            println("ok")
            }, failure: { (error) -> () in
            println("not ok")
            })
            */
            
            /*
            APIManager.sharedInstance.addNewPhoto(temImage!, description: temText!, success: { () -> () in
            println("ok")
            }, failure: { (error) -> () in
            
            })*/
        }
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
    
    // MARK: - Input
    
    var duangTableCellInput = DuangTableCellInput()
    
    var inputTitle: String?
    var inputText: String?
    
    func showInput() {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DuangTableViewController") as DuangTableViewController
        viewController.delegate = self
        viewController.tableType = TableType.Input
        
        if let sectionNumber = selectedIndexPath?.section {
            if let text = duangTableData.sectionArray[sectionNumber].sectionTitleForHeader {
                viewController.inputTitle = text
            }
            if let text = duangTableData.sectionArray[sectionNumber].rowArray?[0].getTextArray(0) {
                viewController.inputText = text
            }
            
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    
    // MARK: DuangTableCellInputProtocol
    
    func duangTableCellInputDoneAction() {
        doneInput()
    }
    
    // MARK: - DuangTableViewControllerProtocol
    
    var delegate: DuangTableViewControllerProtocol?
    
    func duangTableViewControllerInput(inputString: String) {
        if let sectionNumber = selectedIndexPath?.section {
            if let inputName = duangTableData.sectionArray[sectionNumber].sectionTitleForHeader {
                if let type = tableType {
                    switch type {
                    case TableType.ProfileEdit:
                        if inputName == TitleName.InputFirstName {
                            APIManager.sharedInstance.setCurrentUserFirstName(inputString)
                            setSelectedInputText(inputString)
                        } else if inputName == TitleName.InputLastName {
                            APIManager.sharedInstance.setCurrentUserLastName(inputString)
                            setSelectedInputText(inputString)
                        } else if inputName == TitleName.InputAboutYou {
                            APIManager.sharedInstance.setCurrentUserDescription(inputString)
                            setSelectedInputText(inputString)
                        }
                    case TableType.Settings:
                        if inputName == TitleName.InputUsername {
                            if let errorString = APIManager.sharedInstance.setCurrentUserUsername(inputString) {
                                var deleteAlert = UIAlertController(title: "Sorry", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                                deleteAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in }))
                                presentViewController(deleteAlert, animated: true, completion: nil)
                            } else {
                                setSelectedInputText(inputString)
                            }
                        } else if inputName == TitleName.InputEmail {
                            if let errorString = APIManager.sharedInstance.setCurrentUserEmail(inputString) {
                                var deleteAlert = UIAlertController(title: "Sorry", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                                deleteAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in }))
                                presentViewController(deleteAlert, animated: true, completion: nil)
                            } else {
                                setSelectedInputText(inputString)
                            }
                        }
                    case TableType.AddPhoto:
                        if inputName == TitleName.InputPhotoDescription {
                            temText = inputString
                            setSelectedInputText(inputString)
                        }
                    case TableType.AddPost:
                        setSelectedInputText(inputString)
                    default:
                        break
                    }
                }
            }
        }
    }
    
    func setSelectedInputText(inputText: String) {
        if let theSection = selectedIndexPath?.section {
            if let theRow = selectedIndexPath?.row {
                if let theRowArray = duangTableData.sectionArray[theSection].rowArray {
                    if theRowArray.count > 0 {
                        if let theTextArray = theRowArray[0].textArray {
                            if theTextArray.count > 0 {
                                duangTableData.sectionArray[theSection].rowArray![theRow].textArray![0] = inputText
                                tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func duangTableViewControllerAddPhoto(image: UIImage, description: String) {

        // Add Post
        
        temImageArray.append(image)
        temTextArray.append(description)
        
        if duangTableData.sectionArray.count == 4 {
            let section = DuangTableDataSection.initSection(sectionTitleForHeader: nil,
                rowType: DuangTableDataRow.RowType.ImageSmall,
                cellHeight: nil,
                textArray: [description],
                imageFileArray: nil,
                imageArray: [image],
                colorArray: nil,
                function: nil)
            duangTableData.sectionArray.insert(section, atIndex: 2)
            tableView.reloadData()
        } else if duangTableData.sectionArray.count == 5 {
            duangTableData.sectionArray[2].addRow(DuangTableDataRow.RowType.ImageSmall,
                cellHeight: nil,
                textArray: [description],
                imageFileArray: nil,
                imageArray: [image],
                colorArray: nil, function: nil)
            tableView.reloadData()
        }
        
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
        if let theSection = selectedIndexPath?.section {
            if let theRow = selectedIndexPath?.row {
                if let theRowArray = duangTableData.sectionArray[theSection].rowArray {
                    if theRowArray.count > 0 {
                        if let theTextArray = theRowArray[0].textArray {
                            if theTextArray.count > 0 {
                                if let type = tableType {
                                    switch type {
                                    case TableType.ProfileEdit:
                                        if theTextArray[0] == TitleName.ImageProfilePicture {
                                            APIManager.sharedInstance.setCurrentUserAvatar(image)
                                            duangTableData.sectionArray[theSection].rowArray![theRow].imageFileArray![0] = APIManager.sharedInstance.getCurrentUserAvatarFile()
                                            tableView.reloadData()
                                        } else if theTextArray[0] == TitleName.ImageBannerPicture {
                                            APIManager.sharedInstance.setCurrentUserBanner(image)
                                            duangTableData.sectionArray[theSection].rowArray![theRow].imageFileArray![0] = APIManager.sharedInstance.getCurrentUserBannerFile()
                                            tableView.reloadData()
                                        }
                                    case TableType.AddPhoto:
                                        temImage = image
                                        duangTableData.sectionArray[theSection].rowArray![theRow].imageArray![0] = image
                                        tableView.reloadData()
                                    default:
                                        break
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Data
    
    var temImage: UIImage?
    var temText: String?
    
    var temImageArray = [UIImage]()
    var temTextArray = [String]()
    
    private struct TitleName {
        static let InputFirstName = "First Name"
        static let InputLastName = "Last Name"
        static let InputAboutYou = "About You"
        static let InputUsername = "Username"
        static let InputEmail = "Email"
        static let InputPhotoDescription = "Photo Description"
        
        static let ImageProfilePicture = "Profile Picture"
        static let ImageBannerPicture = "Banner Picture"
        
        static let AddPostTitle = "Title"
        static let AddPostDescription = "Description"
        
    }
    
    // MARK: - TableView Data
    
    var duangTableData = DuangTableData()
    
    func setDuangTableDataFromPost(objectArray: [PFObject]) {
        duangTableData = DuangTableData()
        var section = DuangTableDataSection()
        
        for object in objectArray {
            
            section = DuangTableDataSection.initSection(sectionTitleForHeader: nil,
                rowType: DuangTableDataRow.RowType.ImageMutable,
                cellHeight: nil,
                textArray: nil,
                imageFileArray: nil,//APIManager.getFileArrayFromObject(object, key: TablePost.Photos),///////////////
                imageArray: nil,
                colorArray: nil,
                function: nil)
            
//            let user = APIManager.getUserFromObject(object, key: TablePhoto.Owner)
//            
//            section.addRow(DuangTableDataRow.RowType.UserSmall,
//                cellHeight: nil,
//                textArray: [APIManager.getNameFromUser(user)],
//                imageFileArray: [APIManager.getFileFromUser(user, key: TableUser.Avatar)],
//                imageArray: [APIManager.Placeholder.Avatar],
//                colorArray: nil,
//                function: nil)
            duangTableData.sectionArray.append(section)
        }
        tableView.reloadData()
    }
    
    func setDuangTableDataFromPhoto(objectArray: [PFObject]) {
        duangTableData = DuangTableData()
        var section = DuangTableDataSection()
        
        for object in objectArray {
            section = DuangTableDataSection.initSection(sectionTitleForHeader: "",
                rowType: DuangTableDataRow.RowType.ImageBig,
                cellHeight: APIManager.getHeightFromObject(object, keyWidth: TablePhoto.ImageWidth, keyHeight: TablePhoto.ImageHeight),
                textArray: nil,
                imageFileArray: [APIManager.getFileFromObject(object, key: TablePhoto.Image)],
                imageArray: nil,
                colorArray: nil,
                function: nil)
            
            let user = APIManager.getUserFromObject(object, key: TablePhoto.Owner)
            
            section.addRow(DuangTableDataRow.RowType.UserSmall,
                cellHeight: nil,
                textArray: [APIManager.getNameFromUser(user)],
                imageFileArray: [APIManager.getFileFromUser(user, key: TableUser.Avatar)],
                imageArray: [APIManager.Placeholder.Avatar],
                colorArray: nil,
                function: nil)
            duangTableData.sectionArray.append(section)
        }
        tableView.reloadData()
    }
    
    func setDuangTableDataFromUser(objectArray: [PFUser]) {
        duangTableData = DuangTableData()
        var section = DuangTableDataSection()
        
        for user in objectArray {
            section = DuangTableDataSection.initSection(sectionTitleForHeader: "",
                rowType: DuangTableDataRow.RowType.UserBig,
                cellHeight: nil,
                textArray: [APIManager.getNameFromUser(user), APIManager.getStringFromUser(user, key: TableUser.Description)],
                imageFileArray: [APIManager.getFileFromUser(user, key: TableUser.Avatar), APIManager.getFileFromUser(user, key: TableUser.Banner)],
                imageArray: nil,
                colorArray: nil,
                function: nil)
            duangTableData.sectionArray.append(section)
        }
        tableView.reloadData()
    }
    
    // MARK: - TableView
    
    @IBOutlet weak var tableView: UITableView!
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return duangTableData.sectionArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return duangTableData.sectionArray[section].rowArray?.count ?? 0
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
        if let duangTableDataRow = duangTableData.sectionArray[indexPath.section].rowArray?[indexPath.row] {
            if let rowType = duangTableDataRow.rowType {
                switch rowType {
                case DuangTableDataRow.RowType.UserBig:
                    return UIScreen.mainScreen().bounds.size.width
                case DuangTableDataRow.RowType.UserSmall:
                    return 50.0
                case DuangTableDataRow.RowType.ImageMutable:
                    return UIScreen.mainScreen().bounds.size.width
                case DuangTableDataRow.RowType.ImageBig:
                    return duangTableDataRow.cellHeight ?? 0.0
                case DuangTableDataRow.RowType.ImageSmall:
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
        }
        return 0.0
    }
    
    private struct CellIdentifier {
        static let UserBig = "DuangTableCellUserBig"
        static let ImageMutable = "DuangTableCellImageMutable"
        static let ImageBig = "DuangTableCellImageBig"
        static let ImageSmall = "DuangTableCellImageSmall"
        static let Input = "DuangTableCellInput"
        static let Button = "DuangTableCellButton"
        static let TextField = "DuangTableCellTextField"
        static let DefaultCell = "DefaultCell"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let duangTableDataRow = duangTableData.sectionArray[indexPath.section].rowArray?[indexPath.row] {
            
            duangTableDataRow.someFunc()
            
            if let rowType = duangTableDataRow.rowType {
                switch rowType {
                case DuangTableDataRow.RowType.UserBig:
                    let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.UserBig, forIndexPath: indexPath) as DuangTableCellUserBig
                    cell.duangTableDataRow = duangTableDataRow
                    return cell
                    
                case DuangTableDataRow.RowType.UserSmall:
                    let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.ImageSmall, forIndexPath: indexPath) as DuangTableCellImageSmall
                    cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                    cell.isRound = true
                    cell.duangTableDataRow = duangTableDataRow
                    return cell
                    
                case DuangTableDataRow.RowType.ImageMutable:
                    let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.ImageMutable, forIndexPath: indexPath) as DuangTableCellImageMutable
                    cell.duangTableDataRow = duangTableDataRow
                    return cell
                    
                case DuangTableDataRow.RowType.ImageBig:
                    let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.ImageBig, forIndexPath: indexPath) as DuangTableCellImageBig
                    cell.duangTableDataRow = duangTableDataRow
                    return cell
                    
                case DuangTableDataRow.RowType.ImageSmall:
                    let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.ImageSmall, forIndexPath: indexPath) as DuangTableCellImageSmall
                    cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                    cell.duangTableDataRow = duangTableDataRow
                    return cell
                    
                case DuangTableDataRow.RowType.Input:
                    duangTableCellInput = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.Input, forIndexPath: indexPath) as DuangTableCellInput
                    duangTableCellInput.delegate = self
                    if let text = inputText {
                        duangTableCellInput.inputTextView.text = text
                    }
                    return duangTableCellInput
                    
                case DuangTableDataRow.RowType.TextField:
                    let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.TextField, forIndexPath: indexPath) as DuangTableCellTextField
                    cell.delegate = self
                    cell.duangTableDataRow = duangTableDataRow
                    addDuangTableCellTextField(cell)
                    return cell
                    
                case DuangTableDataRow.RowType.Button:
                    let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.Button, forIndexPath: indexPath) as DuangTableCellButton
                    cell.duangTableDataRow = duangTableDataRow
                    return cell
                    
                case DuangTableDataRow.RowType.DefaultRightDetail:
                    var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: CellIdentifier.DefaultCell)
                    cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                    cell.textLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
                    if let text = duangTableDataRow.getTextArray(0) {
                        cell.textLabel?.text = text
                    }
                    if let text = duangTableDataRow.getTextArray(1) {
                        cell.detailTextLabel?.text = text
                    }
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
    
    var selectedIndexPath: NSIndexPath?
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
        
        selectedIndexPath = indexPath
        
        if let didSelectFunc = duangTableData.sectionArray[indexPath.section].rowArray?[indexPath.row].function {
            switch didSelectFunc {
            case DuangTableDataRow.Function.Nothing:
                println("Nothing")
            case let DuangTableDataRow.Function.Function1(didSelectFuncAction):
                didSelectFuncAction()
            default:
                break
            }
        }
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
