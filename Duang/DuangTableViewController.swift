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
        case AddPhoto
    }
    
    var tableType: TableType?
    
    func checkTableType() {
        if let type = tableType {
            var section = DuangTableDataSection()
            switch type {
            case TableType.Profile:// MARK: Profile
                titleString = "Me"
                
                // Profile Picture
                section = DuangTableDataSection.initSection(sectionTitleForHeader: "",
                    rowType: DuangTableDataRow.RowType.UserBig,
                    textArray: ["\(APIManager.sharedInstance.getCurrentUserFirstName()) \(APIManager.sharedInstance.getCurrentUserLastName())", APIManager.sharedInstance.getCurrentUserDescription()],
                    imageFileArray: [APIManager.sharedInstance.getCurrentUserAvatarFile(), APIManager.sharedInstance.getCurrentUserBannerFile()],
                    imageArray: nil,
                    colorArray: nil,
                    function: DuangTableDataRow.Function.Function1(showEditUser))
                duangTableData.sectionArray.append(section)
                
                // Add a Photo
                section = DuangTableDataSection.initSection(sectionTitleForHeader: "",
                    rowType: DuangTableDataRow.RowType.Button,
                    textArray: ["Add a Photo"],
                    imageFileArray: nil,
                    imageArray: nil,
                    colorArray: [DuangColor.ButtonNormal, DuangColor.ButtonNormalBackground],
                    function: DuangTableDataRow.Function.Function1(showAddPhoto))
                duangTableData.sectionArray.append(section)
                
                // Setting
                section = DuangTableDataSection.initSection(sectionTitleForHeader: "",
                    rowType: DuangTableDataRow.RowType.DefaultRightDetail,
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
                    textArray: [TitleName.ImageProfilePicture],
                    imageFileArray: [APIManager.sharedInstance.getCurrentUserAvatarFile()],
                    imageArray: nil,
                    colorArray: nil,
                    function: DuangTableDataRow.Function.Function1(selectImage))
                duangTableData.sectionArray.append(section)
                
                // Banner Picture
                section = DuangTableDataSection.initSection(sectionTitleForHeader: nil,
                    rowType: DuangTableDataRow.RowType.UserSmall,
                    textArray: [TitleName.ImageBannerPicture],
                    imageFileArray: [APIManager.sharedInstance.getCurrentUserBannerFile()],
                    imageArray: nil,
                    colorArray: nil,
                    function: DuangTableDataRow.Function.Function1(selectImage))
                duangTableData.sectionArray.append(section)
                
                // First Name
                section = DuangTableDataSection.initSection(sectionTitleForHeader: TitleName.InputFirstName,
                    rowType: DuangTableDataRow.RowType.DefaultRightDetail,
                    textArray: [APIManager.sharedInstance.getCurrentUserFirstName()],
                    imageFileArray: nil,
                    imageArray: nil,
                    colorArray: nil,
                    function: DuangTableDataRow.Function.Function1(showInput))
                duangTableData.sectionArray.append(section)
                
                // Last Name
                section = DuangTableDataSection.initSection(sectionTitleForHeader: TitleName.InputLastName,
                    rowType: DuangTableDataRow.RowType.DefaultRightDetail,
                    textArray: [APIManager.sharedInstance.getCurrentUserLastName()],
                    imageFileArray: nil,
                    imageArray: nil,
                    colorArray: nil,
                    function: DuangTableDataRow.Function.Function1(showInput))
                duangTableData.sectionArray.append(section)
                
                // Description
                section = DuangTableDataSection.initSection(sectionTitleForHeader: TitleName.InputAboutYou,
                    rowType: DuangTableDataRow.RowType.DefaultRightDetail,
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
                    textArray: nil,
                    imageFileArray: nil,
                    imageArray: nil,
                    colorArray: nil,
                    function: nil)
                duangTableData.sectionArray.append(section)
                
                // Done
                section = DuangTableDataSection.initSection(sectionTitleForHeader: nil,
                    rowType: DuangTableDataRow.RowType.Button,
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
                    textArray: [APIManager.sharedInstance.getCurrentUserUsername()],
                    imageFileArray: nil,
                    imageArray: nil,
                    colorArray: nil,
                    function: DuangTableDataRow.Function.Function1(showInput))
                duangTableData.sectionArray.append(section)
                
                // Password
                section = DuangTableDataSection.initSection(sectionTitleForHeader: "Password",
                    rowType: DuangTableDataRow.RowType.DefaultRightDetail,
                    textArray: ["Change Password"],
                    imageFileArray: nil,
                    imageArray: nil,
                    colorArray: nil,
                    function: DuangTableDataRow.Function.Function1(showChangePassword))
                duangTableData.sectionArray.append(section)
                
                // Email
                section = DuangTableDataSection.initSection(sectionTitleForHeader: TitleName.InputEmail,
                    rowType: DuangTableDataRow.RowType.DefaultRightDetail,
                    textArray: [APIManager.sharedInstance.getCurrentUserEmail()],
                    imageFileArray: nil,
                    imageArray: nil,
                    colorArray: nil,
                    function: DuangTableDataRow.Function.Function1(showInput))
                duangTableData.sectionArray.append(section)
                
                // Log out
                section = DuangTableDataSection.initSection(sectionTitleForHeader: nil,
                    rowType: DuangTableDataRow.RowType.Button,
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
                    textArray: ["password"],
                    imageFileArray: nil,
                    imageArray: nil,
                    colorArray: nil,
                    function: nil)
                duangTableData.sectionArray.append(section)
                
                // New Password
                section = DuangTableDataSection.initSection(sectionTitleForHeader: "New Password",
                    rowType: DuangTableDataRow.RowType.TextField,
                    textArray: ["password"],
                    imageFileArray: nil,
                    imageArray: nil,
                    colorArray: nil,
                    function: nil)
                duangTableData.sectionArray.append(section)
                
                // Retype Password
                section = DuangTableDataSection.initSection(sectionTitleForHeader: "Retype Password",
                    rowType: DuangTableDataRow.RowType.TextField,
                    textArray: ["password"],
                    imageFileArray: nil,
                    imageArray: nil,
                    colorArray: nil,
                    function: nil)
                duangTableData.sectionArray.append(section)
                
                // Done
                section = DuangTableDataSection.initSection(sectionTitleForHeader: nil,
                    rowType: DuangTableDataRow.RowType.Button,
                    textArray: ["Done"],
                    imageFileArray: nil,
                    imageArray: nil,
                    colorArray: nil,
                    function: DuangTableDataRow.Function.Function1(changePasswordDone))
                duangTableData.sectionArray.append(section)

                
            case TableType.AddPhoto:// MARK: AddPhoto
                titleString = "Add a Photo"
                
                // Photo
                section = DuangTableDataSection.initSection(sectionTitleForHeader: nil,
                    rowType: DuangTableDataRow.RowType.ImageSmall,
                    textArray: ["Photo"],
                    imageFileArray: nil,
                    imageArray: [APIManager.Placeholder.Image],
                    colorArray: nil,
                    function: DuangTableDataRow.Function.Function1(selectImage))
                duangTableData.sectionArray.append(section)
                
                // Description
                section = DuangTableDataSection.initSection(sectionTitleForHeader: TitleName.InputPhotoDescription,
                    rowType: DuangTableDataRow.RowType.DefaultRightDetail,
                    textArray: [""],
                    imageFileArray: nil,
                    imageArray: nil,
                    colorArray: nil,
                    function: DuangTableDataRow.Function.Function1(showInput))
                duangTableData.sectionArray.append(section)
                
                // Done
                section = DuangTableDataSection.initSection(sectionTitleForHeader: nil,
                    rowType: DuangTableDataRow.RowType.Button,
                    textArray: ["Done"],
                    imageFileArray: nil,
                    imageArray: nil,
                    colorArray: nil,
                    function: DuangTableDataRow.Function.Function1(addPhotoDone))
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
        viewController.tableType = TableType.AddPhoto
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func addPhotoDone() {
        if temImage == nil {
            var deleteAlert = UIAlertController(title: "Sorry", message: "The photo is empty.", preferredStyle: UIAlertControllerStyle.Alert)
            deleteAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in }))
            presentViewController(deleteAlert, animated: true, completion: nil)
        } else if temText == nil {
            var deleteAlert = UIAlertController(title: "Sorry", message: "The description is empty.", preferredStyle: UIAlertControllerStyle.Alert)
            deleteAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in }))
            presentViewController(deleteAlert, animated: true, completion: nil)
        } else {
            APIManager.sharedInstance.addNewPhoto(temImage!, description: temText!, success: { () -> () in
                println("ok")
            }, failure: { (error) -> () in
                
            })
        }
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
    
    func doneInput() {
        if let inputString = duangTableCellInput.inputTextView.text {
            delegate?.duangTableViewControllerInput(inputString)
        }
        navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: DuangTableCellInputProtocol
    
    func duangTableCellInputDoneAction() {
        doneInput()
    }
    
    // MARK: DuangTableViewControllerProtocol
    
    var delegate: DuangTableViewControllerProtocol?
    
    func duangTableViewControllerInput(inputString: NSString) {
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
    
    private struct TitleName {
        static let InputFirstName = "First Name"
        static let InputLastName = "Last Name"
        static let InputAboutYou = "About You"
        static let InputUsername = "Username"
        static let InputEmail = "Email"
        static let InputPhotoDescription = "Photo Description"
        
        static let ImageProfilePicture = "Profile Picture"
        static let ImageBannerPicture = "Banner Picture"
    }
    
    // MARK: - TableView Data
    
    var duangTableData = DuangTableData()
    
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
        if let rowType = duangTableData.sectionArray[indexPath.section].rowArray?[indexPath.row].rowType {
            switch rowType {
            case DuangTableDataRow.RowType.UserBig:
                return UIScreen.mainScreen().bounds.size.width
            case DuangTableDataRow.RowType.UserSmall:
                return 50.0
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
        return 0.0
    }
    
    private struct CellIdentifier {
        static let UserBig = "DuangTableCellUserBig"
        static let ImageSmall = "DuangTableCellImageSmall"
        static let Input = "DuangTableCellInput"
        static let Button = "DuangTableCellButton"
        static let TextField = "DuangTableCellTextField"
        static let DefaultCell = "DefaultCell"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let duangTableDataRow = duangTableData.sectionArray[indexPath.section].rowArray?[indexPath.row] {
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
