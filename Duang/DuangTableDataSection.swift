//
//  DuangTableDataSection.swift
//  Duang
//
//  Created by David Yu on 15/4/7.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import Foundation

class DuangTableDataSection
{
    init() {}
    
    var sectionTitleForHeader = ""
    var rowArray = [DuangTableDataRow]()
    
    // MARK: - enum DuangTableDataRow
    
    enum DuangTableDataRow {
        case UserBig(userName: String, userDescription: String, userAvatarPlaceholder: UIImage, userAvatarFile: PFFile?, userBannerPlaceholder: UIImage, userBannerFile: PFFile?, tapAction: () -> ())
        case ImageMutable(photos: PFRelation, tapAction: () -> ())
        case ImageBig(cellHeight: CGFloat, imagePlaceholder: UIImage, imageFile: PFFile?, tapAction: () -> ())
        
        case TextView(placeholder: String)
        case TextField(placeholder: String)
        case Label(cellHeight: CGFloat, text: String, font: UIFont)
        case Button(buttonText: String, buttonTextColor: UIColor, buttonBackgroundColor: UIColor, tapAction: () -> ())
        case DefaultRightDetail(titleText: String, detailText: String, tapAction: () -> ())
        case Message(ownerAvatarFile: PFFile?, ownerName: String, time: String, message: String)
        
        
        case ImageSmall(imageTitle: String, imagePlaceholder: UIImage, imageFile: PFFile?, isRound: Bool, tapAction: DuangTableDataRowFunction)
        
