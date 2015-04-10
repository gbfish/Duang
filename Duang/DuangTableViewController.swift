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
}

class DuangTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, DuangTableViewControllerProtocol, DuangTableCellButtonsProtocol, DuangTableCellTextViewProtocol, DuangTableCellTextFieldProtocol
{
    override func viewDidLoad() {
        super.viewDidLoad()

        checkTableType()
        title = titleString
    }
    
    override func viewDidAppear(animated: Bool) {
        switch tableType {
        case .Comment:
//            mainInputViewTextField.becomeFirstResponder()
            moveInputView()
        default:
            break
        }
    }
    
//    override func viewWillAppear(animated: Bool) {
//        
//        
//    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        moveInputView()
        println("--- viewDidLayoutSubviews ---")
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
        
        case Comment
        case AddComment
    }
    
    var tableType = TableType.Profile
    
    
    
    
    // MARK: - Comment
    
    func showCommentPost(post: PFObject?) {
        if let thePost = post {
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DuangTableViewController") as? DuangTableViewController {
                viewController.tableType = TableType.Comment
                viewController.dataFromPreviousViewPost = thePost
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    // MARK: - 
    
    func checkTableType() {
        var section = DuangTableDataSection()
        switch tableType {
        case .Feed:// MARK: Feed
            titleString = TabBarTitle.Feed
            
            addRefreshControl()
            beginRefreshing()
            
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
            
            section.rowArray.append(DuangTableDataSection.DuangTableDataRow.ImageSmall(imageTitle: TitleName.ImageProfilePicture, imagePlaceholder: ImagePlaceholder.Avatar, imageFile: APIManager.sharedInstance.getCurrentUserAvatarFile(), isRound: true, tapAction: DuangTableDataSection.function0(selectImage)))
            duangTableData.sectionArray.append(section)
            
            // Banner Picture
            
            section = DuangTableDataSection()
            section.sectionTitleForHeader = ""
            
            section.rowArray.append(DuangTableDataSection.DuangTableDataRow.ImageSmall(imageTitle: TitleName.ImageBannerPicture, imagePlaceholder: ImagePlaceholder.Image, imageFile: APIManager.sharedInstance.getCurrentUserBannerFile(), isRound: false, tapAction: DuangTableDataSection.function0(selectImage)))
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
            if let theCurrentUserUsername = APIManager.sharedInstance.getCurrentUserUsername() {
                section = DuangTableDataSection()
                section.sectionTitleForHeader = TitleName.InputUsername
                section.rowArray.append(DuangTableDataSection.DuangTableDataRow.DefaultRightDetail(titleText: theCurrentUserUsername, detailText: "", tapAction: showInput))
                duangTableData.sectionArray.append(section)
            }
            
            // Email
            if let theCurrentUserEmail = APIManager.sharedInstance.getCurrentUserEmail() {
                section = DuangTableDataSection()
                section.sectionTitleForHeader = TitleName.InputEmail
                section.rowArray.append(DuangTableDataSection.DuangTableDataRow.DefaultRightDetail(titleText: theCurrentUserEmail, detailText: "", tapAction: showInput))
                duangTableData.sectionArray.append(section)
            }
            
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
            
            section.rowArray.append(DuangTableDataSection.DuangTableDataRow.ImageSmall(imageTitle: "Photo", imagePlaceholder: ImagePlaceholder.Image, imageFile: nil, isRound: false, tapAction: DuangTableDataSection.function0(selectImage)))
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
            
        case .Comment:
            titleString = "Comment"
            duangTableData = DuangTableData()
            duangTableData.addSectionCommentHeader(dataFromPreviousViewPost, tapActionUser: changePasswordDone, tapActionImage: changePasswordDone, tapActionComment: showAddComment)
            
        case .AddComment:
            titleString = "Leave a comment"
            duangTableData = DuangTableData()
            duangTableData.addTextView(nil)
            duangTableData.addImageSmallSelectImage("Photo", tapAction: selectImage)
            duangTableData.addButtons2("Cancel", function1: cancel, buttonText2: "Save", function2: doneAddComment)
        }
    }

    // MARK: - Show
    
    func showDuangTableViewController(presentedViewTableType: DuangTableViewController.TableType) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DuangTableViewController") as? DuangTableViewController {
            viewController.tableType = presentedViewTableType
            viewController.delegate = self
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func showAddComment() {
        showDuangTableViewController(DuangTableViewController.TableType.AddComment)
    }
    
    // MARK: - Did Select Func
    
    func showSettings() {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DuangTableViewController") as? DuangTableViewController {
            viewController.tableType = TableType.Settings
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    // MARK: Profile Edit
    
    func showProfileEdit() {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DuangTableViewController") as? DuangTableViewController {
            viewController.tableType = TableType.ProfileEdit
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    // MARK: Input

    var inputPlaceholderText = ""
    
    func showInput() {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DuangTableViewController") as? DuangTableViewController {
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
    }
    
    func doneInput() {
        if let inputString = duangTableCellTextView?.textView.text {
            delegate?.handleDuangTableDataDeliverer(DuangTableDataDeliverer.Input(inputText: inputString))
        }
        navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: Add Photo
    
    func showAddPhoto() {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DuangTableViewController") as? DuangTableViewController {
            viewController.delegate = self
            viewController.tableType = TableType.AddPhoto
            self.navigationController?.pushViewController(viewController, animated: true)
        }
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
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DuangTableViewController") as? DuangTableViewController {
            viewController.tableType = TableType.ChangePassword
            self.navigationController?.pushViewController(viewController, animated: true)
        }
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
    
    // MARK: Add Post
    
    func doneAddPost() {
        var ifShowAlert = true
        var messageString = "Something is wrong"
        
        var titleString = ""
        switch duangTableData.sectionArray[0].rowArray[0] {
        case .DefaultRightDetail(let titleText, _, _):
            titleString = titleText
        default:
            break
        }
        if titleString == "" {
            messageString = "The title is empty."
        }
        
        var descriptionString = ""
        switch duangTableData.sectionArray[1].rowArray[0] {
        case .DefaultRightDetail(let titleText, _, _):
            descriptionString = titleText
        default:
            break
        }
        if descriptionString == "" {
            messageString = "The description is empty."
        }
        
        var photoArray = [NSMutableDictionary]()
        
        if duangTableData.sectionArray.count < 5 {
            messageString = "The photo is empty."
        } else {
            for var index = 2; index < duangTableData.sectionArray.count - 2; ++index {
                var photoDictionary = NSMutableDictionary()
                switch duangTableData.sectionArray[index].rowArray[0] {
                case .ImageSmall(let imageTitle, let imagePlaceholder, _, _, _):
                    photoDictionary.setValue(imagePlaceholder, forKey: "photo")
                    photoDictionary.setValue(imageTitle, forKey: "description")
                    photoArray.append(photoDictionary)
                default:
                    break
                }
                ifShowAlert = false
            }
        }
        
        if ifShowAlert {
            var deleteAlert = UIAlertController(title: "Sorry", message: messageString, preferredStyle: UIAlertControllerStyle.Alert)
            deleteAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in }))
            presentViewController(deleteAlert, animated: true, completion: nil)
        } else {
            APIManager.sharedInstance.addPost(titleString, description: descriptionString, photoArray: photoArray, success: { () -> () in
                println("ok")
                }, failure: { (error) -> () in
                    println("not ok")
            })
        }
    }
    
    // MARK: Log out
    
    func logout() {
        APIManager.sharedInstance.logout()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func cancel() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: Done
    
    func doneAddComment() {
        if let theComment = getDuangTableCellTextViewText() {
//            let selectedImage =
            
            
            if let theImage: UIImage? = getSelectedImage(NSIndexPath(forRow: 0, inSection: 1)) {
                
                delegate?.handleDuangTableDataDeliverer(DuangTableViewController.DuangTableDataDeliverer.ImageText(image: theImage!, text: theComment))
            } else {
                
                
                delegate?.handleDuangTableDataDeliverer(DuangTableViewController.DuangTableDataDeliverer.Text(text: theComment))
            }
        } else {
            showAlart("Your comment is empty.")
        }
        navigationController?.popViewControllerAnimated(true)
    }
    
    func getSelectedImage(indexPath: NSIndexPath) -> UIImage? {
        var returnValue = UIImage()
        switch duangTableData.sectionArray[indexPath.section].rowArray[indexPath.row] {
        case .ImageSmall(_, let imagePlaceholder, _, _, _):
            returnValue = imagePlaceholder
        default:
            break
        }
        if returnValue == ImagePlaceholder.Image {
            return nil
        } else {
            return returnValue
        }
    }
    
    func getDuangTableCellTextViewText() -> String? {
        var returnValue = ""
        if let inputString = duangTableCellTextView?.textView.text {
            returnValue = inputString
        }
        if returnValue == "" {
            return nil
        } else {
            return returnValue
        }
    }
    
    func showAlart(message: String) {
        var deleteAlert = UIAlertController(title: "Sorry", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        deleteAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in }))
        presentViewController(deleteAlert, animated: true, completion: nil)
    }

    // MARK: - Data
    
    
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
    
    // MARK: - Data from Previous View
    
    var dataFromPreviousViewPost: PFObject?
    
    // MARK: - TableViewData
    
    var duangTableData = DuangTableData()
