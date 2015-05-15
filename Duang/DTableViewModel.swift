//
//  DTableViewModel.swift
//  Duang
//
//  Created by David Yu on 15/4/21.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import Foundation

protocol DTableViewModelProtocol {
    func dataDidLoad()
}

class DTableViewModel
{
    var delegate: DTableViewModelProtocol?
    
    // MARK: - Status
    
    enum Status {
        case NoData
        case Normal
        case Updating
    }
    private var status = Status.NoData
    
    // MARK: - Data
    
    var viewControllerTitle = ""
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections() -> Int {
        switch status {
        case .NoData:
            return 0
        default:
            return sectionArray.count
        }
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        switch status {
        case .NoData:
            return 0
        default:
            return sectionArray[section].rowArray.count
        }
    }
    
    func titleForHeaderInSection(section: Int) -> String? {
        return sectionArray[section].titleForHeader
    }
    
    func heightForRowAtIndexPath(indexPath: NSIndexPath) -> CGFloat {
        if let row = row(indexPath) {
            return row.heightForRow()
        }
        return 50.0
    }
    
    // MARK: - TableType
    
    enum TableType {
        case Landing
        case SignUp
        case LogIn
        case Settings
        case EditProfile
        case AccountSettings
        case ChangePassword
        
        case AddPhoto
        case AddCollection
        
        case Profile(user: PFUser)
        
        case WaterfallPhoto(type: WaterfallPhotoType)
        case WaterfallUser(type: WaterfallUserType)
        case WaterfallComment(photo: PFObject)
    }
    
    enum WaterfallPhotoType {
        case Feed
        case User(user: PFUser)
        case Like(user: PFUser)
    }
    
    enum WaterfallUserType {
        case Following(user: PFUser)
        case Follower(user: PFUser)
    }

    
    var tableType = TableType.Landing
    
