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
        case Feed
        case MyProfile
        case Settings
        case EditProfile
        case AccountSettings
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
            
        case .SignUp:
            viewControllerTitle = "Sign up"
            
            let stringArray = ["Username:", "Password:", "Email:"]
            let widthMax = APIManager.widthMaxForStrings(stringArray, font: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline))
            
            row = DTableViewModelRow()
            row.rowType = DTableViewModelRow.RowType.TextView(heightForRow: 50.0, textViewTitle: stringArray[0], textViewText: nil, textViewTitleWidth: widthMax)
            section.rowArray.append(row)
            
            row = DTableViewModelRow()
            row.rowType = DTableViewModelRow.RowType.TextView(heightForRow: 50.0, textViewTitle: stringArray[1], textViewText: nil, textViewTitleWidth: widthMax)
            section.rowArray.append(row)
            
            row = DTableViewModelRow()
            row.rowType = DTableViewModelRow.RowType.TextView(heightForRow: 50.0, textViewTitle: stringArray[2], textViewText: nil, textViewTitleWidth: widthMax)
            section.rowArray.append(row)
            sectionArray.append(section)
            
            row = DTableViewModelRow()
            section = DTableViewModelSection()
            let buttonItem = DTableViewModelRow.ButtonItem.ButtonItemTitle(style: DTableViewModelRow.ButtonItem.ButtonItemStyle.Normal, buttonText: "Sign up", function: functionSignUp)
            row.rowType = DTableViewModelRow.RowType.Buttons(buttonItemArray: [buttonItem])
            section.rowArray.append(row)
            sectionArray.append(section)
            
        case .LogIn:
            viewControllerTitle = "Log in"
            
            let stringArray = ["Username:", "Password:"]
            let widthMax = APIManager.widthMaxForStrings(stringArray, font: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline))
            
            row = DTableViewModelRow()
            row.rowType = DTableViewModelRow.RowType.TextView(heightForRow: 50.0, textViewTitle: stringArray[0], textViewText: nil, textViewTitleWidth: widthMax)
            section.rowArray.append(row)
            
            row = DTableViewModelRow()
            row.rowType = DTableViewModelRow.RowType.TextView(heightForRow: 50.0, textViewTitle: stringArray[1], textViewText: nil, textViewTitleWidth: widthMax)
            section.rowArray.append(row)
            sectionArray.append(section)
            
            row = DTableViewModelRow()
            section = DTableViewModelSection()
            let buttonItem = DTableViewModelRow.ButtonItem.ButtonItemTitle(style: DTableViewModelRow.ButtonItem.ButtonItemStyle.Normal, buttonText: "Log in", function: functionLogIn)
            row.rowType = DTableViewModelRow.RowType.Buttons(buttonItemArray: [buttonItem])
            section.rowArray.append(row)
            sectionArray.append(section)
            
        case .Feed:
            viewControllerTitle = "Feed"
            
            APIManager.sharedInstance.getPhotoArray(50, page: 1, success: { (objectArray) -> () in
                for object in objectArray {
                    section = DTableViewModelSection()
                    
                    row = DTableViewModelRow()
                    let user = APIManager.getUserFromObject(object, key: TablePhoto.Owner)
                    row.rowType = DTableViewModelRow.RowType.Detail(image: ImagePlaceholder.Avatar, imageFile: APIManager.getFileFromUser(user, key: TableUser.Avatar), isRound: true, detailTitle: APIManager.getNameFromUser(user), detailButton: nil)
                    section.rowArray.append(row)
                    
                    row = DTableViewModelRow()
                    row.rowType = DTableViewModelRow.RowType.Label(text: APIManager.getStringFromObject(object, key: TablePhoto.Description), font: UIFont.preferredFontForTextStyle(UIFontTextStyleBody))
                    section.rowArray.append(row)
                    
                    row = DTableViewModelRow()
                    
                    let heightForRow = APIManager.getHeightFromPhoto(object)
                    row.rowType = DTableViewModelRow.RowType.Image(heightForRow: heightForRow, image: ImagePlaceholder.Image, imageFile: APIManager.getFileFromObject(object, key: TablePhoto.Image), function: nil)
                    section.rowArray.append(row)
                    
                    self.sectionArray.append(section)
                }
                self.dataDidLoad()
                
            }, failure: { (error) -> () in
                self.dataDidLoad()
            })
            
        case .MyProfile:
            viewControllerTitle = "Me"
            
            row = DTableViewModelRow()
            let user = PFUser.currentUser()
            let buttonItemSetting = DTableViewModelRow.ButtonItem.ButtonItemTitle(style: DTableViewModelRow.ButtonItem.ButtonItemStyle.Normal, buttonText: "Settings", function: functionShowSettings)
            row.rowType = DTableViewModelRow.RowType.Detail(image: ImagePlaceholder.Avatar, imageFile: APIManager.getFileFromUser(user, key: TableUser.Avatar), isRound: true, detailTitle: APIManager.getNameFromUser(user), detailButton: buttonItemSetting)
            section.rowArray.append(row)
            
            sectionArray.append(section)
            
        case .Settings:
            viewControllerTitle = "Settings"
            
            row = DTableViewModelRow()
            section = DTableViewModelSection()
            var buttonItem = DTableViewModelRow.ButtonItem.ButtonItemTitle(style: DTableViewModelRow.ButtonItem.ButtonItemStyle.Normal, buttonText: "Edit profile", function: functionShowEditProfile)
            row.rowType = DTableViewModelRow.RowType.Buttons(buttonItemArray: [buttonItem])
            section.rowArray.append(row)
            
            row = DTableViewModelRow()
            buttonItem = DTableViewModelRow.ButtonItem.ButtonItemTitle(style: DTableViewModelRow.ButtonItem.ButtonItemStyle.Normal, buttonText: "Account settings", function: functionShowAccountSettings)
            row.rowType = DTableViewModelRow.RowType.Buttons(buttonItemArray: [buttonItem])
            section.rowArray.append(row)
            
            sectionArray.append(section)
            
            section = DTableViewModelSection()
            row = DTableViewModelRow()
            buttonItem = DTableViewModelRow.ButtonItem.ButtonItemTitle(style: DTableViewModelRow.ButtonItem.ButtonItemStyle.Normal, buttonText: "Log out", function: functionLogOut)
            row.rowType = DTableViewModelRow.RowType.Buttons(buttonItemArray: [buttonItem])
            section.rowArray.append(row)
            sectionArray.append(section)
            
        case .EditProfile:
            viewControllerTitle = "Edit profile"
            
            let user = PFUser.currentUser()
            
            row = DTableViewModelRow()
            var buttonItem = DTableViewModelRow.ButtonItem.ButtonItemTitle(style: DTableViewModelRow.ButtonItem.ButtonItemStyle.Normal, buttonText: "Edit", function: functionEditAvatar)
            row.rowType = DTableViewModelRow.RowType.Detail(image: ImagePlaceholder.Avatar, imageFile: APIManager.getFileFromUser(user, key: TableUser.Avatar), isRound: true, detailTitle: "Avatar", detailButton: buttonItem)
            section.rowArray.append(row)
            
            row = DTableViewModelRow()
            buttonItem = DTableViewModelRow.ButtonItem.ButtonItemTitle(style: DTableViewModelRow.ButtonItem.ButtonItemStyle.Normal, buttonText: "Edit", function: functionEditBanner)
            row.rowType = DTableViewModelRow.RowType.Detail(image: ImagePlaceholder.Image, imageFile: APIManager.getFileFromUser(user, key: TableUser.Banner), isRound: false, detailTitle: "Banner", detailButton: buttonItem)
            section.rowArray.append(row)
            
            sectionArray.append(section)
            
            section = DTableViewModelSection()
            
            let textViewTitleArray = ["First name:", "Last name:", "Description"]
            let textViewTextArray = [APIManager.getStringFromUser(user, key: TableUser.FirstName), APIManager.getStringFromUser(user, key: TableUser.LastName), APIManager.getStringFromUser(user, key: TableUser.Description)]
            
            let textViewTitleWidth = APIManager.widthMaxForStrings(textViewTitleArray, font: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline))
            let textViewWidth = UIScreen.mainScreen().bounds.width - textViewTitleWidth - (DuangGlobal.spacing * 3)
            
            for index in 0...2 {
                row = DTableViewModelRow()
                let heightForRow = cellTextViewHeightForRow(textViewTextArray[index], font: UIFont.preferredFontForTextStyle(UIFontTextStyleBody), width: textViewWidth)
                row.rowType = DTableViewModelRow.RowType.TextView(heightForRow: heightForRow, textViewTitle: textViewTitleArray[index], textViewText: textViewTextArray[index], textViewTitleWidth: textViewTitleWidth)
                section.rowArray.append(row)
            }
            
            sectionArray.append(section)
            
            row = DTableViewModelRow()
            section = DTableViewModelSection()
            buttonItem = DTableViewModelRow.ButtonItem.ButtonItemTitle(style: DTableViewModelRow.ButtonItem.ButtonItemStyle.Normal, buttonText: "Save", function: functionSaveEditProfile)
            row.rowType = DTableViewModelRow.RowType.Buttons(buttonItemArray: [buttonItem])
            section.rowArray.append(row)
            sectionArray.append(section)
            
        case .AccountSettings:
            viewControllerTitle = "Account settings"
        }
        
        dataDidLoad()
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
    
    // MARK: - Size
    
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
    
    var functionSaveEditProfile = DTableViewModelRow.Function.Nothing
    
    var functionSignUp = DTableViewModelRow.Function.Nothing
    var functionLogIn = DTableViewModelRow.Function.Nothing
    var functionLogOut = DTableViewModelRow.Function.Nothing
    var functionEditAvatar = DTableViewModelRow.Function.Nothing
    var functionEditBanner = DTableViewModelRow.Function.Nothing
    
    

}