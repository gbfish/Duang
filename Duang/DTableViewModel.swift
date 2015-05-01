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
        case MyProfile
        case Settings
        case EditProfile
        case AccountSettings
        case ChangePassword
        case AddPhoto
        
        case Waterfall(waterfallType: WaterfallType)
        case Profile(user: PFUser)
    }
    
    enum WaterfallType {
        case Feed
        case PhotosUser(user: PFUser)
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
            
            section = DTableViewModelSection()
            let textViewTitleArray = ["Username:", "Password:", "Email:"]
            let textViewTextArray = ["", "", ""]
            addTextViewGroup(section, textViewTitleArray: textViewTitleArray, textViewTextArray: textViewTextArray)
            sectionArray.append(section)
            
            section = DTableViewModelSection()
            addButtonNormal(section, buttonText: "Sign up", function: functionSignUp)
            sectionArray.append(section)
            
            dataDidLoad()
            
        case .LogIn:
            viewControllerTitle = "Log in"
            
            section = DTableViewModelSection()
            let textViewTitleArray = ["Username:", "Password:"]
            let textViewTextArray = ["", ""]
            addTextViewGroup(section, textViewTitleArray: textViewTitleArray, textViewTextArray: textViewTextArray)
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
            
            row.rowType = DTableViewModelRow.RowType.DetailUser(image: nil, user: user, detailButtonItem: buttonItem)
            section.rowArray.append(row)
            
            row = DTableViewModelRow()
            buttonItem = DTableViewModelRow.ButtonItem.ButtonItemTitle(style: DTableViewModelRow.ButtonItem.ButtonItemStyle.Normal, buttonText: "Edit", function: functionEditBanner)
            
            row.rowType = DTableViewModelRow.RowType.DetailImage(image: nil, imageFile: APIManager.getFileFromUser(user, key: TableUser.Banner), detailTitle: "Banner", detailButtonItem: buttonItem)
            section.rowArray.append(row)
            
            sectionArray.append(section)
            
            section = DTableViewModelSection()
            let textViewTitleArray = ["First name:", "Last name:", "Description:"]
            let textViewTextArray = [APIManager.getStringFromUser(user, key: TableUser.FirstName) ?? "", APIManager.getStringFromUser(user, key: TableUser.LastName) ?? "", APIManager.getStringFromUser(user, key: TableUser.Description) ?? ""]
            addTextViewGroup(section, textViewTitleArray: textViewTitleArray, textViewTextArray: textViewTextArray)
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
            addTextViewGroup(section, textViewTitleArray: textViewTitleArray, textViewTextArray: textViewTextArray)
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
            
            section = DTableViewModelSection()
            let textViewTitleArray = ["Old passowrd:", "New password:", "Retype password:"]
            let textViewTextArray = ["", "", ""]
            addTextViewGroup(section, textViewTitleArray: textViewTitleArray, textViewTextArray: textViewTextArray)
            sectionArray.append(section)
            
            section = DTableViewModelSection()
            addButtonNormal(section, buttonText: "Save", function: functionSaveChangePassword)
            sectionArray.append(section)
            
            dataDidLoad()
            
        case .AddPhoto:
            viewControllerTitle = "Add a photo"
            
            section = DTableViewModelSection()
            let textViewTitleArray = ["Description:"]
            let textViewTextArray = [""]
            addTextViewGroup(section, textViewTitleArray: textViewTitleArray, textViewTextArray: textViewTextArray)
            sectionArray.append(section)
            
            section = DTableViewModelSection()
            addButtonNormal(section, buttonText: "Select a photo", function: functionAddPhoto)
            sectionArray.append(section)
            
            section = DTableViewModelSection()
            addButtonNormal(section, buttonText: "Save", function: functionSaveAddPhoto)
            sectionArray.append(section)
            
            dataDidLoad()
            
        case .Waterfall(let waterfallType):
            switch waterfallType {
            case .Feed:
                viewControllerTitle = "Feed"
                waterfallInit()
                
            case .PhotosUser(let user):
                viewControllerTitle = APIManager.getNameFromUser(user)
                waterfallInit()
            }
            
        case .MyProfile:
            viewControllerTitle = "Me"
            
            row = DTableViewModelRow()
            let user = PFUser.currentUser()
            let buttonItemSetting = DTableViewModelRow.ButtonItem.ButtonItemTitle(style: DTableViewModelRow.ButtonItem.ButtonItemStyle.Normal, buttonText: "Settings", function: functionShowSettings)
            
            row.rowType = DTableViewModelRow.RowType.DetailUser(image: nil, user: user, detailButtonItem: buttonItemSetting)
            section.rowArray.append(row)
            
            row = DTableViewModelRow()
            let buttonItemPhoto = DTableViewModelRow.ButtonItem.ButtonItemTitleSubtitle(style: DTableViewModelRow.ButtonItem.ButtonItemStyle.Normal, buttonTitleText: "5", buttonSubtitleText: "Photos", function: functionShowWaterfallUser)
            let buttonItemLike = DTableViewModelRow.ButtonItem.ButtonItemTitleSubtitle(style: DTableViewModelRow.ButtonItem.ButtonItemStyle.Normal, buttonTitleText: "52", buttonSubtitleText: "Likes", function: functionShowSignUp)
            let buttonItemFollowing = DTableViewModelRow.ButtonItem.ButtonItemTitleSubtitle(style: DTableViewModelRow.ButtonItem.ButtonItemStyle.Normal, buttonTitleText: "15", buttonSubtitleText: "Following", function: functionShowSignUp)
            let buttonItemFollower = DTableViewModelRow.ButtonItem.ButtonItemTitleSubtitle(style: DTableViewModelRow.ButtonItem.ButtonItemStyle.Normal, buttonTitleText: "53", buttonSubtitleText: "Followers", function: functionShowSignUp)
            
            row.rowType = DTableViewModelRow.RowType.Buttons(buttonItemArray: [buttonItemPhoto, buttonItemLike, buttonItemFollowing, buttonItemFollower])
            section.rowArray.append(row)
            
            sectionArray.append(section)
            
            dataDidLoad()
            
        case .Profile(let user):
            viewControllerTitle = "Profile"
            
            profileInit(user)
            
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
    
    var waterfallPageCount: NSInteger = 1
    var waterfallPageSize: NSInteger = 50
    
    var waterfallEnd = false
    var waterfallUpdating = false
    
    func waterfallInit() {
        waterfallPageCount = 1
        waterfallEnd = false
        waterfallUpdating = false
        waterfallSendRequest()
    }
    
    func waterfallMore() {
        if !waterfallEnd && !waterfallUpdating {
            ++waterfallPageCount
            waterfallSendRequest()
        }
    }
    
    private func waterfallSendRequest() {
        switch tableType {
        case .Waterfall(let waterfallType):
            switch waterfallType {
            case .Feed:
                waterfallUpdating = true
                APIManager.sharedInstance.getPhotoArray(waterfallPageSize, page: waterfallPageCount, user: nil, success: { (objectArray) -> () in
                    self.waterfallSendRequestSuccess(objectArray)
                }, failure: { (error) -> () in
                    self.waterfallSendRequestFailure()
                })
                
            case .PhotosUser(let user):
                waterfallUpdating = true
                APIManager.sharedInstance.getPhotoArray(waterfallPageSize, page: waterfallPageCount, user: user, success: { (objectArray) -> () in
                    self.waterfallSendRequestSuccess(objectArray)
                }, failure: { (error) -> () in
                    self.waterfallSendRequestFailure()
                })
            }
        default:
            break
        }
    }
    
    private func waterfallSendRequestSuccess(objectArray: [PFObject]) {
        waterfallUpdating = false
        if objectArray.count < waterfallPageSize {
            waterfallEnd = true
        }
        
        var section = DTableViewModelSection()
        var row = DTableViewModelRow()
        
        for object in objectArray {
            section = DTableViewModelSection()
            row = DTableViewModelRow()
            
            let user = APIManager.getUserFromObject(object, key: TablePhoto.Owner)

            row.rowType = DTableViewModelRow.RowType.DetailUser(image: nil, user: user, detailButtonItem: nil)
            section.rowArray.append(row)
            
            row = DTableViewModelRow()
            row.rowType = DTableViewModelRow.RowType.Label(text: APIManager.getStringFromObject(object, key: TablePhoto.Description), font: UIFont.preferredFontForTextStyle(UIFontTextStyleBody))
            section.rowArray.append(row)
            
            row = DTableViewModelRow()
            let heightForRow = APIManager.getHeightFromPhoto(object)
            row.rowType = DTableViewModelRow.RowType.Image(heightForRow: heightForRow, image: ImagePlaceholder.Image, imageFile: APIManager.getFileFromObject(object, key: TablePhoto.Image), function: nil)
            section.rowArray.append(row)
            
            sectionArray.append(section)
        }
        dataDidLoad()
    }
    
    private func waterfallSendRequestFailure() {
        waterfallUpdating = false
        dataDidLoad()
    }
    
    // MARK: - Profile
    
    func profileInit(user: PFUser) {
        var section = DTableViewModelSection()
        var row = DTableViewModelRow()
        
        APIManager.fetchUser(user, success: { (theUser) -> () in
            self.viewControllerTitle = APIManager.getNameFromUser(theUser)
            
            row = DTableViewModelRow()
            let user = PFUser.currentUser()
            let buttonItemSetting = DTableViewModelRow.ButtonItem.ButtonItemTitle(style: DTableViewModelRow.ButtonItem.ButtonItemStyle.Normal, buttonText: "Settings", function: self.functionShowSettings)
            
            row.rowType = DTableViewModelRow.RowType.DetailUser(image: nil, user: user, detailButtonItem: buttonItemSetting)
            section.rowArray.append(row)
            
            row = DTableViewModelRow()
            
            APIManager.fetchPhotoTotal(theUser, success: { (photoTotal) -> () in
                let buttonItemPhoto = DTableViewModelRow.ButtonItem.ButtonItemTitleSubtitle(style: DTableViewModelRow.ButtonItem.ButtonItemStyle.Normal, buttonTitleText: "\(photoTotal)", buttonSubtitleText: "Photos", function: self.functionShowWaterfallUser)
                
                let buttonItemLike = DTableViewModelRow.ButtonItem.ButtonItemTitleSubtitle(style: DTableViewModelRow.ButtonItem.ButtonItemStyle.Normal, buttonTitleText: "52", buttonSubtitleText: "Likes", function: self.functionShowSignUp)
                let buttonItemFollowing = DTableViewModelRow.ButtonItem.ButtonItemTitleSubtitle(style: DTableViewModelRow.ButtonItem.ButtonItemStyle.Normal, buttonTitleText: "15", buttonSubtitleText: "Following", function: self.functionShowSignUp)
                let buttonItemFollower = DTableViewModelRow.ButtonItem.ButtonItemTitleSubtitle(style: DTableViewModelRow.ButtonItem.ButtonItemStyle.Normal, buttonTitleText: "53", buttonSubtitleText: "Followers", function: self.functionShowSignUp)
                
                row.rowType = DTableViewModelRow.RowType.Buttons(buttonItemArray: [buttonItemPhoto, buttonItemLike, buttonItemFollowing, buttonItemFollower])
                
                section.rowArray.append(row)
                
                self.sectionArray.append(section)
                
                self.dataDidLoad()
            })
            
            
            
            
            
            
            
        })
        
        
        
    }
    
    // MARK: - Add Button
    
    private func addButtonNormal(section: DTableViewModelSection, buttonText: String, function: DTableViewModelRow.Function) {
        let row = DTableViewModelRow()
        let buttonItem = DTableViewModelRow.ButtonItem.ButtonItemTitle(style: DTableViewModelRow.ButtonItem.ButtonItemStyle.Normal, buttonText: buttonText, function: function)
        row.rowType = DTableViewModelRow.RowType.Buttons(buttonItemArray: [buttonItem])
        section.rowArray.append(row)
    }
    
    // MARK: - Add TextView Group
    
    private func addTextViewGroup(section: DTableViewModelSection, textViewTitleArray: [String], textViewTextArray: [String]) {
        let textViewTitleWidth = APIManager.widthMaxForStrings(textViewTitleArray, font: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline))
        let textViewWidth = UIScreen.mainScreen().bounds.width - textViewTitleWidth - (DuangGlobal.spacing * 3)
        
        for var index = 0; index < textViewTitleArray.count; ++index {
            let row = DTableViewModelRow()
            let heightForRow = cellTextViewHeightForRow(textViewTextArray[index], font: UIFont.preferredFontForTextStyle(UIFontTextStyleBody), width: textViewWidth)
            row.rowType = DTableViewModelRow.RowType.TextView(heightForRow: heightForRow, textViewTitle: textViewTitleArray[index], textViewText: textViewTextArray[index], textViewTitleWidth: textViewTitleWidth)
            section.rowArray.append(row)
        }
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
    var functionShowWaterfallUser = DTableViewModelRow.Function.Nothing
    
    
    var functionSaveEditProfile = DTableViewModelRow.Function.Nothing
    var functionSaveAccountSettings = DTableViewModelRow.Function.Nothing
    var functionSaveChangePassword = DTableViewModelRow.Function.Nothing
    var functionSaveAddPhoto = DTableViewModelRow.Function.Nothing
    
    var functionSignUp = DTableViewModelRow.Function.Nothing
    var functionLogIn = DTableViewModelRow.Function.Nothing
    var functionLogOut = DTableViewModelRow.Function.Nothing
    var functionEditAvatar = DTableViewModelRow.Function.Nothing
    var functionEditBanner = DTableViewModelRow.Function.Nothing
    var functionAddPhoto = DTableViewModelRow.Function.Nothing
    

}