    func dataWillLoad() {
        var section = DTableViewModelSection()
        var row = DTableViewModelRow()
        
        switch tableType {
        case .Landing:
            viewControllerTitle = "Duang"
            
            row = DTableViewModelRow()
            row.rowType = DTableViewModelRow.RowType.Image(heightForRow: UIScreen.mainScreen().bounds.width, image: DuangImage.Welcome, imageFile: nil, function: DTableViewModelRow.Function.Nothing)
            section.rowArray.append(row)
            sectionArray.append(section)
            
            row = DTableViewModelRow()
            section = DTableViewModelSection()
            let buttonItemSignUp = DTableViewModelRow.ButtonItem.ButtonItemTitle(style: DTableViewModelRow.ButtonItem.ButtonItemStyle.Normal, buttonText: "Sign up", function: functionShowSignUp)
            let buttonItemLogin = DTableViewModelRow.ButtonItem.ButtonItemTitle(style: DTableViewModelRow.ButtonItem.ButtonItemStyle.Normal, buttonText: "Log in", function: functionShowLogIn)
            row.rowType = DTableViewModelRow.RowType.Buttons(buttonItemArray: [buttonItemSignUp, buttonItemLogin])
            section.rowArray.append(row)
            sectionArray.append(section)
            
            dataDidLoad()
            
        case .SignUp:
            viewControllerTitle = "Sign up"
            
            let textViewTitleArray = ["Username:", "Password:", "Email:"]
            let textViewTextArray = ["", "", ""]
            section = textViewGroup(textViewTitleArray, textViewTextArray: textViewTextArray)
            sectionArray.append(section)
            
            section = DTableViewModelSection()
            addButtonNormal(section, buttonText: "Sign up", function: functionSignUp)
            sectionArray.append(section)
            
            dataDidLoad()
            
        case .LogIn:
            viewControllerTitle = "Log in"
            
            let textViewTitleArray = ["Username:", "Password:"]
            let textViewTextArray = ["", ""]
            section = textViewGroup(textViewTitleArray, textViewTextArray: textViewTextArray)
            sectionArray.append(section)
            
            section = DTableViewModelSection()
            addButtonNormal(section, buttonText: "Log in", function: functionLogIn)
            sectionArray.append(section)
            
            dataDidLoad()
            
        case .Settings:
            viewControllerTitle = "Settings"
            
            section = DTableViewModelSection()
            addButtonNormal(section, buttonText: "Edit profile", function: functionShowEditProfile)
            addButtonNormal(section, buttonText: "Account settings", function: functionShowAccountSettings)
            sectionArray.append(section)
            
            section = DTableViewModelSection()
            addButtonNormal(section, buttonText: "Log out", function: functionLogOut)
            sectionArray.append(section)
            
            dataDidLoad()
            
        case .EditProfile:
            viewControllerTitle = "Edit profile"
            
            let user = PFUser.currentUser()
            
            row = DTableViewModelRow()
            var buttonItem = DTableViewModelRow.ButtonItem.ButtonItemTitle(style: DTableViewModelRow.ButtonItem.ButtonItemStyle.Normal, buttonText: "Edit", function: functionEditAvatar)
            
            row.rowType = DTableViewModelRow.RowType.DetailImage(image: nil, imageFile: APIManager.getFileFromUser(user, key: TableUser.Avatar), detailTitle: "Avatar", detailButtonItem: buttonItem)
            section.rowArray.append(row)
            
            row = DTableViewModelRow()
            buttonItem = DTableViewModelRow.ButtonItem.ButtonItemTitle(style: DTableViewModelRow.ButtonItem.ButtonItemStyle.Normal, buttonText: "Edit", function: functionEditBanner)
            
            row.rowType = DTableViewModelRow.RowType.DetailImage(image: nil, imageFile: APIManager.getFileFromUser(user, key: TableUser.Banner), detailTitle: "Banner", detailButtonItem: buttonItem)
            section.rowArray.append(row)
            
            sectionArray.append(section)
            
            let textViewTitleArray = ["First name:", "Last name:", "Description:"]
            let textViewTextArray = [APIManager.getStringFromUser(user, key: TableUser.FirstName) ?? "", APIManager.getStringFromUser(user, key: TableUser.LastName) ?? "", APIManager.getStringFromUser(user, key: TableUser.Description) ?? ""]
            section = textViewGroup(textViewTitleArray, textViewTextArray: textViewTextArray)
            sectionArray.append(section)
            
            section = DTableViewModelSection()
            addButtonNormal(section, buttonText: "Save", function: functionSaveEditProfile)
            sectionArray.append(section)
            
            dataDidLoad()
            
        case .AccountSettings:
            viewControllerTitle = "Account settings"
            
            let user = PFUser.currentUser()
            let textViewTitleArray = ["Email:"]
            let textViewTextArray = [user?.email ?? ""]
            section = textViewGroup(textViewTitleArray, textViewTextArray: textViewTextArray)
            sectionArray.append(section)
            
            section = DTableViewModelSection()
            addButtonNormal(section, buttonText: "Save", function: functionSaveAccountSettings)
            sectionArray.append(section)
            
            section = DTableViewModelSection()
            addButtonNormal(section, buttonText: "Change password", function: functionShowChangePassword)
            sectionArray.append(section)
            
            dataDidLoad()
            
        case .ChangePassword:
            viewControllerTitle = "Change password"
            
            let textViewTitleArray = ["Old passowrd:", "New password:", "Retype password:"]
            let textViewTextArray = ["", "", ""]
            section = textViewGroup(textViewTitleArray, textViewTextArray: textViewTextArray)
            sectionArray.append(section)
            
            section = DTableViewModelSection()
            addButtonNormal(section, buttonText: "Save", function: functionSaveChangePassword)
            sectionArray.append(section)
            
            dataDidLoad()
            
        case .AddPhoto:
            viewControllerTitle = "Add a photo"
            
            let textViewTitleArray = ["Description:"]
            let textViewTextArray = [""]
            section = textViewGroup(textViewTitleArray, textViewTextArray: textViewTextArray)
            sectionArray.append(section)
            
            section = DTableViewModelSection()
            addButtonNormal(section, buttonText: "Select a photo", function: functionAddPhoto)
            sectionArray.append(section)
            
            section = DTableViewModelSection()
            addButtonNormal(section, buttonText: "Save", function: functionSaveAddPhoto)
            sectionArray.append(section)
            
            dataDidLoad()
            
        case .AddCollection:
            viewControllerTitle = "Create a collection"
            
            let textViewTitleArray = ["Name:"]
            let textViewTextArray = [""]
            section = textViewGroup(textViewTitleArray, textViewTextArray: textViewTextArray)
            sectionArray.append(section)
            
            section = DTableViewModelSection()
            addButtonNormal(section, buttonText: "Save", function: functionSaveAddCollection)
            sectionArray.append(section)
            
            dataDidLoad()
            
        case .Profile(let user):
            profileInit(user)
            
        case .WaterfallPhoto(_), .WaterfallUser(_), .WaterfallComment(_):
            waterfallInit()
        }
    }
    
