//
//  DTableViewController.swift
//  Duang
//
//  Created by David Yu on 15/4/21.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol DTableViewControllerProtocol
{
    func protocolSignUpSuccess()
    func protocolLogInSuccess()
    
    func protocolReloadData()
}

class DTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, DTableViewControllerProtocol, DTableViewModelProtocol, DTableViewCellButtonsProtocol, DTableViewCellTextViewProtocol, DTableViewCellDetailProtocol
{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dTableViewModel.delegate = self
        
        addRefreshControl()
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
    
    func protocolReloadData() {
        
    }
    
    // MARK: - Data
    
    var selectedModelRow: DTableViewModelRow?
    
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
        case .WaterfallPhoto(_), .WaterfallUser(_):
            endRefreshing()
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
            case .Buttons(_):
                if let cell = tableView.dequeueReusableCellWithIdentifier(modelRow.cellIdentifier(), forIndexPath: indexPath) as? DTableViewCellButtons {
                    cell.delegate = self
                    cell.modelRow = modelRow
                    cell.reloadView()
                    return cell
                }
                
            case .ButtonsWaterfall(_):
                if let cell = tableView.dequeueReusableCellWithIdentifier(modelRow.cellIdentifier(), forIndexPath: indexPath) as? DTableViewCellButtons {
                    cell.delegate = self
                    cell.modelRow = modelRow
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
            case .ImageMutable(let collection):
                if let cell = tableView.dequeueReusableCellWithIdentifier(modelRow.cellIdentifier(), forIndexPath: indexPath) as? DTableViewCellImageMutable {
                    cell.modelRow = modelRow
                    cell.reloadView()
                    return cell
                }
            case .DetailImage(_), .DetailUser(_):
                if let cell = tableView.dequeueReusableCellWithIdentifier(modelRow.cellIdentifier(), forIndexPath: indexPath) as? DTableViewCellDetail {
                    cell.delegate = self
                    cell.modelRow = modelRow
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
                
            case .TextView(_):
                if let cell = tableView.dequeueReusableCellWithIdentifier(modelRow.cellIdentifier(), forIndexPath: indexPath) as? DTableViewCellTextView {
                    cell.delegate = self
                    cell.modelRow = modelRow
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
        
        switch dTableViewModel.sectionArray[indexPath.section].rowArray[indexPath.row].rowType {
        case .DetailUser(let user, _):
            if let theUser = user {
                if theUser != PFUser.currentUser() {
                    showProfile(theUser)
                }
            }
        default:
            break
        }
    }
    
    // MARK: - UIRefreshControl
    
    var refreshControl: UIRefreshControl!
    
    func addRefreshControl() {
        switch dTableViewModel.tableType {
        case .WaterfallPhoto(_), .WaterfallUser(_):
            refreshControl = UIRefreshControl()
            refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
            refreshControl.addTarget(self, action: "beginRefreshingFeed", forControlEvents: UIControlEvents.ValueChanged)
            tableView.addSubview(refreshControl)
        default:
            break
        }
        
    }
    
    func beginRefreshingFeed()
    {
        dTableViewModel.waterfallInit()
    }
    
    func endRefreshing() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.refreshControl.endRefreshing()
        })
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let inset = scrollView.contentInset
        let y = offset.y + bounds.size.height - inset.bottom
        let h = size.height
        
