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
    
    class func initSectionDefaultRightDetail(#sectionTitleForHeader: String, rowTitleString: String, rowDetailString: String, didSelectFunc: DuangTableDataRow.DidSelectFunc) -> DuangTableDataSection {
        let section = DuangTableDataSection()
        section.sectionTitleForHeader = sectionTitleForHeader
        section.rowArray.append(DuangTableDataRow.initRowDefaultRightDetail(rowTitleString, rowDetailString: rowDetailString, didSelectFunc: didSelectFunc))
        return section
    }
}

// MARK: - Father Data Item

class DuangTableDataRow {
    class func initRowDefaultRightDetail(titleString: String, rowDetailString: String, didSelectFunc: DidSelectFunc) -> DuangTableDataRow {
        let row = DuangTableDataRow()
        row.rowType = DuangTableDataRow.RowType.DefaultRightDetail
        row.rowTitleString = titleString
        row.rowDetailString = rowDetailString
        row.didSelectFunc = didSelectFunc
        return row
    }
    
    enum RowType{
        case UserBig
        case UserSmall
        case Input
        case Button
        case TextField
        case DefaultRightDetail
    }
    
    var rowType = RowType.Button
    
    // MARK: - 
    
    var rowTitleString = ""
    var rowDetailString = ""
    var rowImageFile: PFFile = PFFile()
    
    // MARK: - Reload
    
    // MARK: - Did Select Func
    
    enum DidSelectFunc {
        case Nothing
        case Function1 ( Void -> Void )
//        case Function2 ( (String, String) -> Void)
    }
    
    var didSelectFunc = DidSelectFunc.Nothing
}