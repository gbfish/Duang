//
//  DuangTableData.swift
//  Duang
//
//  Created by David Yu on 15/3/17.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import Foundation
import UIKit
import Parse

class DuangTableData
{
    var sectionArray = [DuangTableDataSection]()
    
    // MARK: - Post
    
    func addSectionPost(post: PFObject?, tapActionUser: () -> (), tapActionImage: () -> (), tapActionShare: (PFObject?) -> (), tapActionComment: (PFObject?) -> (), tapActionLike: (PFObject?) -> ()) {
        if let thePost = post {
            var section = DuangTableDataSection()
            section.addImageSmallUser(APIManager.getUserFromObject(thePost, key: TablePost.Owner), tapAction: tapActionUser)
            section.addRowLabel(APIManager.getStringFromObject(thePost, key: TablePost.Title), textFont: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline))
            section.addRowLabel(APIManager.getStringFromObject(thePost, key: TablePost.Description), textFont: UIFont.preferredFontForTextStyle(UIFontTextStyleBody))
            section.addImageMutable(thePost.relationForKey(TablePost.Photos), tapAction: tapActionImage)
            section.addButtonsForPost(thePost, tapActionShare: tapActionShare, tapActionComment: tapActionComment, tapActionLike: tapActionLike)
            self.sectionArray.append(section)
        }
    }
    
    // MARK: - Comment
    
    func addSectionCommentHeader(post: PFObject?, tapActionUser: () -> (), tapActionImage: () -> (), tapActionComment: (PFObject?) -> ()) {
        if let thePost = post {
            var section = DuangTableDataSection()
            section.addImageSmallUser(APIManager.getUserFromObject(thePost, key: TablePost.Owner), tapAction: tapActionUser)
            section.addRowLabel(APIManager.getStringFromObject(thePost, key: TablePost.Title), textFont: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline))
            section.addRowLabel(APIManager.getStringFromObject(thePost, key: TablePost.Description), textFont: UIFont.preferredFontForTextStyle(UIFontTextStyleBody))
            section.addImageMutable(thePost.relationForKey(TablePost.Photos), tapAction: tapActionImage)
            section.addButtons(thePost, tapAction: tapActionComment)
            self.sectionArray.append(section)
        }
    }
}

class DuangTableDataSection
{
    init() {}
    
    var sectionTitleForHeader = ""
    var rowArray = [DuangTableDataRow]()
    
    enum DuangTableDataRow {
        case UserBig(userName: String, userDescription: String, userAvatarPlaceholder: UIImage, userAvatarFile: PFFile?, userBannerPlaceholder: UIImage, userBannerFile: PFFile?, tapAction: () -> ())
        case ImageMutable(photos: PFRelation, tapAction: () -> ())
        case ImageBig(cellHeight: CGFloat, imagePlaceholder: UIImage, imageFile: PFFile?, tapAction: () -> ())
        case ImageSmall(imageTitle: String, imagePlaceholder: UIImage, imageFile: PFFile?, isRound: Bool, tapAction: () -> ())
        case TextView(placeholder: String)
        case TextField(placeholder: String)
        case Label(cellHeight: CGFloat, text: String, font: UIFont)
        case Button(buttonText: String, buttonTextColor: UIColor, buttonBackgroundColor: UIColor, tapAction: () -> ())
        case DefaultRightDetail(titleText: String, detailText: String, tapAction: () -> ())
        case Message(ownerAvatarFile: PFFile?, ownerName: String, time: String, message: String)
        
        case Buttons(buttonArray: [DuangTableDataRow], post: PFObject?)
        case ButtonItem(buttonText: String, buttonTextColor: UIColor, buttonBackgroundColor: UIColor, borderColor: UIColor, buttonImage: UIImage, post: PFObject?, tapAction: (PFObject?) -> ())
        
        func cellHeight() -> CGFloat {
            switch self {
            case .UserBig(_):
                return UIScreen.mainScreen().bounds.size.width
            case .ImageMutable:
                return UIScreen.mainScreen().bounds.size.width
            case .ImageBig(let cellHeight, _, _, _):
                return cellHeight
            case .ImageSmall(_):
                return 50.0
            case .TextView(_):
                return 200.0
            case .TextField(_):
                return 50.0
            case .Label(let cellHeight, _, _):
                return cellHeight
            case .Button(_):
                return 50.0
            case .DefaultRightDetail(_):
                return 50.0
            case .Buttons(_):
                return 50.0
            default:
                return 0.0
            }
        }
        