    func dataDidLoad() {
        status = Status.Normal
        delegate?.dataDidLoad()
    }
    
    var sectionArray = [DTableViewModelSection]()
    
    func row(indexPath: NSIndexPath) -> DTableViewModelRow? {
        if indexPath.section < sectionArray.count {
            let rowArray = sectionArray[indexPath.section].rowArray
            if indexPath.row < rowArray.count {
                return rowArray[indexPath.row]
            }
        }
        return nil
    }
    
    
    // MARK: - Waterfall
    
    func waterfallInit() {
        switch tableType {
        case .WaterfallPhoto(let type):
            switch type {
            case .Feed:
                viewControllerTitle = "Feed"
            case .User(let user):
                viewControllerTitle = APIManager.getNameFromUser(user)
            case .Like(let user):
                viewControllerTitle = APIManager.getNameFromUser(user)
            }
            pageInit()
        case .WaterfallUser(let type):
            switch type {
            case .Following(_):
                viewControllerTitle = "Following"
            case .Follower(_):
                viewControllerTitle = "Follower"
            }
            pageInit()
        case .WaterfallComment(let photo):
            viewControllerTitle = "Comment"
            var section = DTableViewModelSection()
            var row = DTableViewModelRow()
            
            let user = APIManager.getUserFromObject(photo, key: TablePhoto.Owner)
            
            row.rowType = DTableViewModelRow.RowType.DetailUser(user: user, detailButtonType: nil)
            section.rowArray.append(row)
            
            row = DTableViewModelRow()
            row.rowType = DTableViewModelRow.RowType.Label(text: APIManager.getStringFromObject(photo, key: TablePhoto.Description), font: UIFont.preferredFontForTextStyle(UIFontTextStyleBody))
            section.rowArray.append(row)
            
            row = DTableViewModelRow()
            let heightForRow = APIManager.getHeightFromPhoto(photo)
            row.rowType = DTableViewModelRow.RowType.Image(heightForRow: heightForRow, image: ImagePlaceholder.Image, imageFile: APIManager.getFileFromObject(photo, key: TablePhoto.Image), function: nil)
            section.rowArray.append(row)
            
            sectionArray.append(section)
            
            let textViewTitleArray = ["Comment:"]
            let textViewTextArray = [""]
            section = textViewGroup(textViewTitleArray, textViewTextArray: textViewTextArray)
            sectionArray.append(section)
            
            section = DTableViewModelSection()
            addButtonNormal(section, buttonText: "Leave a comment", function: functionSaveComment)
            sectionArray.append(section)
            
            pageInit()
        default:
            break
        }
    }
    
    private func waterfallSendRequest() {
        switch tableType {
        case .WaterfallPhoto(let type):
            switch type {
            case .Feed:
                APIManager.sharedInstance.getPhotoArray(pageSize, page: pageCount, user: nil, success: { (objectArray) -> () in
                    self.waterfallPhotoSendRequestSuccess(objectArray)
                }, failure: { (error) -> () in
                    self.waterfallSendRequestFailure()
                })
            case .User(let user):
                APIManager.sharedInstance.getPhotoArray(pageSize, page: pageCount, user: user, success: { (objectArray) -> () in
                    self.waterfallPhotoSendRequestSuccess(objectArray)
                }, failure: { (error) -> () in
                    self.waterfallSendRequestFailure()
                })
            case .Like(let user):
                APIManager.fetchPhotoArrayLike(pageSize, page: pageCount, user: user, success: { (objectArray) -> () in
                    self.waterfallPhotoSendRequestSuccess(objectArray)
                }, failure: { (error) -> () in
                    self.waterfallSendRequestFailure()
                })
            }
        case .WaterfallUser(let type):
            switch type {
            case .Following(let user):
                APIManager.fetchFollowingArray(pageSize, page: pageCount, user: user, success: { (userArray) -> () in
                    self.waterfallUserSendRequestSuccess(userArray)
                }, failure: { (error) -> () in
                    self.waterfallSendRequestFailure()
                })
            case .Follower(let user):
                APIManager.fetchFollowerArray(pageSize, page: pageCount, user: user, success: { (userArray) -> () in
                    self.waterfallUserSendRequestSuccess(userArray)
                }, failure: { (error) -> () in
                    self.waterfallSendRequestFailure()
                })
            }
        case .WaterfallComment(let photo):
            APIManager.fetchCommentArray(pageSize, page: pageCount, photo: photo, success: { (objectArray) -> () in
                self.waterfallCommentSendRequestSuccess(objectArray)
            }, failure: { (error) -> () in
                self.waterfallSendRequestFailure()
            })
        default:
            break
        }
    }
    
