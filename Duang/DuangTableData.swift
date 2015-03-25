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
}

// MARK: - Father Data Array

class DuangTableDataSection
{
    init() {}
    
    var sectionTitleForHeader: String?
    var rowArray: [DuangTableDataRow]?
    
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
}

// MARK: - Father Data Item

class DuangTableDataRow
{
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
    }
}