        func cellIdentifier() -> String {
            switch self {
            case .UserBig(_):
                return "DuangTableCellUserBig"
            case .ImageMutable:
                return "DuangTableCellImageMutable"
            case .ImageBig(_):
                return "DuangTableCellImageBig"
            case .ImageSmall(_):
                return "DuangTableCellImageSmall"
            case .TextView(_):
                return "DuangTableCellTextView"
            case .TextField(_):
                return "DuangTableCellTextField"
            case .Label(_):
                return "DuangTableCellLabel"
            case .Button(_):
                return "DuangTableCellButton"
            case .DefaultRightDetail(_):
                return "DefaultCell"
            case .Buttons(_):
                return "DuangTableCellButtons"
            default:
                return "DefaultCell"
            }
        }
        
        func tapAction() {
            switch self {
            case .UserBig(_, _, _, _, _, _, let tapAction):
                tapAction()
            case .ImageBig(_, _, _, let tapAction):
                tapAction()
            case .ImageSmall(_, _, _, _, let tapAction):
                tapAction()
            case .Button(_, _, _, let tapAction):
                tapAction()
            case .DefaultRightDetail(_, _, let tapAction):
                tapAction()
                
                
            case .ButtonItem(_, _, _, _, _, let post, let tapAction):
                tapAction(post)
            default:
                break
            }
        }
    }
    
    // MARK: - ImageMutable
    
    func addImageMutable(photos: PFRelation?, tapAction: () -> ()) {
        if let thePhotos = photos {
            self.rowArray.append(DuangTableDataSection.DuangTableDataRow.ImageMutable(photos: thePhotos, tapAction: tapAction))
        }
    }
    
    // MARK: - ImageSmall
    
    func addImageSmallUser(user: PFUser?, tapAction: () -> ()) {
        if let therUser = user {
            self.rowArray.append(DuangTableDataSection.DuangTableDataRow.ImageSmall(imageTitle: APIManager.getNameFromUser(therUser), imagePlaceholder: ImagePlaceholder.Avatar, imageFile: APIManager.getFileFromUser(therUser, key: TableUser.Avatar), isRound: true, tapAction: tapAction))
        }
    }
    
    // MARK: - Label
    
    func addRowLabel(textString: String?, textFont: UIFont) {
        if let theText = textString {
            let size = APIManager.sizeForString(theText, font: textFont, width: DuangGlobal.screenWidth - 20.0, height: CGFloat.max)
            self.rowArray.append(DuangTableDataSection.DuangTableDataRow.Label(cellHeight: size.height, text: theText, font: textFont))
        }
    }
    
    // MARK: - Buttons
    
    func addButtonsForPost(post: PFObject?, tapActionShare: (PFObject?) -> (), tapActionComment: (PFObject?) -> (), tapActionLike: (PFObject?) -> ()) {
        if let thePost = post {
            let buttonShare = DuangTableDataSection.DuangTableDataRow.ButtonItem(buttonText: "share 0", buttonTextColor: DuangColor.DarkBlue, buttonBackgroundColor: DuangColor.Orange, borderColor: DuangColor.DarkBlue, buttonImage: DuangImage.Share, post: thePost, tapAction: tapActionShare)
            let buttonComment = DuangTableDataSection.DuangTableDataRow.ButtonItem(buttonText: "comment 0", buttonTextColor: DuangColor.DarkBlue, buttonBackgroundColor: DuangColor.Orange, borderColor: DuangColor.DarkBlue, buttonImage: DuangImage.Comment, post: thePost, tapAction: tapActionComment)
            let buttonLike = DuangTableDataSection.DuangTableDataRow.ButtonItem(buttonText: "\(thePost[TablePost.LikeCount])", buttonTextColor: DuangColor.DarkBlue, buttonBackgroundColor: DuangColor.Orange, borderColor: DuangColor.DarkBlue, buttonImage: DuangImage.Like, post: thePost, tapAction: tapActionLike)
            let buttonArray = [buttonShare, buttonComment, buttonLike]
            self.rowArray.append(DuangTableDataSection.DuangTableDataRow.Buttons(buttonArray: buttonArray, post: thePost))
        }
    }
    
    func addButtons(post: PFObject?, tapAction: (PFObject?) -> ()) {
        if let thePost = post {
            let buttonItem = DuangTableDataSection.DuangTableDataRow.ButtonItem(buttonText: "Leave a comment", buttonTextColor: DuangColor.DarkBlue, buttonBackgroundColor: DuangColor.Orange, borderColor: DuangColor.DarkBlue, buttonImage: DuangImage.Like, post: thePost, tapAction: tapAction)
            let buttonArray = [buttonItem]
            self.rowArray.append(DuangTableDataSection.DuangTableDataRow.Buttons(buttonArray: buttonArray, post: thePost))
        }
    }
}