    // MARK: Waterfall Success
    
    private func waterfallPhotoSendRequestSuccess(objectArray: [PFObject]) {
        pageEnd(objectArray.count)
        
        var section = DTableViewModelSection()
        var row = DTableViewModelRow()
        
        for photo in objectArray {
            section = DTableViewModelSection()
            row = DTableViewModelRow()
            
            let user = APIManager.getUserFromObject(photo, key: TablePhoto.Owner)

            row.rowType = DTableViewModelRow.RowType.DetailUser(user: user, detailButtonType: DTableViewModelRow.ButtonType.Follow)
            section.rowArray.append(row)
            
            row = DTableViewModelRow()
            row.rowType = DTableViewModelRow.RowType.Label(text: APIManager.getStringFromObject(photo, key: TablePhoto.Description), font: UIFont.preferredFontForTextStyle(UIFontTextStyleBody))
            section.rowArray.append(row)
            
            row = DTableViewModelRow()
            let heightForRow = APIManager.getHeightFromPhoto(photo)
            row.rowType = DTableViewModelRow.RowType.Image(heightForRow: heightForRow, image: ImagePlaceholder.Image, imageFile: APIManager.getFileFromObject(photo, key: TablePhoto.Image), function: nil)
            section.rowArray.append(row)
            
            row = DTableViewModelRow()
            row.rowType = DTableViewModelRow.RowType.ButtonsWaterfall(photo: photo)
            section.rowArray.append(row)
            
            sectionArray.append(section)
        }
        dataDidLoad()
    }
    
    private func waterfallUserSendRequestSuccess(userArray: [PFUser]) {
        pageEnd(userArray.count)
        
        var section = DTableViewModelSection()
        var row = DTableViewModelRow()
        
        for user in userArray {
            section = DTableViewModelSection()
            row = DTableViewModelRow()
            
            row.rowType = DTableViewModelRow.RowType.DetailUser(user: user, detailButtonType: DTableViewModelRow.ButtonType.Follow)
            section.rowArray.append(row)
            
            sectionArray.append(section)
        }
        dataDidLoad()
    }
    
    private func waterfallCommentSendRequestSuccess(objectArray: [PFObject]) {
        pageEnd(objectArray.count)
        
        var section = DTableViewModelSection()
        var row = DTableViewModelRow()
        
        for comment in objectArray {
            section = DTableViewModelSection()
            row = DTableViewModelRow()
            
            let user = APIManager.getUserFromObject(comment, key: TablePhotoComment.User)
            
            row.rowType = DTableViewModelRow.RowType.DetailUser(user: user, detailButtonType: nil)
            section.rowArray.append(row)
            
            row = DTableViewModelRow()
            row.rowType = DTableViewModelRow.RowType.Label(text: APIManager.getStringFromObject(comment, key: TablePhotoComment.Message), font: UIFont.preferredFontForTextStyle(UIFontTextStyleBody))
            section.rowArray.append(row)
            
            sectionArray.append(section)
        }
        dataDidLoad()
    }
    
    // MARK: Waterfall Failure
    
    private func waterfallSendRequestFailure() {
        pageUpdating = false
        dataDidLoad()
    }
    
    // MARK: Page Control
    
    private var pageCount: NSInteger = 1
    private var pageSize: NSInteger = 50
    private var pageIfEnd = false
    private var pageUpdating = false
    
    private func pageInit() {
        pageCount = 1
        pageIfEnd = false
        pageUpdating = false
        waterfallSendRequest()
    }
    
