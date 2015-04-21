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
    
    
    
    
    
    
    
    
    
    
    
    /*
    // MARK: TextView
    
    func addTextView(placeholder: String?) {
        let row = DuangTableDataRow()
        row.rowType = DuangTableDataRow.RowType.TextView(placeholder: placeholder)
        self.rowArray.append(row)
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
            
            var theLikeCount = "0"
            if let likeCount: NSNumber = thePost[TablePost.LikeCount] as? NSNumber {
                theLikeCount = "\(likeCount)"
            }
            let buttonLike = DuangTableDataSection.buttonItemTitleImageNormal(theLikeCount, buttonImage: DuangImage.Like, function: DuangTableDataSection.function1PFObject(tapActionLike, argument: thePost))
            
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
        let buttonItem = DuangTableDataSection.buttonItemTitleNormal(buttonText, function: DuangTableDataSection.DuangTableDataRowFunction.Function0(argumentCount: 0, function: function))
        let buttonArray = [buttonItem]
        self.rowArray.append(DuangTableDataSection.DuangTableDataRow.Buttons(buttonArray: buttonArray, thePFObject: nil))
    }
    
    func addButtons2(buttonText1: String, function1: () -> (), buttonText2: String, function2: () -> ()) {
        let buttonItem1 = DuangTableDataRowButtonItem.ButtonItemTitle(style: DuangTableDataRowButtonItem.DuangTableDataRowButtonItemStyle.Normal, buttonText: buttonText1, function: DuangTableDataSection.DuangTableDataRowFunction.Function0(argumentCount: 0, function: function1))
        let buttonItem2 = DuangTableDataRowButtonItem.ButtonItemTitle(style: DuangTableDataRowButtonItem.DuangTableDataRowButtonItemStyle.Normal, buttonText: buttonText2, function: DuangTableDataSection.DuangTableDataRowFunction.Function0(argumentCount: 0, function: function2))
        let buttonArray = [buttonItem1, buttonItem2]
        self.rowArray.append(DuangTableDataSection.DuangTableDataRow.Buttons(buttonArray: buttonArray, thePFObject: nil))
        
        
        DuangTableDataRowButtonItem.ButtonItemTitle(style: DuangTableDataSection.DuangTableDataRowButtonItem.DuangTableDataRowButtonItemStyle.Normal, buttonText: buttonText1, function: DuangTableDataSection.DuangTableDataRowFunction.Function0(argumentCount: 0, function: function1))
    }
    
        */
    
    
//    class func buttonItemTitleImageNormal(buttonText: String, buttonImage: UIImage, function: DuangTableDataRowFunction) -> DuangTableDataRowButtonItem {
//        return DuangTableDataRowButtonItem.ButtonItemTitleImage(buttonText: buttonText, buttonTextColor: DuangColor.DarkBlue, buttonBackgroundColor: DuangColor.White, borderColor: DuangColor.DarkBlue, buttonImage: buttonImage, function: function)
//    }
//    
//    class func buttonItemTitleImageSelected(buttonText: String, buttonImage: UIImage, function: DuangTableDataRowFunction) -> DuangTableDataRowButtonItem {
//        return DuangTableDataRowButtonItem.ButtonItemTitleImage(buttonText: buttonText, buttonTextColor: DuangColor.DarkBlue, buttonBackgroundColor: DuangColor.Orange, borderColor: DuangColor.DarkBlue, buttonImage: buttonImage, function: function)
//    }
//    
//    class func buttonItemTitleNormal(buttonText: String, function: DuangTableDataRowFunction) -> DuangTableDataRowButtonItem {
//        return DuangTableDataRowButtonItem.ButtonItemTitle(buttonText: buttonText, buttonTextColor: DuangColor.DarkBlue, buttonBackgroundColor: DuangColor.White, borderColor: DuangColor.DarkBlue, function: function)
//    }
    
    }