        let reload_distance: CGFloat = 10
        if y > h + reload_distance {
            loadMoreData()
        }
    }
    
    func loadMoreData() {
        switch dTableViewModel.tableType {
        case .WaterfallPhoto(_), .WaterfallUser(_):
            dTableViewModel.pageMore()
        default:
            break
        }
    }
    
    // MARK: - Cell DTableViewCellButtonsProtocol
    
    func dTableViewCellButtonsAction(buttonItem: DTableViewModelRow.ButtonItem) {
        buttonItem.functionAction()
    }
    
    func dTableViewCellButtonsActionLike(photo: PFObject) {
        APIManager.likePhoto(photo)
    }
    
    func dTableViewCellButtonsActionUnlike(photo: PFObject) {
        APIManager.unlikePhoto(photo)
    }
    
    func dTableViewCellButtonsActionComment(photo: PFObject) {
        showComment(photo)
    }
    
    func dTableViewCellButtonsActionShare(photo: PFObject) {
        
    }
    
    // MARK: - Cell DTableViewCellDetailProtocol
    
    func dTableViewCellDetailButtonAction(modelRow: DTableViewModelRow) {
        selectedModelRow = modelRow
        
        switch modelRow.rowType {
        case .DetailImage(_, _, _, let detailButtonItem):
            detailButtonItem?.functionAction()
//        case .DetailUser(_, let detailButtonItem):
//            detailButtonItem?.functionAction()
        case .DetailUser(_, let detailButtonType):
            if let theDetailButtonType = detailButtonType {
                switch theDetailButtonType {
                case .ButtonItem(let buttonItem):
                    buttonItem.functionAction()
                default:
                    break
                }
            }
        default:
            break
        }
    }
    
    func dTableViewCellDetailButtonActionFollow(user: PFUser) {
        APIManager.followUser(user)
    }
    
    func dTableViewCellDetailButtonActionUnfollow(user: PFUser) {
        APIManager.unfollowUser(user)
    }
    
    // MARK: - Cell DTableViewCellTextView
    
    var textViewArray = [DTableViewCellTextView]()
    var textViewModelRowArray = [DTableViewModelRow]()
    var textViewIfGoNext = true
    var textViewFirstResponder = DTableViewCellTextView()
    
    func addTextView(textView: DTableViewCellTextView, modelRow: DTableViewModelRow) {
        for temTextView in textViewArray {
            if temTextView == textView {
                return
            }
        }
        textViewArray.append(textView)
        textViewModelRowArray.append(modelRow)
    }
    
    func getTextArrayFromTextViewArray() -> [String] {
        textViewIfGoNext = false
        textViewFirstResponder.cellTextView.resignFirstResponder()
        
        var textArray = [String]()
        for var index = 0; index < textViewModelRowArray.count; ++index {
            switch textViewModelRowArray[index].rowType {
            case .TextView(_, _, let textViewText, _):
                textArray.append(textViewText ?? "")
            default:
                break
            }
        }
        return textArray
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
    
    func dTableViewCellTextViewDidBeginEditing(dTableViewCellTextView: DTableViewCellTextView) {
        textViewIfGoNext = true
        textViewFirstResponder = dTableViewCellTextView
    }
    
    func dTableViewCellTextViewDidEndEditing(dTableViewCellTextView: DTableViewCellTextView) {
        for var index = 0; index < textViewArray.count; ++index {
            if dTableViewCellTextView == textViewArray[index] {
                var modelRow = textViewModelRowArray[index]
                if let theTextViewText = dTableViewCellTextView.cellTextView.text {
                    switch modelRow.rowType {
                    case .TextView(let heightForRow, let textViewTitle, _, let textViewTitleWidth):
                        modelRow.rowType = DTableViewModelRow.RowType.TextView(heightForRow: heightForRow, textViewTitle: textViewTitle, textViewText: theTextViewText, textViewTitleWidth: textViewTitleWidth)
                    default:
                        break
                    }
                }
                if textViewIfGoNext && index < textViewArray.count - 1 {
                    let nextTextView = textViewArray[index + 1]
                    nextTextView.cellTextView.becomeFirstResponder()
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
        case .Profile(let user):
            if user == PFUser.currentUser() {
                dTableViewModel.functionShowSettings = DTableViewModelRow.Function.Function(argumentCount: 0, function: showSettings)
            }
            let argument = DTableViewModelRow.Function.Argument.User(user: user)
            dTableViewModel.functionShowWaterfallPhotoUser = DTableViewModelRow.Function.Function1Argument(argument: argument, function: showWaterfallPhotoUser)
            dTableViewModel.functionShowWaterfallPhotoLike = DTableViewModelRow.Function.Function1Argument(argument: argument, function: showWaterfallPhotoLike)
            dTableViewModel.functionShowWaterfallUserFollowing = DTableViewModelRow.Function.Function1Argument(argument: argument, function: showWaterfallUserFollowing)
            dTableViewModel.functionShowWaterfallUserFollower = DTableViewModelRow.Function.Function1Argument(argument: argument, function: showWaterfallUserFollower)
            dTableViewModel.functionShowAddCollection = DTableViewModelRow.Function.Function(argumentCount: 0, function: showAddCollection)
            
        case .Settings:
            dTableViewModel.functionShowEditProfile = DTableViewModelRow.Function.Function(argumentCount: 0, function: showEditProfile)
            dTableViewModel.functionShowAccountSettings = DTableViewModelRow.Function.Function(argumentCount: 0, function: showAccountSettings)
            dTableViewModel.functionLogOut = DTableViewModelRow.Function.Function(argumentCount: 0, function: logOut)
        case .EditProfile:
            dTableViewModel.functionEditAvatar = DTableViewModelRow.Function.Function(argumentCount: 0, function: selectImage)
            dTableViewModel.functionEditBanner = DTableViewModelRow.Function.Function(argumentCount: 0, function: selectImage)
            dTableViewModel.functionSaveEditProfile = DTableViewModelRow.Function.Function(argumentCount: 0, function: saveEditProfile)
        case .AccountSettings:
            dTableViewModel.functionSaveAccountSettings = DTableViewModelRow.Function.Function(argumentCount: 0, function: saveAccountSettings)
            dTableViewModel.functionShowChangePassword = DTableViewModelRow.Function.Function(argumentCount: 0, function: showChangePassword)
        case .ChangePassword:
            dTableViewModel.functionSaveChangePassword = DTableViewModelRow.Function.Function(argumentCount: 0, function: saveChangePassword)
        case .AddPhoto:
            dTableViewModel.functionAddPhoto = DTableViewModelRow.Function.Function(argumentCount: 0, function: selectImage)
            dTableViewModel.functionSaveAddPhoto = DTableViewModelRow.Function.Function(argumentCount: 0, function: saveAddPhoto)
        case .AddCollection:
            dTableViewModel.functionSaveAddCollection = DTableViewModelRow.Function.Function(argumentCount: 0, function: saveAddCollection)
        case .WaterfallComment(let photo):
            
            let argument = DTableViewModelRow.Function.Argument.Object(object: photo)
            dTableViewModel.functionSaveComment = DTableViewModelRow.Function.Function1Argument(argument: argument, function: saveComment)
            
            
        default:
            break
        }
    }
    
    // MARK: - Show ViewController
    
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
    
    func showSettings() {
        showDTableViewController(DTableViewModel.TableType.Settings)
    }
    
    func showEditProfile() {
        showDTableViewController(DTableViewModel.TableType.EditProfile)
    }
    
    func showAccountSettings() {
        showDTableViewController(DTableViewModel.TableType.AccountSettings)
    }
    
    func showChangePassword() {
        showDTableViewController(DTableViewModel.TableType.ChangePassword)
    }
    
    func showAddCollection() {
        showDTableViewController(DTableViewModel.TableType.AddCollection)
    }
    
    func showMainTabBarController() {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MainTabBarController") as? MainTabBarController {
            navigationController?.presentViewController(viewController, animated: true, completion: nil)
        }
    }
    
    func showComment(photo: PFObject) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DTableViewController") as? DTableViewController {
            viewController.delegate = self
            viewController.dTableViewModel.tableType = DTableViewModel.TableType.WaterfallComment(photo: photo)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    // MARK: Waterfall Photo
    
    func showWaterfallPhotoUser(argumentPFUser: DTableViewModelRow.Function.Argument) {
        switch argumentPFUser {
        case .User(let user):
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DTableViewController") as? DTableViewController {
                viewController.delegate = self
                viewController.dTableViewModel.tableType = DTableViewModel.TableType.WaterfallPhoto(type: DTableViewModel.WaterfallPhotoType.User(user: user))
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        default:
            break
        }
    }
    
    func showWaterfallPhotoLike(argumentPFUser: DTableViewModelRow.Function.Argument) {
        switch argumentPFUser {
        case .User(let user):
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DTableViewController") as? DTableViewController {
                viewController.delegate = self
                viewController.dTableViewModel.tableType = DTableViewModel.TableType.WaterfallPhoto(type: DTableViewModel.WaterfallPhotoType.Like(user: user))
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        default:
            break
        }
    }
    
    // MARK: Waterfall User
    
    func showWaterfallUserFollowing(argumentPFUser: DTableViewModelRow.Function.Argument) {
        switch argumentPFUser {
        case .User(let user):
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DTableViewController") as? DTableViewController {
                viewController.delegate = self
                viewController.dTableViewModel.tableType = DTableViewModel.TableType.WaterfallUser(type: DTableViewModel.WaterfallUserType.Following(user: user))
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        default:
            break
        }
    }
    
    func showWaterfallUserFollower(argumentPFUser: DTableViewModelRow.Function.Argument) {
        switch argumentPFUser {
        case .User(let user):
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DTableViewController") as? DTableViewController {
                viewController.delegate = self
                viewController.dTableViewModel.tableType = DTableViewModel.TableType.WaterfallUser(type: DTableViewModel.WaterfallUserType.Follower(user: user))
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        default:
            break
        }
    }
    
    // MARK: Profile
    
    func showProfile(user: PFUser) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DTableViewController") as? DTableViewController {
            viewController.delegate = self
            viewController.dTableViewModel.tableType = DTableViewModel.TableType.Profile(user: user)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    // MARK: - Save
    
    func saveEditProfile() {
        switch dTableViewModel.sectionArray[0].rowArray[0].rowType {
        case .DetailImage(let image, _, _, _):
            if let theImage = image {
                APIManager.sharedInstance.setCurrentUserAvatar(theImage)
            }
        default:
            break
        }
        
        switch dTableViewModel.sectionArray[0].rowArray[1].rowType {
        case .DetailImage(let image, _, _, _):
            if let theImage = image {
                APIManager.sharedInstance.setCurrentUserBanner(theImage)
            }
        default:
            break
        }
        
        let textArray = getTextArrayFromTextViewArray()
        
        let firstName = textArray[0]
        let lastName = textArray[1]
        let description = textArray[2]
        
        APIManager.sharedInstance.setCurrentUserFirstName(firstName)
        APIManager.sharedInstance.setCurrentUserLastName(lastName)
        APIManager.sharedInstance.setCurrentUserDescription(description)
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    func saveAccountSettings() {
        let textArray = getTextArrayFromTextViewArray()
        
        let email = textArray[0]
        
        if let errorString = APIManager.sharedInstance.setCurrentUserEmail(email) {
            showAlert("Sorry", message: errorString)
        } else {
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func saveChangePassword() {
        let textArray = getTextArrayFromTextViewArray()
        
        let oldPassword = textArray[0]
        let newPassword = textArray[1]
        let retypePassword = textArray[2]
        
        if newPassword == retypePassword {
            if let errorString = APIManager.sharedInstance.changePassword(oldPassword, newPassword: newPassword) {
                showAlert("Sorry", message: errorString)
            } else {
                navigationController?.popViewControllerAnimated(true)
            }
        } else {
            showAlert("Sorry", message: "New password don't match.")
        }
    }
    
    func saveComment(argumentPFObject: DTableViewModelRow.Function.Argument) {
        switch argumentPFObject {
        case .Object(let object):
            let photo = object
            
            let textArray = getTextArrayFromTextViewArray()
            let message = textArray[0]
            
            if message == "" {
                showAlert("Sorry", message: "Comment is empty.")
            } else {
                APIManager.addComment(photo, message: message)
                dTableViewModel.addComment(photo, message: message)
                tableView.reloadData()
            }
            
            
        default:
            break
        }
    }
    
    func saveAddPhoto() {
        if dTableViewModel.sectionArray.count == 3 {
            showAlert("Sorry", message: "Please select a photo.")
        } else if dTableViewModel.sectionArray.count == 4 {
            switch dTableViewModel.sectionArray[0].rowArray[0].rowType {
            case .Image(_, let image, _, _):
                if let theImage = image {
                    let textArray = getTextArrayFromTextViewArray()
                    let description = textArray[0]
                    
                    APIManager.sharedInstance.addNewPhoto(theImage, description: description, success: { () -> () in
                        self.showAlert("Success", message: "Success.")
                        }, failure: { (error) -> () in
                            
                    })
                }
            default:
                break
            }
        }
    }
    
    func saveAddCollection() {
        let textArray = getTextArrayFromTextViewArray()
        let name = textArray[0]
        
        if name == "" {
            showAlert("Sorry", message: "Name is empty.")
        } else {
            APIManager.addPhotoCollection(name, success: { () -> () in
                self.delegate?.protocolReloadData()
                self.navigationController?.popViewControllerAnimated(true)
            })
        }
    }
    
    // MARK: - Select Image
    
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
    
    // MARK: Camera
    
    var imagePickerController: UIImagePickerController?
    
    func takePhoto() {
        if isCameraAvailable() && doesCameraSupportTakingPhotos() {
            imagePickerController = UIImagePickerController()
            if let theController = imagePickerController {
                theController.sourceType = UIImagePickerControllerSourceType.Camera
                theController.mediaTypes = [kUTTypeImage as String]
                theController.allowsEditing = false
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
            theController.allowsEditing = false
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
                theController.allowsEditing = false
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
                        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
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
        switch dTableViewModel.tableType {
        case .AddPhoto:
            let row = DTableViewModelRow()
            let section = DTableViewModelSection()
            let heightForRow = UIScreen.mainScreen().bounds.width * image.size.height / image.size.width
            row.rowType = DTableViewModelRow.RowType.Image(heightForRow: heightForRow, image: image, imageFile: nil, function: nil)
            section.rowArray.append(row)
            
            if dTableViewModel.sectionArray.count == 3 {
                dTableViewModel.sectionArray.insert(section, atIndex: 0)
            } else if dTableViewModel.sectionArray.count == 4 {
                dTableViewModel.sectionArray[0] = section
            }
            tableView.reloadData()
            
        default:
            if var theSelectedModelRow = selectedModelRow {
                switch theSelectedModelRow.rowType {
                case .DetailImage(_, let imageFile, let detailTitle, let detailButtonItem):
                    theSelectedModelRow.rowType = DTableViewModelRow.RowType.DetailImage(image: image, imageFile: imageFile, detailTitle: detailTitle, detailButtonItem: detailButtonItem)
                    tableView.reloadData()
                default:
                    break
                }
            }
        }
        
        
    }
    
    // MARK: - SignUp
    
    func signUp() {
        let textArray = getTextArrayFromTextViewArray()
        
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
        let textArray = getTextArrayFromTextViewArray()
        
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

    // MARK: LogOut
    
    func logOut() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

}
