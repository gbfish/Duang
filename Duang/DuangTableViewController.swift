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
    func handleDuangTableDataDeliverer(dataDeliverer: DuangTableViewController.DuangTableDataDeliverer)
    
//    func duangTableViewControllerInput(inputString: String)
//    func duangTableViewControllerAddPhoto(image: UIImage, description: String)
}

class DuangTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, DuangTableViewControllerProtocol, DuangTableCellTextViewProtocol, DuangTableCellTextFieldProtocol{

    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    var tableType = TableType.Profile
    
    func checkTableType() {
        var section = DuangTableDataSection()
        switch tableType {
        case .Feed:// MARK: Feed
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
            
        case .Users:// MARK: Users
            titleString = TabBarTitle.Users
            
            APIManager.sharedInstance.getUsers({ (objectArray) -> () in
                self.setDuangTableDataFromUser(objectArray)
                }, failure: { (error) -> () in
                    println("error = \(error)")
            })
            
        case .Profile:// MARK: Profile
            titleString = TabBarTitle.Profile
            
            // Profile Picture
            
            section = DuangTableDataSection()
            section.sectionTitleForHeader = ""
            
            section.rowArray.append(DuangTableDataSection.DuangTableDataRow.UserBig(userName: "\(APIManager.sharedInstance.getCurrentUserFirstName()) \(APIManager.sharedInstance.getCurrentUserLastName())", userDescription: APIManager.sharedInstance.getCurrentUserDescription(), userAvatarPlaceholder: ImagePlaceholder.Avatar, userAvatarFile: APIManager.sharedInstance.getCurrentUserAvatarFile(), userBannerPlaceholder: ImagePlaceholder.Image, userBannerFile: APIManager.sharedInstance.getCurrentUserBannerFile(), tapAction: showProfileEdit))
            duangTableData.sectionArray.append(section)
            
            // Add a Photo
            
            section = DuangTableDataSection()
            section.sectionTitleForHeader = ""
            
            section.rowArray.append(DuangTableDataSection.DuangTableDataRow.Button(buttonText: "Add a Photo", buttonTextColor: DuangColor.ButtonNormal, buttonBackgroundColor: DuangColor.ButtonNormalBackground, tapAction: showAddPhoto))
            duangTableData.sectionArray.append(section)
            
            // Setting
            
            section = DuangTableDataSection()
            section.sectionTitleForHeader = ""
            
            section.rowArray.append(DuangTableDataSection.DuangTableDataRow.Button(buttonText: "Settings", buttonTextColor: DuangColor.ButtonNormal, buttonBackgroundColor: DuangColor.ButtonNormalBackground, tapAction: showSettings))
            duangTableData.sectionArray.append(section)
            
        case .ProfileEdit:// MARK: ProfileEdit
            titleString = "Edit Profile"
            
            // Profile Picture
            
            section = DuangTableDataSection()
            section.sectionTitleForHeader = ""
            
            section.rowArray.append(DuangTableDataSection.DuangTableDataRow.ImageSmall(imageTitle: TitleName.ImageProfilePicture, imagePlaceholder: ImagePlaceholder.Avatar, imageFile: APIManager.sharedInstance.getCurrentUserAvatarFile(), isRound: true, tapAction: selectImage))
            duangTableData.sectionArray.append(section)
            
            // Banner Picture
            
            section = DuangTableDataSection()
            section.sectionTitleForHeader = ""
            
            section.rowArray.append(DuangTableDataSection.DuangTableDataRow.ImageSmall(imageTitle: TitleName.ImageBannerPicture, imagePlaceholder: ImagePlaceholder.Image, imageFile: APIManager.sharedInstance.getCurrentUserBannerFile(), isRound: false, tapAction: selectImage))
            duangTableData.sectionArray.append(section)
            
            // First Name
            section = DuangTableDataSection()
            section.sectionTitleForHeader = TitleName.InputFirstName
            
            section.rowArray.append(DuangTableDataSection.DuangTableDataRow.DefaultRightDetail(titleText: APIManager.sharedInstance.getCurrentUserFirstName(), detailText: "", tapAction: showInput))
            duangTableData.sectionArray.append(section)
            
            // Last Name
            section = DuangTableDataSection()
            section.sectionTitleForHeader = TitleName.InputLastName
            
            section.rowArray.append(DuangTableDataSection.DuangTableDataRow.DefaultRightDetail(titleText: APIManager.sharedInstance.getCurrentUserLastName(), detailText: "", tapAction: showInput))
            duangTableData.sectionArray.append(section)
            
            // Description
            section = DuangTableDataSection()
            section.sectionTitleForHeader = TitleName.InputAboutYou
            
            section.rowArray.append(DuangTableDataSection.DuangTableDataRow.DefaultRightDetail(titleText: APIManager.sharedInstance.getCurrentUserDescription(), detailText: "", tapAction: showInput))
            duangTableData.sectionArray.append(section)
            
        case .Input:// MARK: Input
            
            // TextView
            section = DuangTableDataSection()
            section.sectionTitleForHeader = ""
            
            section.rowArray.append(DuangTableDataSection.DuangTableDataRow.TextView(placeholder: inputPlaceholderText))
            duangTableData.sectionArray.append(section)
            
            // Done
            section = DuangTableDataSection()
            section.sectionTitleForHeader = ""
            
            section.rowArray.append(DuangTableDataSection.DuangTableDataRow.Button(buttonText: "Done", buttonTextColor: DuangColor.ButtonNormal, buttonBackgroundColor: DuangColor.ButtonNormalBackground, tapAction: doneInput))
            duangTableData.sectionArray.append(section)
            
        case .Settings:// MARK: Settings
            titleString = "Settings"
            
            // Username
            section = DuangTableDataSection()
            section.sectionTitleForHeader = TitleName.InputUsername
            
            section.rowArray.append(DuangTableDataSection.DuangTableDataRow.DefaultRightDetail(titleText: APIManager.sharedInstance.getCurrentUserUsername(), detailText: "", tapAction: showInput))
            duangTableData.sectionArray.append(section)
            
            // Email
            section = DuangTableDataSection()
            section.sectionTitleForHeader = TitleName.InputEmail
            
            section.rowArray.append(DuangTableDataSection.DuangTableDataRow.DefaultRightDetail(titleText: APIManager.sharedInstance.getCurrentUserEmail(), detailText: "", tapAction: showInput))
            duangTableData.sectionArray.append(section)
            
            // Password
            section = DuangTableDataSection()
            section.sectionTitleForHeader = "Password"
            
            section.rowArray.append(DuangTableDataSection.DuangTableDataRow.DefaultRightDetail(titleText: "Change Password", detailText: "", tapAction: showChangePassword))
            duangTableData.sectionArray.append(section)
            
            // Log out
            section = DuangTableDataSection()
            section.sectionTitleForHeader = ""
            
            section.rowArray.append(DuangTableDataSection.DuangTableDataRow.Button(buttonText: "Log out", buttonTextColor: DuangColor.ButtonNormal, buttonBackgroundColor: DuangColor.ButtonNormalBackground, tapAction: logout))
            duangTableData.sectionArray.append(section)
            
        case .ChangePassword:// MARK: ChangePassword
            titleString = "Change Password"
            
            // Old Password
            section = DuangTableDataSection()
            section.sectionTitleForHeader = "Old Password"
            
            section.rowArray.append(DuangTableDataSection.DuangTableDataRow.TextField(placeholder: "password"))
            duangTableData.sectionArray.append(section)
            
            // New Password
            section = DuangTableDataSection()
            section.sectionTitleForHeader = "New Password"
            
            section.rowArray.append(DuangTableDataSection.DuangTableDataRow.TextField(placeholder: "password"))
            duangTableData.sectionArray.append(section)
            
            // Retype Password
            section = DuangTableDataSection()
            section.sectionTitleForHeader = "Retype Password"
            
            section.rowArray.append(DuangTableDataSection.DuangTableDataRow.TextField(placeholder: "password"))
            duangTableData.sectionArray.append(section)
            
            // Done
            section = DuangTableDataSection()
            section.sectionTitleForHeader = ""
            
            section.rowArray.append(DuangTableDataSection.DuangTableDataRow.Button(buttonText: "Done", buttonTextColor: DuangColor.ButtonNormal, buttonBackgroundColor: DuangColor.ButtonNormalBackground, tapAction: changePasswordDone))
            duangTableData.sectionArray.append(section)
            
        case .AddPost:// MARK: AddPost
            titleString = TabBarTitle.AddPost
            
            // Title
            section = DuangTableDataSection()
            section.sectionTitleForHeader = TitleName.AddPostTitle
            
            section.rowArray.append(DuangTableDataSection.DuangTableDataRow.DefaultRightDetail(titleText: "", detailText: "", tapAction: showInput))
            duangTableData.sectionArray.append(section)
            
            // Description
            section = DuangTableDataSection()
            section.sectionTitleForHeader = TitleName.AddPostDescription
            
            section.rowArray.append(DuangTableDataSection.DuangTableDataRow.DefaultRightDetail(titleText: "", detailText: "", tapAction: showInput))
            duangTableData.sectionArray.append(section)
            
            // Add a Photo
            section = DuangTableDataSection()
            section.sectionTitleForHeader = ""
            
            section.rowArray.append(DuangTableDataSection.DuangTableDataRow.Button(buttonText: "Add a Photo", buttonTextColor: DuangColor.ButtonNormal, buttonBackgroundColor: DuangColor.ButtonNormalBackground, tapAction: showAddPhoto))
            duangTableData.sectionArray.append(section)
            
            // Done
            section = DuangTableDataSection()
            section.sectionTitleForHeader = ""
            
            section.rowArray.append(DuangTableDataSection.DuangTableDataRow.Button(buttonText: "Done", buttonTextColor: DuangColor.ButtonNormal, buttonBackgroundColor: DuangColor.ButtonNormalBackground, tapAction: doneAddPost))
            duangTableData.sectionArray.append(section)
            
        case .AddPhoto:// MARK: AddPhoto
            titleString = "Add a Photo"
            
            // Photo
            section = DuangTableDataSection()
            section.sectionTitleForHeader = ""
            
            section.rowArray.append(DuangTableDataSection.DuangTableDataRow.ImageSmall(imageTitle: "Photo", imagePlaceholder: ImagePlaceholder.Image, imageFile: nil, isRound: false, tapAction: selectImage))
            duangTableData.sectionArray.append(section)
            
            // Description
            section = DuangTableDataSection()
            section.sectionTitleForHeader = TitleName.InputPhotoDescription
            
            section.rowArray.append(DuangTableDataSection.DuangTableDataRow.DefaultRightDetail(titleText: "", detailText: "", tapAction: showInput))
            duangTableData.sectionArray.append(section)
            
            // Done
            section = DuangTableDataSection()
            section.sectionTitleForHeader = ""
            
            section.rowArray.append(DuangTableDataSection.DuangTableDataRow.Button(buttonText: "Done", buttonTextColor: DuangColor.ButtonNormal, buttonBackgroundColor: DuangColor.ButtonNormalBackground, tapAction: doneAddPhoto))
            duangTableData.sectionArray.append(section)
        }
    }

