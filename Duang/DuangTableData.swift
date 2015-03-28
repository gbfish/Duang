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
    
    /*
    func getString(sectionIndex: NSInteger, rowIndex: NSInteger, textArrayIndex: NSInteger) -> String? {
        if sectionIndex < sectionArray.count {
            if let rowArray = sectionArray[sectionIndex].rowArray {
                if rowIndex < rowArray.count {
                    if let textArray = rowArray[rowIndex].textArray {
                        if textArrayIndex < textArray.count {
                            return textArray[textArrayIndex]
                        }
                    }
                }
            }
        }
        return nil
    }*/
}

class DuangTableDataSection
{
    init() {}
    
    var sectionTitleForHeader = ""
    var rowArray = [DuangTableDataRow]()
    
    enum DuangTableDataRow {
        case UserBig(userName: String, userDescription: String, userAvatarPlaceholder: UIImage, userAvatarFile: PFFile?, userBannerPlaceholder: UIImage, userBannerFile: PFFile?, tapAction: () -> ())
        case ImageMutable
        case ImageBig(cellHeight: CGFloat, imagePlaceholder: UIImage, imageFile: PFFile?, tapAction: () -> ())
        case ImageSmall(imageTitle: String, imagePlaceholder: UIImage, imageFile: PFFile?, isRound: Bool, tapAction: () -> ())
        case TextView(placeholder: String)
        case TextField(placeholder: String)
        case Button(buttonText: String, buttonTextColor: UIColor, buttonBackgroundColor: UIColor, tapAction: () -> ())
        case DefaultRightDetail(titleText: String, detailText: String, tapAction: () -> ())
        
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
            case .Button(_):
                return 50.0
            case .DefaultRightDetail(_):
                return 50.0
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
            case .Button(_):
                return "DuangTableCellButton"
            case .DefaultRightDetail(_):
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
            default:
                break
            }
        }
    }
    
    
    /*
    class func initSection(#sectionTitleForHeader: String?, rowType: DuangTableDataRow.RowType?, cellHeight: CGFloat?, textArray: [String?]?, imageFileArray: [PFFile?]?, imageArray: [UIImage?]?, colorArray: [UIColor]?, function: DuangTableDataRow.Function?) -> DuangTableDataSection {
        let section = DuangTableDataSection()
        section.sectionTitleForHeader = sectionTitleForHeader
        section.rowArray = [DuangTableDataRow]()
        section.addRow(rowType, cellHeight: cellHeight, textArray: textArray, imageFileArray: imageFileArray, imageArray: imageArray, colorArray: colorArray, function: function)
        return section
    }
    
    func addRow(rowType: DuangTableDataRow.RowType?, cellHeight: CGFloat?, textArray: [String?]?, imageFileArray: [PFFile?]?, imageArray: [UIImage?]?, colorArray: [UIColor]?, function: DuangTableDataRow.Function?) {
        let row = DuangTableDataRow()
        row.rowType = rowType
        row.cellHeight = cellHeight
        row.textArray = textArray
        row.imageFileArray = imageFileArray
        row.imageArray = imageArray
        row.colorArray = colorArray
        row.function = function
        rowArray?.append(row)
    }
    */
    
}

// MARK: - Father Data Item
/*
class DuangTableDataRow
{
    init(rowType: RowType) {
        super.init()
        self.title = aTitle
    }
    
    enum RowType{
        case UserBig(name: String, description: String, avatar: PFFile, banner: PFFile, action: () -> ())
        case UserSmall
    }
    var rowType: RowType?
    
//    let data = DataRowType.UserBig(name: "My name", description: "my description")
//    
//    
//    func someFunc() {
//        switch data {
//        case DataRowType.UserBig(let name, let description):
//            println("name = \(name) - description = \(description)")
//        default:
//            break
//        }
//    }
    
    /*
    // MARK: - RowType
    
    enum RowType{
        case UserBig
        case UserSmall
        case ImageMutable
        case ImageBig
        case ImageSmall
        case Input
        case TextField
        case Button
        case DefaultRightDetail
    }
    
    var rowType: RowType?
    
    // MARK: - Function
    
    enum Function {
        case Nothing
        case Function1 ( Void -> Void )
    }
    
    var function: Function?
    
    // Get Item at Index
    
    var cellHeight: CGFloat?
    var imageFileArray: [PFFile?]?
    var textArray: [String?]?
    var imageArray: [UIImage?]?
    var colorArray: [UIColor]?
    
    func getImageFileArray(index: NSInteger) -> PFFile? {
        if let array = imageFileArray {
            if index < array.count {
                if let returnValue = array[index] {
                    return returnValue
                }
            }
        }
        return nil
    }
    
    func getTextArray(index: NSInteger) -> String? {
        if let array = textArray {
            if index < array.count {
                return array[index]
            }
        }
        return nil
    }
    
    func getImageArray(index: NSInteger) -> UIImage? {
        if let array = imageArray {
            if index < array.count {
                return array[index]
            }
        }
        return nil
    }
    
    func getColorArray(index: NSInteger) -> UIColor? {
        
        
        
        
        if let array = colorArray {
            if index < array.count {
                return array[index]
            }
        }
        return nil
    }*/
}

*/