//    var postArray: [PFObject]?
    
    func setDuangTableDataFromPost(objectArray: [PFObject]) {
//        postArray = objectArray
        duangTableData = DuangTableData()
        for var index = 0; index < objectArray.count; ++index {
            duangTableData.addSectionPost(objectArray[index], tapActionUser: showChangePassword, tapActionImage: showChangePassword, tapActionShare: sharePost, tapActionComment: showCommentPost, tapActionLike: unlikePost)
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
    
    // MARK: - DuangTableDataSection
    
//    func sectionForPost(post: PFObject?) -> DuangTableDataSection? {
//        if let thePost = post {
//            var section = DuangTableDataSection()
//            
//            section.addImageSmallUser(APIManager.getUserFromObject(thePost, key: TablePost.Owner), tapAction: selectImage)
//            section.addRowLabel(APIManager.getStringFromObject(thePost, key: TablePost.Title), textFont: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline))
//            section.addRowLabel(APIManager.getStringFromObject(thePost, key: TablePost.Description), textFont: UIFont.preferredFontForTextStyle(UIFontTextStyleBody))
//            section.addImageMutable(thePost.relationForKey(TablePost.Photos), tapAction: showChangePassword)////
//            section.addButtonsForPost(thePost, shareAction: sharePost, commentAction: showCommentPost, likeAction: unlikePost)
//            
//            /*
//            let photos = thePost.relationForKey(TablePost.Photos)
//            section.rowArray.append(DuangTableDataSection.DuangTableDataRow.ImageMutable(photos: photos, tapAction: showChangePassword))
//            */
////            if let row = rowButtonsForPost(thePost) {
////                section.rowArray.append(row)
////            }
//            return section
//            
//            
//            
//        }
//        return nil
//    }
    
    // MARK: - DuangTableDataRow 
    /*
    func rowButtonsForPost(post: PFObject?) -> DuangTableDataSection.DuangTableDataRow? {
        if let thePost = post {
            
            let buttonShare = DuangTableDataSection.DuangTableDataRow.ButtonItem(buttonText: "share 0", buttonTextColor: DuangColor.DarkBlue, buttonBackgroundColor: DuangColor.Orange, borderColor: DuangColor.DarkBlue, buttonImage: DuangImage.Share, function: DuangTableDataSection.Function1PFObject(sharePost, argument: thePost))
            let buttonComment = DuangTableDataSection.DuangTableDataRow.ButtonItem(buttonText: "comment 0", buttonTextColor: DuangColor.DarkBlue, buttonBackgroundColor: DuangColor.Orange, borderColor: DuangColor.DarkBlue, buttonImage: DuangImage.Comment, function: DuangTableDataSection.Function1PFObject(sharePost, argument: thePost))
            let buttonLike = DuangTableDataSection.DuangTableDataRow.ButtonItem(buttonText: "\(thePost[TablePost.LikeCount])", buttonTextColor: DuangColor.DarkBlue, buttonBackgroundColor: DuangColor.Orange, borderColor: DuangColor.DarkBlue, buttonImage: DuangImage.Like, function: DuangTableDataSection.Function1PFObject(sharePost, argument: thePost))
            /*
            let buttonShare = DuangTableDataSection.DuangTableDataRow.ButtonItem(buttonText: "share 0", buttonTextColor: DuangColor.DarkBlue, buttonBackgroundColor: DuangColor.Orange, borderColor: DuangColor.DarkBlue, buttonImage: DuangImage.Share, post: thePost, tapAction: sharePost)
            let buttonComment = DuangTableDataSection.DuangTableDataRow.ButtonItem(buttonText: "comment 0", buttonTextColor: DuangColor.DarkBlue, buttonBackgroundColor: DuangColor.Orange, borderColor: DuangColor.DarkBlue, buttonImage: DuangImage.Comment, post: thePost, tapAction: showCommentPost)
            let buttonLike = DuangTableDataSection.DuangTableDataRow.ButtonItem(buttonText: "\(thePost[TablePost.LikeCount])", buttonTextColor: DuangColor.DarkBlue, buttonBackgroundColor: DuangColor.Orange, borderColor: DuangColor.DarkBlue, buttonImage: DuangImage.Like, post: thePost, tapAction: unlikePost)*/
            let buttonArray = [buttonShare, buttonComment, buttonLike]
            return DuangTableDataSection.DuangTableDataRow.Buttons(buttonArray: buttonArray, post: thePost)
        }
        return nil
    }
    
    func rowButtonsForComment() -> DuangTableDataSection.DuangTableDataRow? {
        let button = DuangTableDataSection.DuangTableDataRow.ButtonItem(buttonText: "Leave a comment", buttonTextColor: DuangColor.DarkBlue, buttonBackgroundColor: DuangColor.Orange, borderColor: DuangColor.DarkBlue, buttonImage: DuangImage.Share, function: DuangTableDataSection.function0(changePasswordDone))
        let buttonArray = [button]
        return DuangTableDataSection.DuangTableDataRow.Buttons(buttonArray: buttonArray, post: nil)
    }
    */
    
    
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
            if let cell = tableView.dequeueReusableCellWithIdentifier(row.cellIdentifier(), forIndexPath: indexPath) as? DuangTableCellUserBig {
                cell.userName = userName
                cell.userDescription = userDescription
                cell.userAvatarPlaceholder = userAvatarPlaceholder
                cell.userAvatarFile = userAvatarFile
                cell.userBannerPlaceholder = userBannerPlaceholder
                cell.userBannerFile = userBannerFile
                cell.reloadView()
                return cell
            }
            
        case .ImageMutable(let photos, _):
            if let cell = tableView.dequeueReusableCellWithIdentifier(row.cellIdentifier(), forIndexPath: indexPath) as? DuangTableCellImageMutable {
                cell.photos = photos
                return cell
            }
            
        case .ImageBig(_, let imagePlaceholder, let imageFile, _):
            if let cell = tableView.dequeueReusableCellWithIdentifier(row.cellIdentifier(), forIndexPath: indexPath) as? DuangTableCellImageBig {
                cell.imagePlaceholder = imagePlaceholder
                cell.imageFile = imageFile
                cell.reloadView()
                return cell
            }
            
        case .ImageSmall(let imageTitle, let imagePlaceholder, let imageFile, let isRound, _):
            if let cell = tableView.dequeueReusableCellWithIdentifier(row.cellIdentifier(), forIndexPath: indexPath) as? DuangTableCellImageSmall {
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell.imageTitle = imageTitle
                cell.imagePlaceholder = imagePlaceholder
                cell.imageFile = imageFile
                cell.isRound = isRound
                cell.reloadView()
                return cell
            }
            
        case .TextView(let placeholder):
            if let cell = tableView.dequeueReusableCellWithIdentifier(row.cellIdentifier(), forIndexPath: indexPath) as? DuangTableCellTextView {
                cell.delegate = self
                cell.placeholder = placeholder
                cell.reloadView()
                duangTableCellTextView = cell
                return cell
            }
            
        case .TextField(let placeholder):
            if let cell = tableView.dequeueReusableCellWithIdentifier(row.cellIdentifier(), forIndexPath: indexPath) as? DuangTableCellTextField {
                cell.delegate = self
                cell.placeholder = placeholder
                cell.reloadView()
                addDuangTableCellTextField(cell)///
                return cell
            }
            
        case .Label(_, let text, let font):
            if let cell = tableView.dequeueReusableCellWithIdentifier(row.cellIdentifier(), forIndexPath: indexPath) as? DuangTableCellLabel {
                cell.theLabelText = text
                cell.theLabelFont = font
                cell.reloadView()
                return cell
            }
            
        case .Button(let buttonText, let buttonTextColor, let buttonBackgroundColor, _):
            if let cell = tableView.dequeueReusableCellWithIdentifier(row.cellIdentifier(), forIndexPath: indexPath) as? DuangTableCellButton {
                cell.buttonText = buttonText
                cell.buttonTextColor = buttonTextColor
                cell.buttonBackgroundColor = buttonBackgroundColor
                cell.reloadView()
                return cell
            }
            
        case .DefaultRightDetail(let titleText, let detailText, _):
            let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: row.cellIdentifier())
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.textLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
            cell.textLabel?.text = titleText
            cell.detailTextLabel?.text = detailText
            return cell
            
        case .Buttons(let buttonArray, let post):
            if let cell = tableView.dequeueReusableCellWithIdentifier(row.cellIdentifier(), forIndexPath: indexPath) as? DuangTableCellButtons {
                cell.delegate = self
                
                switch tableType {
                case .Feed:
                    if let thePost = post {
                        APIManager.sharedInstance.hasLikedPost(thePost, hasLiked: { (hasLiked) -> () in
                            switch self.duangTableData.sectionArray[indexPath.section].rowArray[indexPath.row] {
                            case .Buttons(var buttonArray, let post):
                                var theLikeCount = "0"
                                if let likeCount = thePost[TablePost.LikeCount] as? NSNumber {
                                    theLikeCount = "\(likeCount)"
                                }
                                if hasLiked {
                                    buttonArray[2] = DuangTableDataSection.buttonItemTitleImageSelected(theLikeCount, buttonImage: DuangImage.Like, function: DuangTableDataSection.function1PFObject(self.unlikePost, argument: thePost))
                                } else {
                                    buttonArray[2] = DuangTableDataSection.buttonItemTitleImageNormal(theLikeCount, buttonImage: DuangImage.Like, function: DuangTableDataSection.function1PFObject(self.likePost, argument: thePost))
                                }
                                self.duangTableData.sectionArray[indexPath.section].rowArray[indexPath.row] = DuangTableDataSection.DuangTableDataRow.Buttons(buttonArray: buttonArray, thePFObject: post)
                            default:
                                break
                            }
                            
                            switch self.duangTableData.sectionArray[indexPath.section].rowArray[indexPath.row] {
                            case .Buttons(var buttonArray, _):
                                cell.buttonArray = buttonArray
                                cell.reloadView()
                            default:
                                break
                            }
                        })
                    }
                case .Comment:
                    cell.buttonArray = buttonArray
                    cell.reloadView()
                default:
                    cell.buttonArray = buttonArray
                    cell.reloadView()
                }
                return cell
            }
            
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
    
    // MARK: - UIRefreshControl
    
    var refreshControl: UIRefreshControl!
    
    func addRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "beginRefreshing", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func beginRefreshing()
    {
        APIManager.sharedInstance.getPostArray({ (objectArray) -> () in
            self.setDuangTableDataFromPost(objectArray)
            self.endRefreshing()
        }, failure: { (error) -> () in
            self.endRefreshing()
        })
    }
    
    func endRefreshing() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.refreshControl.endRefreshing()
        })
    }
    
    // MARK: - DuangTableViewControllerProtocol
    
    enum DuangTableDataDeliverer {
        case Input(inputText: String)
        case AddPhoto(imageSelected: UIImage, descriptionText: String)
        
        case ImageText(image: UIImage, text: String)
        case Text(text: String)
    }
    
    var delegate: DuangTableViewControllerProtocol?
    
    func handleDuangTableDataDeliverer(dataDeliverer: DuangTableViewController.DuangTableDataDeliverer) {
        
        switch tableType {
        case .Comment:
            switch dataDeliverer {
            case .ImageText(let image, let text):
                if let post = dataFromPreviousViewPost {
                    APIManager.sharedInstance.addNewComment(post, image: image, commentText: text, success: { () -> () in
                        println("success")
                        }, failure: { (error) -> () in
                            println("failure")
                    })
                }
                
            default:
                break
            }
        default:
            break
        }

        
        
        
        ///////////////////////////
        /*
        switch dataDeliverer {
        case .Input(let inputText):
            var ifChangeText = true
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
                switch duangTableData.sectionArray[selectedIndexPath.section].sectionTitleForHeader {
                case TitleName.InputUsername:
                    if let errorString = APIManager.sharedInstance.setCurrentUserUsername(inputText) {
                        var deleteAlert = UIAlertController(title: "Sorry", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                        deleteAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in }))
                        presentViewController(deleteAlert, animated: true, completion: nil)
                        ifChangeText = false
                    }
                case TitleName.InputEmail:
                    if let errorString = APIManager.sharedInstance.setCurrentUserEmail(inputText) {
                        var deleteAlert = UIAlertController(title: "Sorry", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                        deleteAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in }))
                        presentViewController(deleteAlert, animated: true, completion: nil)
                        ifChangeText = false
                    }
                default:
                    break
                }
            default:
                break
            }
            if ifChangeText {
                duangTableData.sectionArray[selectedIndexPath.section].rowArray[selectedIndexPath.row] = DuangTableDataSection.DuangTableDataRow.DefaultRightDetail(titleText: inputText, detailText: "", tapAction: showInput)
                tableView.reloadData()
            }
        case .AddPhoto(let imageSelected, let descriptionText):
            let sectionCount = duangTableData.sectionArray.count
            
            var section = DuangTableDataSection()
            section.rowArray.append(DuangTableDataSection.DuangTableDataRow.ImageSmall(imageTitle: descriptionText, imagePlaceholder: imageSelected, imageFile: nil, isRound: false, tapAction: DuangTableDataSection.function0(selectImage)))
            duangTableData.sectionArray.insert(section, atIndex: duangTableData.sectionArray.count - 2)
            tableView.reloadData()
        }*/
    }

    // MARK: - DuangTableCellButtonsProtocol
    
    func duangTableCellButtonsAction(duangTableDataRowItem: DuangTableDataSection.DuangTableDataRowItem) {
        duangTableDataRowItem.functionAction()
    }
    
    func likePost(post: PFObject?) {
        if let thePost = post {
            APIManager.sharedInstance.likePost(thePost, success: { () -> () in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            })
        }
    }
    
    func unlikePost(post: PFObject?) {
        if let thePost = post {
            APIManager.sharedInstance.unlikePost(thePost, success: { () -> () in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            })
        }
    }
    
    func sharePost(post: PFObject?) {
        if let thePost = post {
            moveInputView()
        }
    }
    
    
    // MARK: - DuangTableCellTextView
    
    var duangTableCellTextView: DuangTableCellTextView?
    
    // MARK: DuangTableCellTextViewProtocol
    
    func duangTableCellTextViewDoneAction() {
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
        if let availableMediaTypes = UIImagePickerController.availableMediaTypesForSourceType(sourceType) as? [String] {
            for type in availableMediaTypes {
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
                if let stringType = type as? String {
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
    
    // MARK: - Main Input View
    
    @IBOutlet weak var mainInputView: UIView!
    @IBOutlet weak var mainInputViewTextField: UITextField!
//        {
//        didSet {
//            mainInputViewTextField.delegate = self
//        }
//    }
    
    // MARK: - Keyboard Notification
    
    func keyboardWillShow(notification: NSNotification) {
        keyboardNotificationDictionary = NSDictionary(dictionary: notification.userInfo!)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        keyboardNotificationDictionary = NSDictionary()
    }
    
    func keyboardWillChangeFrame(notification: NSNotification) {
        keyboardNotificationDictionary = NSDictionary(dictionary: notification.userInfo!)
    }
    
    var keyboardNotificationDictionary: NSDictionary = NSDictionary() {
        didSet {
//            moveMainInputViewForKeyboard()
            moveInputView()
        }
    }
    
    func moveInputView() {
        var duration: Double = 0.2
        let space: CGFloat = 0.0
        
        if let durationForKeyboard = keyboardNotificationDictionary.objectForKey(UIKeyboardAnimationDurationUserInfoKey) as? Double {
            duration = durationForKeyboard
        }
        
        if let value: NSValue = keyboardNotificationDictionary.objectForKey(UIKeyboardFrameEndUserInfoKey) as? NSValue {
            let keyboardSize = value.CGRectValue().size
            let moveDistanced = DuangGlobal.screenHeight - mainInputView.frame.size.height - keyboardSize.height - space
            UIView.animateWithDuration(duration, animations: { () -> Void in
                
                println("before self.mainInputView.frame = \(self.mainInputView.frame)")
                
                self.mainInputView.frame = CGRectMake(self.mainInputView.frame.origin.x, moveDistanced, self.mainInputView.frame.size.width, self.mainInputView.frame.size.height)
                
                println("after self.mainInputView.frame = \(self.mainInputView.frame)")
            })
        } else {
            UIView.animateWithDuration(duration, animations: { () -> Void in
                self.mainInputView.frame = CGRectMake(self.mainInputView.frame.origin.x, DuangGlobal.screenHeight - self.mainInputView.frame.size.height, self.mainInputView.frame.size.width, self.mainInputView.frame.size.height)
            })
        }
    }
    
    func moveMainInputViewForKeyboard() {
        if let value: NSValue = keyboardNotificationDictionary.objectForKey(UIKeyboardFrameEndUserInfoKey) as? NSValue {
            let keyboardSize = value.CGRectValue().size
//            let textFieldFirstResponderRect = view.convertRect(textFieldFirstResponder.frame, fromView: buttonsView)
//            let moveDistanced = view.frame.height - textFieldFirstResponderRect.origin.y - textFieldFirstResponderRect.size.height - keyboardSize.height - 70
            
            
//            let mainInputViewY = DuangGlobal.screenHeight - keyboardSize.height - self.mainInputView.frame.height
            
            println("keyboardSize = \(keyboardSize)")
            println("self.mainInputView.frame  = \(self.mainInputView.frame)")
            
            println("Y = \(DuangGlobal.screenHeight - keyboardSize.height - self.mainInputView.frame.height)")
            
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.mainInputView.frame = CGRectMake(self.mainInputView.frame.origin.x, DuangGlobal.screenHeight - keyboardSize.height - self.mainInputView.frame.height, self.mainInputView.frame.width, self.mainInputView.frame.height)
            })
        } else {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.mainInputView.frame = CGRectMake(self.mainInputView.frame.origin.x, DuangGlobal.screenHeight, self.mainInputView.frame.width, self.mainInputView.frame.height)
            })
        }
    }
    
    func prepareForMainInputView() {
        /*
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillChangeFrame:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        mainInputView.hidden = false
        mainInputViewTextField.becomeFirstResponder()
        
        var inputBar = UIView(frame: CGRectMake(0.0, DuangGlobal.screenHeight - 40.0, DuangGlobal.screenWidth, 40.0))
        */
    }
    
//    var textFieldFirstResponder: UITextField = UITextField() {
//        didSet {
//            moveTextFieldForKeyboard()
//        }
//    }
    
}