    // MARK: - Did Select Func
    
    
    
    func showSettings() {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DuangTableViewController") as DuangTableViewController
        viewController.tableType = TableType.Settings
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: Profile Edit
    
    func showProfileEdit() {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DuangTableViewController") as DuangTableViewController
        viewController.tableType = TableType.ProfileEdit
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: Input

    var inputPlaceholderText = ""
    
    func showInput() {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DuangTableViewController") as DuangTableViewController
        viewController.delegate = self
        viewController.tableType = TableType.Input
        viewController.titleString = duangTableData.sectionArray[selectedIndexPath.section].sectionTitleForHeader
        switch duangTableData.sectionArray[selectedIndexPath.section].rowArray[selectedIndexPath.row] {
        case .DefaultRightDetail(let titleText, _, _):
            viewController.inputPlaceholderText = titleText
        default:
            break
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func doneInput() {
        if let inputString = duangTableCellTextView?.textView.text {
            delegate?.handleDuangTableDataDeliverer(DuangTableDataDeliverer.Input(inputText: inputString))
        }
        navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: Add Photo
    
    func showAddPhoto() {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DuangTableViewController") as DuangTableViewController
        viewController.delegate = self
        viewController.tableType = TableType.AddPhoto
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func doneAddPhoto() {
        var theImage = UIImage()
        var theDescription = ""
        
        switch duangTableData.sectionArray[0].rowArray[0] {
        case .ImageSmall(_, let imagePlaceholder, _, _, _):
            theImage = imagePlaceholder
        default:
            break
        }
        
        switch duangTableData.sectionArray[1].rowArray[0] {
        case .DefaultRightDetail(let titleText, _, _):
            theDescription = titleText
        default:
            break
        }
        
        if theImage == ImagePlaceholder.Image {
            var deleteAlert = UIAlertController(title: "Sorry", message: "The photo is empty.", preferredStyle: UIAlertControllerStyle.Alert)
            deleteAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in }))
            presentViewController(deleteAlert, animated: true, completion: nil)
        } else if theDescription == "" {
            var deleteAlert = UIAlertController(title: "Sorry", message: "The description is empty.", preferredStyle: UIAlertControllerStyle.Alert)
            deleteAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in }))
            presentViewController(deleteAlert, animated: true, completion: nil)
        } else {
            delegate?.handleDuangTableDataDeliverer(DuangTableViewController.DuangTableDataDeliverer.AddPhoto(imageSelected: theImage, descriptionText: theDescription))
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    // MARK: Change Password
    
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
        /*
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
        }*/
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
    
    
    
    // MARK: Log out
    
    func logout() {
        APIManager.sharedInstance.logout()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    
    
    
    
    // MARK: - DuangTableViewControllerProtocol
    
    enum DuangTableDataDeliverer {
        case Input(inputText: String)
        case AddPhoto(imageSelected: UIImage, descriptionText: String)
    }
    
    var delegate: DuangTableViewControllerProtocol?
    
    func handleDuangTableDataDeliverer(dataDeliverer: DuangTableViewController.DuangTableDataDeliverer) {
        switch dataDeliverer {
        case .Input(let inputText):
            switch tableType {
            case .ProfileEdit:
                switch duangTableData.sectionArray[selectedIndexPath.section].sectionTitleForHeader {
                case TitleName.InputFirstName:
                    APIManager.sharedInstance.setCurrentUserFirstName(inputText)
                case TitleName.InputLastName:
                    APIManager.sharedInstance.setCurrentUserLastName(inputText)
                case TitleName.InputAboutYou:
                    APIManager.sharedInstance.setCurrentUserDescription(inputText)
                default:
                    break
                }
            case .Settings:
                
            default:
                break
            }
            
            duangTableData.sectionArray[selectedIndexPath.section].rowArray[selectedIndexPath.row] = DuangTableDataSection.DuangTableDataRow.DefaultRightDetail(titleText: inputText, detailText: "", tapAction: showInput)
            tableView.reloadData()
        case .AddPhoto(let imageSelected, let descriptionText):
            println("descriptionText = \(descriptionText)")
            
            let sectionCount = duangTableData.sectionArray.count
            
            var section = DuangTableDataSection()
            section.rowArray.append(DuangTableDataSection.DuangTableDataRow.ImageSmall(imageTitle: descriptionText, imagePlaceholder: imageSelected, imageFile: nil, isRound: false, tapAction: showAddPhoto))
            duangTableData.sectionArray.insert(section, atIndex: duangTableData.sectionArray.count - 2)
            tableView.reloadData()
            
            /*
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
            }*/
        }
    }
    
    
    
    func duangTableViewControllerInput(inputString: String) {/*
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
        }*/
    }
    
    func setSelectedInputText(inputText: String) {/*
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
        }*/
    }
    
    func duangTableViewControllerAddPhoto(image: UIImage, description: String) {

        // Add Post
        
        temImageArray.append(image)
        temTextArray.append(description)
        /*
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
        }*/
        
    }
    
    // MARK: - DuangTableCellTextViewProtocol
    
    func duangTableCellTextViewDoneAction() {
        doneInput()
    }
    
    

    // MARK: - Data
    
    // MARK:
    
    
    
    // MARK:
    
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
            /*
            section = DuangTableDataSection.initSection(sectionTitleForHeader: nil,
                rowType: DuangTableDataRow.RowType.ImageMutable,
                cellHeight: nil,
                textArray: nil,
                imageFileArray: nil,//APIManager.getFileArrayFromObject(object, key: TablePost.Photos),///////////////
                imageArray: nil,
                colorArray: nil,
                function: nil)
            */
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
        /*
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
        }*/
        tableView.reloadData()
    }
    
    func setDuangTableDataFromUser(objectArray: [PFUser]) {
        duangTableData = DuangTableData()
        var section = DuangTableDataSection()
        
        for user in objectArray {/*
            section = DuangTableDataSection.initSection(sectionTitleForHeader: "",
                rowType: DuangTableDataRow.RowType.UserBig,
                cellHeight: nil,
                textArray: [APIManager.getNameFromUser(user), APIManager.getStringFromUser(user, key: TableUser.Description)],
                imageFileArray: [APIManager.getFileFromUser(user, key: TableUser.Avatar), APIManager.getFileFromUser(user, key: TableUser.Banner)],
                imageArray: nil,
                colorArray: nil,
                function: nil)
            duangTableData.sectionArray.append(section)*/
        }
        tableView.reloadData()
    }
    
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
        return duangTableData.sectionArray[indexPath.section].rowArray[indexPath.row].cellHeight()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let row = duangTableData.sectionArray[indexPath.section].rowArray[indexPath.row]
        switch row {
        case .UserBig(let userName, let userDescription, let userAvatarPlaceholder, let userAvatarFile, let userBannerPlaceholder, let userBannerFile, _):
            let cell = tableView.dequeueReusableCellWithIdentifier(row.cellIdentifier(), forIndexPath: indexPath) as DuangTableCellUserBig
            cell.userName = userName
            cell.userDescription = userDescription
            cell.userAvatarPlaceholder = userAvatarPlaceholder
            cell.userAvatarFile = userAvatarFile
            cell.userBannerPlaceholder = userBannerPlaceholder
            cell.userBannerFile = userBannerFile
            cell.reloadView()
            return cell
        case .ImageBig(_, let imagePlaceholder, let imageFile, _):
            let cell = tableView.dequeueReusableCellWithIdentifier(row.cellIdentifier(), forIndexPath: indexPath) as DuangTableCellImageBig
            cell.imagePlaceholder = imagePlaceholder
            cell.imageFile = imageFile
            cell.reloadView()
            return cell
        case .ImageSmall(let imageTitle, let imagePlaceholder, let imageFile, let isRound, _):
            let cell = tableView.dequeueReusableCellWithIdentifier(row.cellIdentifier(), forIndexPath: indexPath) as DuangTableCellImageSmall
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.imageTitle = imageTitle
            cell.imagePlaceholder = imagePlaceholder
            cell.imageFile = imageFile
            cell.isRound = isRound
            cell.reloadView()
            return cell
        case .TextView(let placeholder):
            let cell = tableView.dequeueReusableCellWithIdentifier(row.cellIdentifier(), forIndexPath: indexPath) as DuangTableCellTextView
            cell.delegate = self
            cell.placeholder = placeholder
            cell.reloadView()
            duangTableCellTextView = cell
            return cell
        case .TextField(let placeholder):
            let cell = tableView.dequeueReusableCellWithIdentifier(row.cellIdentifier(), forIndexPath: indexPath) as DuangTableCellTextField
            cell.delegate = self
            cell.placeholder = placeholder
            cell.reloadView()
            addDuangTableCellTextField(cell)///
            return cell
        case .Button(let buttonText, let buttonTextColor, let buttonBackgroundColor, _):
            let cell = tableView.dequeueReusableCellWithIdentifier(row.cellIdentifier(), forIndexPath: indexPath) as DuangTableCellButton
            cell.buttonText = buttonText
            cell.buttonTextColor = buttonTextColor
            cell.buttonBackgroundColor = buttonBackgroundColor
            cell.reloadView()
            return cell
        case .DefaultRightDetail(let titleText, let detailText, _):
            let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: row.cellIdentifier())
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.textLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
            cell.textLabel?.text = titleText
            cell.detailTextLabel?.text = detailText
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    
    var selectedIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
        selectedIndexPath = indexPath
        duangTableData.sectionArray[indexPath.section].rowArray[indexPath.row].tapAction()
    }
    
    // MARK: - DuangTableCellTextView
    
    var duangTableCellTextView: DuangTableCellTextView?
    
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
        switch duangTableData.sectionArray[selectedIndexPath.section].rowArray[selectedIndexPath.row] {
        case .ImageSmall(let imageTitle, let imagePlaceholder, let imageFile, let isRound, let tapAction):
            duangTableData.sectionArray[selectedIndexPath.section].rowArray[selectedIndexPath.row] = DuangTableDataSection.DuangTableDataRow.ImageSmall(imageTitle: imageTitle, imagePlaceholder: image, imageFile: nil, isRound: isRound, tapAction: tapAction)
            tableView.reloadData()
            break
        default:
            break
        }
    }
}
