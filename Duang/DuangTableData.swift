//
//  DuangTableData.swift
//  Duang
//
//  Created by David Yu on 15/3/17.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import Foundation

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
    
    func addSectionCommentHeader(post: PFObject?, tapActionUser: () -> (), tapActionImage: () -> (), tapActionComment: () -> ()) {
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
    
    // MARK: - TextView
    
    func addTextView(placeholder: String?) {
        var section = DuangTableDataSection()
        section.addTextView(placeholder)
        self.sectionArray.append(section)
    }
    
    // MARK: ImageSmall
    
    func addImageSmallSelectImage(imageTitle: String, tapAction: () -> ()) {
        var section = DuangTableDataSection()
        section.rowArray.append(DuangTableDataSection.DuangTableDataRow.ImageSmall(imageTitle: imageTitle, imagePlaceholder: ImagePlaceholder.Image, imageFile: nil, isRound: false, tapAction: DuangTableDataSection.function0(tapAction)))
        self.sectionArray.append(section)
    }
    
    // MARK: Buttons
    
    func addButtonsTitleImageNormal(buttonText: String, buttonImage: UIImage, tapAction: DuangTableDataSection.DuangTableDataRowFunction) {
        var section = DuangTableDataSection()
        let buttonItem = DuangTableDataSection.buttonItemTitleImageNormal(buttonText, buttonImage: buttonImage, function: tapAction)
        let buttonArray = [buttonItem]
        section.rowArray.append(DuangTableDataSection.DuangTableDataRow.Buttons(buttonArray: buttonArray, thePFObject: nil))
        self.sectionArray.append(section)
    }
    
    func addButtons1(buttonText: String, function: () -> ()) {
        var section = DuangTableDataSection()
        section.addButtons1(buttonText, function: function)
        self.sectionArray.append(section)
        
//        var section = DuangTableDataSection()
//        let buttonItem = DuangTableDataSection.buttonItemTitleNormal(buttonText, function: DuangTableDataSection.DuangTableDataRowFunction.Function0(argumentCount: 0, function: function))
//        let buttonArray = [buttonItem]
//        section.rowArray.append(DuangTableDataSection.DuangTableDataRow.Buttons(buttonArray: buttonArray, thePFObject: nil))
//        self.sectionArray.append(section)
    }
}

