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
    }
    
    var tableType = TableType.Landing
    
    func dataWillLoad() {
        var section = DTableViewModelSection()
        var row = DTableViewModelRow()
        
        switch tableType {
        case .Landing:
            viewControllerTitle = "Duang"
            
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
            
            let usernameSize = APIManager.sizeForString("Username:", font: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline), width: CGFloat.max, height: CGFloat.max)
            let passwordSize = APIManager.sizeForString("Password:", font: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline), width: CGFloat.max, height: CGFloat.max)
            let emailSize = APIManager.sizeForString("Email:", font: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline), width: CGFloat.max, height: CGFloat.max)
            let widthMax = max(usernameSize.width, passwordSize.width, emailSize.width)
            //
            row.rowType = DTableViewModelRow.RowType.TextView(heightForRow: 50.0, textViewTitle: "textViewTitle:", textViewText: nil, textViewTitleWidth: widthMax)
            section.rowArray.append(row)
            //
            row = DTableViewModelRow()
            row.rowType = DTableViewModelRow.RowType.TextField(textFieldTitle: "Username:", textFieldText: nil, textFieldTitleWidth: widthMax)
            section.rowArray.append(row)
            row = DTableViewModelRow()
            row.rowType = DTableViewModelRow.RowType.TextField(textFieldTitle: "Password:", textFieldText: nil, textFieldTitleWidth: widthMax)
            section.rowArray.append(row)
            row = DTableViewModelRow()
            row.rowType = DTableViewModelRow.RowType.TextField(textFieldTitle: "Email:", textFieldText: nil, textFieldTitleWidth: widthMax)
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
            
            let usernameSize = APIManager.sizeForString("Username:", font: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline), width: CGFloat.max, height: CGFloat.max)
            let passwordSize = APIManager.sizeForString("Password:", font: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline), width: CGFloat.max, height: CGFloat.max)
            let widthMax = max(usernameSize.width, passwordSize.width)
            row.rowType = DTableViewModelRow.RowType.TextField(textFieldTitle: "Username:", textFieldText: nil, textFieldTitleWidth: widthMax)
            section.rowArray.append(row)
            row = DTableViewModelRow()
            row.rowType = DTableViewModelRow.RowType.TextField(textFieldTitle: "Password:", textFieldText: nil, textFieldTitleWidth: widthMax)
            section.rowArray.append(row)
            row = DTableViewModelRow()
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
            
            
            
//            let usernameSize = APIManager.sizeForString("Username:", font: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline), width: CGFloat.max, height: CGFloat.max)
//            let passwordSize = APIManager.sizeForString("Password:", font: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline), width: CGFloat.max, height: CGFloat.max)
//            let widthMax = max(usernameSize.width, passwordSize.width)
//            row.rowType = DTableViewModelRow.RowType.TextField(textFieldTitle: "Username:", textFieldText: nil, textFieldTitleWidth: widthMax)
//            section.rowArray.append(row)
//            row = DTableViewModelRow()
//            row.rowType = DTableViewModelRow.RowType.TextField(textFieldTitle: "Password:", textFieldText: nil, textFieldTitleWidth: widthMax)
//            section.rowArray.append(row)
//            row = DTableViewModelRow()
//            sectionArray.append(section)
//            
//            row = DTableViewModelRow()
//            section = DTableViewModelSection()
//            let buttonItem = DTableViewModelRow.ButtonItem.ButtonItemTitle(style: DTableViewModelRow.ButtonItem.ButtonItemStyle.Normal, buttonText: "Log in", function: functionLogIn)
//            row.rowType = DTableViewModelRow.RowType.Buttons(buttonItemArray: [buttonItem])
//            section.rowArray.append(row)
//            sectionArray.append(section)
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
    
    // MARK: - Function

    var functionShowSignUp = DTableViewModelRow.Function.Nothing
    var functionShowLogIn = DTableViewModelRow.Function.Nothing
    
    var functionSignUp = DTableViewModelRow.Function.Nothing
    var functionLogIn = DTableViewModelRow.Function.Nothing
    

}