    func pageMore() {
        if !pageIfEnd && !pageUpdating {
            ++pageCount
            waterfallSendRequest()
            pageUpdating = true
        }
    }
    
    func pageEnd(objectArrayCount: NSInteger) {
        pageUpdating = false
        if objectArrayCount < pageSize {
            pageIfEnd = true
        }
    }
    
    // MARK: - Profile
    
    func profileInit(user: PFUser) {
        var section = DTableViewModelSection()
        var row = DTableViewModelRow()
        
        APIManager.fetchUser(user, success: { (theUser) -> () in
            if theUser == PFUser.currentUser() {
                self.viewControllerTitle = TabBarTitle.MyProfile
            } else {
                self.viewControllerTitle = APIManager.getNameFromUser(theUser)
            }
            
            row = DTableViewModelRow()
            if theUser == PFUser.currentUser() {
                let buttonItemSetting = DTableViewModelRow.ButtonItem.ButtonItemTitle(style: DTableViewModelRow.ButtonItem.ButtonItemStyle.Normal, buttonText: "Settings", function: self.functionShowSettings)
                row.rowType = DTableViewModelRow.RowType.DetailUser(user: user, detailButtonType: DTableViewModelRow.ButtonType.ButtonItem(buttonItem: buttonItemSetting))
                section.rowArray.append(row)
            } else {
                row.rowType = DTableViewModelRow.RowType.DetailUser(user: user, detailButtonType: nil)
                section.rowArray.append(row)
            }
            
            row = DTableViewModelRow()
            APIManager.fetchProfileCount(theUser, success: { (photo, like, following, follower) -> () in
                let buttonItemPhoto = DTableViewModelRow.ButtonItem.ButtonItemTitleSubtitle(style: DTableViewModelRow.ButtonItem.ButtonItemStyle.Normal, buttonTitleText: "\(photo)", buttonSubtitleText: "Photos", function: self.functionShowWaterfallPhotoUser)
                let buttonItemLike = DTableViewModelRow.ButtonItem.ButtonItemTitleSubtitle(style: DTableViewModelRow.ButtonItem.ButtonItemStyle.Normal, buttonTitleText: "\(like)", buttonSubtitleText: "Likes", function: self.functionShowWaterfallPhotoLike)
                let buttonItemFollowing = DTableViewModelRow.ButtonItem.ButtonItemTitleSubtitle(style: DTableViewModelRow.ButtonItem.ButtonItemStyle.Normal, buttonTitleText: "\(following)", buttonSubtitleText: "Following", function: self.functionShowWaterfallUserFollowing)
                let buttonItemFollower = DTableViewModelRow.ButtonItem.ButtonItemTitleSubtitle(style: DTableViewModelRow.ButtonItem.ButtonItemStyle.Normal, buttonTitleText: "\(follower)", buttonSubtitleText: "Followers", function: self.functionShowWaterfallUserFollower)
                
                row.rowType = DTableViewModelRow.RowType.Buttons(buttonItemArray: [buttonItemPhoto, buttonItemLike, buttonItemFollowing, buttonItemFollower])
                section.rowArray.append(row)
                self.sectionArray.append(section)
                
                APIManager.fetchPhotoCollectionArray(theUser, success: { (objectArray) -> () in
                    for collection in objectArray {
                        var section = DTableViewModelSection()
                        var row = DTableViewModelRow()
                        
                        row.rowType = DTableViewModelRow.RowType.ImageMutable(collection: collection)
                        
                        section.rowArray.append(row)
                        self.sectionArray.append(section)
                    }
                    
                    
                    section = DTableViewModelSection()
                    self.addButtonNormal(section, buttonText: "Create a collection", function: self.functionShowAddCollection)
                    self.sectionArray.append(section)
                    
                    self.dataDidLoad()
                })
            })
        })
    }
    
    // MARK: - Comment
    
    func addComment(photo: PFObject, message: String) {
        let textViewTitleArray = ["Comment:"]
        let textViewTextArray = [""]
        sectionArray[1] = textViewGroup(textViewTitleArray, textViewTextArray: textViewTextArray)
        
        
        var section = DTableViewModelSection()
        var row = DTableViewModelRow()
        
        let user = PFUser.currentUser()
        
        row.rowType = DTableViewModelRow.RowType.DetailUser(user: user, detailButtonType: nil)
        section.rowArray.append(row)
        
        row = DTableViewModelRow()
        row.rowType = DTableViewModelRow.RowType.Label(text: message, font: UIFont.preferredFontForTextStyle(UIFontTextStyleBody))
        section.rowArray.append(row)
        
        sectionArray.insert(section, atIndex: 3) 
    }
    
    
    // MARK: - Add Button
    