        case Buttons(buttonArray: [DuangTableDataRowItem], thePFObject: PFObject?)
        
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
                tapAction.functionAction()
            case .Button(_, _, _, let tapAction):
                tapAction()
            case .DefaultRightDetail(_, _, let tapAction):
                tapAction()
                
                
            default:
                break
            }
        }
    }
    
    // MARK: TextView
    
    func addTextView(placeholder: String?) {
        var thePlaceholder = ""
        if let temString = placeholder {
            thePlaceholder = temString
        }
        self.rowArray.append(DuangTableDataSection.DuangTableDataRow.TextView(placeholder: thePlaceholder))
    }
    
    // MARK: ImageMutable
    
    func addImageMutable(photos: PFRelation?, tapAction: () -> ()) {
        if let thePhotos = photos {
            self.rowArray.append(DuangTableDataSection.DuangTableDataRow.ImageMutable(photos: thePhotos, tapAction: tapAction))
        }
    }
    
    // MARK: ImageSmall
    
    func addImageSmallUser(user: PFUser?, tapAction: () -> ()) {
        if let therUser = user {
            self.rowArray.append(DuangTableDataSection.DuangTableDataRow.ImageSmall(imageTitle: APIManager.getNameFromUser(therUser), imagePlaceholder: ImagePlaceholder.Avatar, imageFile: APIManager.getFileFromUser(therUser, key: TableUser.Avatar), isRound: true, tapAction: DuangTableDataSection.function0(tapAction)))
        }
    }
    
    func addImageSmallSelectImage(imageTitle: String, tapAction: () -> ()) {
        self.rowArray.append(DuangTableDataSection.DuangTableDataRow.ImageSmall(imageTitle: imageTitle, imagePlaceholder: ImagePlaceholder.Image, imageFile: nil, isRound: false, tapAction: DuangTableDataSection.function0(tapAction)))
    }
    
    // MARK: Label
    
    func addRowLabel(textString: String?, textFont: UIFont) {
        if let theText = textString {
            let size = APIManager.sizeForString(theText, font: textFont, width: DuangGlobal.screenWidth - 20.0, height: CGFloat.max)
            self.rowArray.append(DuangTableDataSection.DuangTableDataRow.Label(cellHeight: size.height, text: theText, font: textFont))
        }
    }
    
    // MARK: Buttons
    
    func addButtonsForPost(post: PFObject?, tapActionShare: (PFObject?) -> (), tapActionComment: (PFObject?) -> (), tapActionLike: (PFObject?) -> ()) {
        if let thePost = post {
            let buttonShare = DuangTableDataSection.buttonItemTitleImageNormal("share 0", buttonImage: DuangImage.Share, function: DuangTableDataSection.function1PFObject(tapActionShare, argument: thePost))
            let buttonComment = DuangTableDataSection.buttonItemTitleImageNormal("comment 0", buttonImage: DuangImage.Comment, function: DuangTableDataSection.function1PFObject(tapActionComment, argument: thePost))
            let buttonLike = DuangTableDataSection.buttonItemTitleImageNormal("\(thePost[TablePost.LikeCount])", buttonImage: DuangImage.Like, function: DuangTableDataSection.function1PFObject(tapActionLike, argument: thePost))
            let buttonArray = [buttonShare, buttonComment, buttonLike]
            self.rowArray.append(DuangTableDataSection.DuangTableDataRow.Buttons(buttonArray: buttonArray, thePFObject: thePost))
        }
    }
    
    func addButtons(post: PFObject?, tapAction: () -> ()) {
        if let thePost = post {
            let buttonItem = DuangTableDataSection.buttonItemTitleImageNormal("Leave a comment", buttonImage: DuangImage.Comment, function: DuangTableDataSection.function0(tapAction))
            let buttonArray = [buttonItem]
            self.rowArray.append(DuangTableDataSection.DuangTableDataRow.Buttons(buttonArray: buttonArray, thePFObject: thePost))
        }
    }
    
    func addButtons1(buttonText: String, function: () -> ()) {
//        var section = DuangTableDataSection()
//        let buttonItem = DuangTableDataSection.buttonItemTitleNormal(buttonText, function: DuangTableDataSection.DuangTableDataRowFunction.Function0(argumentCount: 0, function: function))
//        let buttonArray = [buttonItem]
//        section.rowArray.append(DuangTableDataSection.DuangTableDataRow.Buttons(buttonArray: buttonArray, thePFObject: nil))
//        self.sectionArray.append(section)
        
        let buttonItem = DuangTableDataSection.buttonItemTitleNormal(buttonText, function: DuangTableDataSection.DuangTableDataRowFunction.Function0(argumentCount: 0, function: function))
        let buttonArray = [buttonItem]
        self.rowArray.append(DuangTableDataSection.DuangTableDataRow.Buttons(buttonArray: buttonArray, thePFObject: nil))
    }
    
    // MARK: - enum DuangTableDataRowItem
    
    enum DuangTableDataRowItem {
        case ButtonItemTitleImage(buttonText: String, buttonTextColor: UIColor, buttonBackgroundColor: UIColor, borderColor: UIColor, buttonImage: UIImage, function: DuangTableDataRowFunction)
        case ButtonItemTitle(buttonText: String, buttonTextColor: UIColor, buttonBackgroundColor: UIColor, borderColor: UIColor, function: DuangTableDataRowFunction)
        
        func functionAction() {
            switch self {
            case .ButtonItemTitleImage(_, _, _, _, _, let function):
                function.functionAction()
            case .ButtonItemTitle(_, _, _, _, let function):
                function.functionAction()
            }
        }
    }
    
    class func buttonItemTitleImageNormal(buttonText: String, buttonImage: UIImage, function: DuangTableDataRowFunction) -> DuangTableDataRowItem {
        return DuangTableDataRowItem.ButtonItemTitleImage(buttonText: buttonText, buttonTextColor: DuangColor.DarkBlue, buttonBackgroundColor: DuangColor.White, borderColor: DuangColor.DarkBlue, buttonImage: buttonImage, function: function)
    }
    
    class func buttonItemTitleImageSelected(buttonText: String, buttonImage: UIImage, function: DuangTableDataRowFunction) -> DuangTableDataRowItem {
        return DuangTableDataRowItem.ButtonItemTitleImage(buttonText: buttonText, buttonTextColor: DuangColor.DarkBlue, buttonBackgroundColor: DuangColor.Orange, borderColor: DuangColor.DarkBlue, buttonImage: buttonImage, function: function)
    }
    
    class func buttonItemTitleNormal(buttonText: String, function: DuangTableDataRowFunction) -> DuangTableDataRowItem {
        return DuangTableDataRowItem.ButtonItemTitle(buttonText: buttonText, buttonTextColor: DuangColor.DarkBlue, buttonBackgroundColor: DuangColor.White, borderColor: DuangColor.DarkBlue, function: function)
    }
    
    // MARK: - enum DuangTableDataRowFunction
    
    enum DuangTableDataRowFunction {
        case Function0(argumentCount: NSInteger, function: () -> ())
        case Function1PFObject(argumentCount: NSInteger, function: (PFObject?) -> (), argument: PFObject?)
        
        func functionAction() {
            switch self {
            case .Function0(let argumentCount, let function):
                function()
            case .Function1PFObject(let argumentCount, let function, let argument):
                function(argument)
            default:
                break
            }
        }
    }
    
    class func function0(function: () -> ()) -> DuangTableDataRowFunction {
        return DuangTableDataRowFunction.Function0(argumentCount: 0, function: function)
    }
    
    class func function1PFObject(function: (PFObject?) -> (), argument: PFObject?) -> DuangTableDataRowFunction {
        return DuangTableDataRowFunction.Function1PFObject(argumentCount: 1, function: function, argument: argument)
    }
}