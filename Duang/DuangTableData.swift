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

class DuangTableData {
    var sectionArray = [DuangTableDataSection]()
}

// MARK: - Father Data Array

class DuangTableDataSection {
    var sectionTitleForHeader = ""
    var rowArray = [DuangTableDataRow]()
    
    class func initSectionInput(#sectionTitleForHeader: String) -> DuangTableDataSection {
        let section = DuangTableDataSection()
        section.sectionTitleForHeader = sectionTitleForHeader
        section.rowArray.append(DuangTableDataRow.initRowInput())
        return section
    }
    
    class func initSectionTextField(#sectionTitleForHeader: String, rowTitleString: String) -> DuangTableDataSection {
        let section = DuangTableDataSection()
        section.sectionTitleForHeader = sectionTitleForHeader
        section.rowArray.append(DuangTableDataRow.initRowTextField(rowTitleString))
        return section
    }
    
    class func initSectionButton(#sectionTitleForHeader: String, rowTitleString: String, buttonStyle: DuangTableDataRow.ButtonStyle, didSelectFunc: DuangTableDataRow.DidSelectFunc) -> DuangTableDataSection {
        let section = DuangTableDataSection()
        section.sectionTitleForHeader = sectionTitleForHeader
        section.rowArray.append(DuangTableDataRow.initRowButton(rowTitleString, rowDetailString: buttonStyle, didSelectFunc: didSelectFunc))
        return section
    }
    
    
    class func initSectionDefaultRightDetail(#sectionTitleForHeader: String, rowTitleString: String, rowDetailString: String, didSelectFunc: DuangTableDataRow.DidSelectFunc) -> DuangTableDataSection {
        let section = DuangTableDataSection()
        section.sectionTitleForHeader = sectionTitleForHeader
        section.rowArray.append(DuangTableDataRow.initRowDefaultRightDetail(rowTitleString, rowDetailString: rowDetailString, didSelectFunc: didSelectFunc))
        return section
    }
}

// MARK: - Father Data Item

class DuangTableDataRow {
    class func initRowInput() -> DuangTableDataRow {
        let row = DuangTableDataRow()
        row.rowType = DuangTableDataRow.RowType.Input
        return row
    }
    
    class func initRowTextField(rowTitleString: String) -> DuangTableDataRow {
        let row = DuangTableDataRow()
        row.rowType = DuangTableDataRow.RowType.TextField
        row.rowTitleString = rowTitleString
        return row
    }
    
    class func initRowButton(rowTitleString: String, rowDetailString: DuangTableDataRow.ButtonStyle, didSelectFunc: DidSelectFunc) -> DuangTableDataRow {
        let row = DuangTableDataRow()
        row.rowType = DuangTableDataRow.RowType.Button
        row.rowTitleString = rowTitleString
        row.buttonStyle = rowDetailString
        row.didSelectFunc = didSelectFunc
        return row
    }
    
    class func initRowDefaultRightDetail(rowTitleString: String, rowDetailString: String, didSelectFunc: DidSelectFunc) -> DuangTableDataRow {
        let row = DuangTableDataRow()
        row.rowType = DuangTableDataRow.RowType.DefaultRightDetail
        row.rowTitleString = rowTitleString
        row.rowDetailString = rowDetailString
        row.didSelectFunc = didSelectFunc
        return row
    }
    
    
    
    enum RowType{
        case UserBig
        case UserSmall
        case Input
        case TextField
        case Button
        case DefaultRightDetail
    }
    
    var rowType = RowType.Button
    
    // MARK: - 
    
    var rowTitleString = ""
    var rowDetailString = ""
    var rowImageFile: PFFile = PFFile()
    
    // MARK: - Button
    
    enum ButtonStyle {
        case Nomal
        case Alert
    }
    var buttonStyle = ButtonStyle.Nomal

    var buttonTextColor: UIColor {
        get {
            switch buttonStyle {
            case ButtonStyle.Nomal:
                return DuangColor.ButtonNormal
            case ButtonStyle.Alert:
                return DuangColor.ButtonAlert
            }
        }
    }
    
    var buttonBackgroundColor: UIColor {
        get {
            switch buttonStyle {
            case ButtonStyle.Nomal:
                return DuangColor.ButtonNormalBackground
            case ButtonStyle.Alert:
                return DuangColor.ButtonAlertBackground
            }
        }
    }
    
    // MARK: - Did Select Func
    
    enum DidSelectFunc {
        case Nothing
        case Function1 ( Void -> Void )
//        case Function2 ( (String, String) -> Void)
    }
    
    var didSelectFunc = DidSelectFunc.Nothing
}