    private func addButtonNormal(section: DTableViewModelSection, buttonText: String, function: DTableViewModelRow.Function) {
        let row = DTableViewModelRow()
        let buttonItem = DTableViewModelRow.ButtonItem.ButtonItemTitle(style: DTableViewModelRow.ButtonItem.ButtonItemStyle.Normal, buttonText: buttonText, function: function)
        row.rowType = DTableViewModelRow.RowType.Buttons(buttonItemArray: [buttonItem])
        section.rowArray.append(row)
    }
    
    // MARK: - TextView Group
    
    private func textViewGroup(textViewTitleArray: [String], textViewTextArray: [String]) -> DTableViewModelSection {
        var returnSection = DTableViewModelSection()
        
        let textViewTitleWidth = APIManager.widthMaxForStrings(textViewTitleArray, font: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline))
        let textViewWidth = UIScreen.mainScreen().bounds.width - textViewTitleWidth - (DuangGlobal.spacing * 3)
        
        for var index = 0; index < textViewTitleArray.count; ++index {
            let row = DTableViewModelRow()
            let heightForRow = cellTextViewHeightForRow(textViewTextArray[index], font: UIFont.preferredFontForTextStyle(UIFontTextStyleBody), width: textViewWidth)
            row.rowType = DTableViewModelRow.RowType.TextView(heightForRow: heightForRow, textViewTitle: textViewTitleArray[index], textViewText: textViewTextArray[index], textViewTitleWidth: textViewTitleWidth)
            returnSection.rowArray.append(row)
        }
        return returnSection
    }
    
    private func cellTextViewHeightForRow(string: String?, font: UIFont, width: CGFloat) -> CGFloat {
        var returnValue: CGFloat = 0
        
        if let theString = string {
            var textView = UITextView()
            textView.text = theString
            textView.font = font
            returnValue = textView.sizeThatFits(CGSizeMake(width, CGFloat.max)).height + (DuangGlobal.spacing * 2)
        }
        
        if returnValue < 50.0 {
            returnValue = 50.0
        }
        return returnValue
    }
    
    // MARK: - Function

    var functionShowSignUp = DTableViewModelRow.Function.Nothing
    var functionShowLogIn = DTableViewModelRow.Function.Nothing
    var functionShowSettings = DTableViewModelRow.Function.Nothing
    var functionShowEditProfile = DTableViewModelRow.Function.Nothing
    var functionShowAccountSettings = DTableViewModelRow.Function.Nothing
    var functionShowChangePassword = DTableViewModelRow.Function.Nothing
    
    var functionShowAddCollection = DTableViewModelRow.Function.Nothing
    
    var functionShowWaterfallPhotoUser = DTableViewModelRow.Function.Nothing
    var functionShowWaterfallPhotoLike = DTableViewModelRow.Function.Nothing
    
    var functionShowWaterfallUserFollowing = DTableViewModelRow.Function.Nothing
    var functionShowWaterfallUserFollower = DTableViewModelRow.Function.Nothing
    
    var functionShowProfile = DTableViewModelRow.Function.Nothing
    
    var functionSaveAddPhoto = DTableViewModelRow.Function.Nothing
    var functionSaveAddCollection = DTableViewModelRow.Function.Nothing
    var functionSaveEditProfile = DTableViewModelRow.Function.Nothing
    var functionSaveAccountSettings = DTableViewModelRow.Function.Nothing
    var functionSaveChangePassword = DTableViewModelRow.Function.Nothing
    var functionSaveComment = DTableViewModelRow.Function.Nothing
    
    
    var functionSignUp = DTableViewModelRow.Function.Nothing
    var functionLogIn = DTableViewModelRow.Function.Nothing
    var functionLogOut = DTableViewModelRow.Function.Nothing
    var functionEditAvatar = DTableViewModelRow.Function.Nothing
    var functionEditBanner = DTableViewModelRow.Function.Nothing
    var functionAddPhoto = DTableViewModelRow.Function.Nothing
    
}